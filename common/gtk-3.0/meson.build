# supported versions
gtk3_supported_versions = ['3.18', '3.20', '3.22', '3.24']

# glib-compile-resources dependency
glib_compile_resources = find_program('glib-compile-resources')

# determine gtk3 version
if get_option('gtk3_version') != ''
  gtk3_ver = get_option('gtk3_version')
else
  gtk3_dep = dependency(
    'gtk+-3.0',
    version: '>= 3.17.0',
    not_found_message : 'Could not determine GTK 3 version'
  )
  gtk3_ver = gtk3_dep.version()
endif

gtk3_ver_array = gtk3_ver.split('.')
if gtk3_ver_array[1].to_int().is_odd()
  # evenize development versions
  gtk3_ver_orig = gtk3_ver
  gtk3_ver_array = [gtk3_ver_array[0], (gtk3_ver_array[1].to_int() + 1).to_string(), '0']
  gtk3_ver = '.'.join(gtk3_ver_array)
  warning('GTK 3 development version ' + gtk3_ver_orig + ' detected, consider it as ' + gtk3_ver)
endif

if (gtk3_ver_array[0] + '.' + gtk3_ver_array[1]) not in gtk3_supported_versions
  warning('GTK 3 version ' + gtk3_ver + ' is not officially supported yet and can cause some bugs')
endif

if gtk3_ver.version_compare('>= 3.20')
  gtk3_dir = '3.2x'
else
  gtk3_dir = '3.1x'
endif

# represent the gtk version as an easy to compare integer for SASS (eg. '3.24.23' -> 300240023)
gtk3_ver_int = (gtk3_ver_array[0].to_int() * 100000000) + (gtk3_ver_array[1].to_int() * 10000) + (gtk3_ver_array[2].to_int() * 1)

# render PNG assets

gtk3_assets_svg = 'assets.svg'
gtk3_assets_names = run_command(
  'cat', 'assets.txt',
  check : true
).stdout().split()

gtk3_assets = []
gtk3_assets_paths = []

foreach gtk3_dpi : [['', '96'], ['@2', '192']]
  foreach gtk3_asset_name : gtk3_assets_names
    output = gtk3_asset_name + gtk3_dpi[0] + '.png'
    gtk3_assets += custom_target(
      'gtk3-' + gtk3_asset_name + gtk3_dpi[0],
      input : gtk3_assets_svg,
      output : output,
      command : [
        inkscape,
        '--export-id-only',
        inkscape_ver.version_compare('>=1.0') ? '--export-filename=@OUTPUT@' : '--export-png=@OUTPUT@',
        '--export-id=' + gtk3_asset_name,
        '--export-dpi=' + gtk3_dpi[1],
        '@INPUT@'
      ],
      build_by_default : true
    )
    gtk3_assets_paths += output
  endforeach
endforeach

# compile CSS

sass_path = meson.current_source_dir() / gtk3_dir
sass_depend_files = run_command(
  'find',
  sass_path,
  '-name', '_*.scss',
  check : true
).stdout().split()

# always compile the dark CSS
input_scss = sass_path / 'gtk.scss'
output_css_dark = 'gtk-main-dark.css'
gtk3_stylesheet_dark = custom_target(
  output_css_dark,
  input : input_scss,
  output : output_css_dark,
  command : [
    '../../lib/sass_with_vars.sh', sassc,
    '@INPUT@', '@OUTPUT@',
    '$variant: "dark";',
    '$transparency: "' + (get_option('transparency') ? 'true' : 'false') + '";',
    '$gtk3_ver_int: ' + gtk3_ver_int.to_string() + ';'
  ],
  build_by_default : true,
  depend_files : sass_depend_files
)

foreach variant : get_option('variants')
  output_suffix = (variant == 'light' ? '' : '-' + variant)
  output_css = 'gtk-main' + output_suffix + '.css'

  if variant != 'dark'
    gtk3_stylesheet = custom_target(
      output_css,
      input : input_scss,
      output : output_css,
      command : [
        '../../lib/sass_with_vars.sh', sassc,
        '@INPUT@', '@OUTPUT@',
        '$variant: "' + variant + '";',
        '$transparency: "' + (get_option('transparency') ? 'true' : 'false') + '";',
        '$gtk3_ver_int: ' + gtk3_ver_int.to_string() + ';'
      ],
      build_by_default : true,
      depend_files : sass_depend_files
    )
  else
    gtk3_stylesheet = gtk3_stylesheet_dark
  endif

  # generate the gresource XML

  gresource_xml_array = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<gresources>',
    '<gresource prefix="/org/gnome/arc-theme">'
  ]

  #TODO update asset paths in SASS files and get rid of the alias=
  foreach asset : gtk3_assets_paths
    gresource_xml_array += '<file preprocess="to-pixdata" alias="assets/' + asset + '">' + asset + '</file>'
  endforeach

  gresource_xml_array += ['<file>' + output_css + '</file>']

  if variant != 'dark'
    gresource_xml_array += ['<file>' + output_css_dark + '</file>']
  endif

  gresource_xml_array += [
    '</gresource>',
    '</gresources>'
  ]

  # compile the gresource

  gresource_xml = configure_file(
    capture : true,
    command : ['echo', gresource_xml_array],
    output : 'gtk' + output_suffix + '.gresource.xml'
  )

  #TODO use gnome.compile_resources()???
  gresource = custom_target(
    'gresource' + output_suffix,
    input : gresource_xml,
    output : 'gtk' + output_suffix + '.gresource',
    command : [
      glib_compile_resources,
      '--sourcedir=@OUTDIR@',
      '--target=@OUTPUT@',
      '@INPUT@'
    ],
    depends : [gtk3_assets, gtk3_stylesheet, gtk3_stylesheet_dark],
    build_by_default : true
  )

  # install gresource
  meson.add_install_script(
    'sh', '-c',
    'install -DT' + ' ' +
    gresource.full_path() + ' ' +
    '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk3') / 'gtk.gresource'
  )

  # install gtk.css files

  gtk3_css = configure_file(
    capture : true,
    command : ['echo', '@import url("resource:///org/gnome/arc-theme/' + output_css + '");'],
    output : 'gtk' + output_suffix + '.css'
  )

  install_data(
    gtk3_css,
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk3'),
    rename : ['gtk.css']
  )

  if variant != 'dark'
    gtk3_css_dark = configure_file(
      capture : true,
      command : ['echo', '@import url("resource:///org/gnome/arc-theme/' + output_css_dark + '");'],
      output : 'gtk' + output_suffix + '__dark.css'
    )

    install_data(
      gtk3_css_dark,
      install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk3'),
      rename : ['gtk-dark.css']
    )
  endif

  # install thumbnail
  install_data(
    variant != 'dark' ? 'thumbnail.png' : 'thumbnail-dark.png',
    rename : 'thumbnail.png',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk3')
  )
endforeach
