# supported versions
gtk3_versions = ['3.18', '3.20', '3.22', '3.24']

# glib-compile-resources dependency
glib_compile_resources = find_program('glib-compile-resources')

# determine gtk3 version
if get_option('gtk3_version') != ''
  gtk3_full_ver = get_option('gtk3_version')
else
  gtk3_dep = dependency(
    'gtk+-3.0',
    version: '>= 3.17.0',
    not_found_message : 'Could not determine GTK 3 version'
  )
  gtk3_full_ver = gtk3_dep.version()
endif

gtk3_ver_array = gtk3_full_ver.split('.')
if gtk3_ver_array[1].to_int().is_even()
  gtk3_ver = gtk3_ver_array[0] + '.' + gtk3_ver_array[1]
else
  # evenize development versions
  gtk3_ver = gtk3_ver_array[0] + '.' + (gtk3_ver_array[1].to_int() + 1).to_string()
endif

if gtk3_ver not in gtk3_versions
  if gtk3_ver.version_compare('>' + gtk3_versions[-1])
    warning('GTK 3 version ' + gtk3_ver + ' not supported yet, building theme for ' + gtk3_versions[-1])
    gtk3_ver = gtk3_versions[-1]
  else
    error('Unsupported GTK 3 version')
  endif
endif

# render PNG assets

gtk3_asset_names = run_command(
  'cat', gtk3_ver / 'assets.txt',
  check : true
).stdout().split()

assets_svg = gtk3_ver / 'assets.svg'

gtk3_assets = []
gtk3_hidpi_assets = []

foreach asset : gtk3_asset_names
  gtk3_assets += custom_target(
    'gtk3-' + asset,
    input : assets_svg,
    output : asset + '.png',
    command : [
      inkscape,
      '--export-id-only',
      inkscape_ver.version_compare('>=1.0') ? '--export-filename=@OUTPUT@' : '--export-png=@OUTPUT@',
      '--export-id=' + asset,
      '--export-dpi=96',
      '@INPUT@'
    ],
    build_by_default : true
  )

  gtk3_hidpi_assets += custom_target(
    'gtk3-' + asset + '-hidpi',
    input : assets_svg,
    output : asset + '@2.png',
    command : [
      inkscape,
      '--export-id-only',
      inkscape_ver.version_compare('>=1.0') ? '--export-filename=@OUTPUT@' : '--export-png=@OUTPUT@',
      '--export-id=' + asset,
      '--export-dpi=192',
      '@INPUT@'
    ],
    build_by_default : true
  )
endforeach

# compile CSS

sass_path = meson.current_source_dir() / gtk3_ver / 'sass'
sass_depend_files = run_command(
  'find',
  sass_path,
  '-name', '_*.scss',
  check : true
).stdout().split()

# always compile the dark CSS
input_scss_dark = sass_path / (get_option('transparency') ? 'gtk-dark.scss' : 'gtk-solid-dark.scss')
output_css_dark = 'gtk-main-dark.css'
gtk3_stylesheet = custom_target(
  output_css_dark,
  input : input_scss_dark,
  output : output_css_dark,
  command : [sassc, '@INPUT@', '@OUTPUT@'],
  build_by_default : true,
  depend_files : sass_depend_files
)

foreach variant : get_option('variants')
  output_css = (variant == 'light' ? 'gtk-main.css' : 'gtk-main-' + variant + '.css')

  if variant != 'dark'
    if get_option('transparency')
      input_scss = sass_path / (variant == 'light' ? 'gtk.scss' : 'gtk-' + variant + '.scss')
    else
      input_scss = sass_path / (variant == 'light' ? 'gtk-solid.scss' : 'gtk-solid-' + variant + '.scss')
    endif

    gtk3_stylesheet = custom_target(
      output_css,
      input : input_scss,
      output : output_css,
      command : [sassc, '@INPUT@', '@OUTPUT@'],
      build_by_default : true,
      depend_files : sass_depend_files
    )
  endif

  # generate the gresource XML

  gresource_xml_array = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<gresources>',
    '<gresource prefix="/org/gnome/arc-theme">'
  ]

  #TODO update asset paths in SASS files and get rid of the alias=
  foreach asset : gtk3_asset_names
    gresource_xml_array += [
      '<file preprocess="to-pixdata" alias="assets/' + asset + '.png">' + asset + '.png</file>',
      '<file preprocess="to-pixdata" alias="assets/' + asset + '@2.png">' + asset + '@2.png</file>'
    ]
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
    output : 'gtk-' + variant + '.gresource.xml'
  )

  #TODO use gnome.compile_resources()???
  gresource = custom_target(
    'gresource-' + variant,
    input : gresource_xml,
    output : 'gtk-' + variant + '.gresource',
    command : [
      glib_compile_resources,
      '--sourcedir=@OUTDIR@',
      '--target=@OUTPUT@',
      '@INPUT@'
    ],
    depends : [gtk3_assets, gtk3_hidpi_assets, gtk3_stylesheet],
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
    output : 'gtk-' + variant + '.css'
  )

  install_data(
    gtk3_css,
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk3'),
    rename : ['gtk.css']
  )

  if variant != 'dark'
    #FIXME gtk-dark.css gets overwritten for subsequent variants, resulting in build warnings
    gtk3_dark_css = configure_file(
      capture : true,
      command : ['echo', '@import url("resource:///org/gnome/arc-theme/' + output_css_dark + '");'],
      output : 'gtk-dark.css',
      install : true,
      install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk3')
    )
  endif

  # install thumbnail
  install_data(
    variant != 'dark' ? 'light/thumbnail.png' : 'dark/thumbnail.png',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk3')
  )
endforeach
