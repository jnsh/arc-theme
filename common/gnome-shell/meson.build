# supported versions
gnome_shell_versions = ['3.28', '3.30', '3.32', '3.34', '3.36', '3.38', '40', '41', '42', '43', '44', '45']

# gnome-shell version
gnome_shell = find_program('gnome-shell', required : false)

if get_option('gnome_shell_version') != ''
  gnome_shell_full_ver = get_option('gnome_shell_version')
elif gnome_shell.found()
  gnome_shell_full_ver = run_command(gnome_shell, '--version', check : true).stdout().split()[-1]
else
  error('Could not determine GNOME Shell version')
endif

gnome_shell_ver_array = gnome_shell_full_ver.split('.')
if gnome_shell_ver_array[0].to_int() < 40  
  if gnome_shell_ver_array[1].to_int().is_even()
    gnome_shell_ver = gnome_shell_ver_array[0] + '.' + gnome_shell_ver_array[1]
  else
    # evenize development versions
    gnome_shell_ver = gnome_shell_ver_array[0] + '.' + (gnome_shell_ver_array[1].to_int() + 1).to_string()
  endif
else
  gnome_shell_ver = gnome_shell_ver_array[0]
endif

if gnome_shell_ver not in gnome_shell_versions
  if gnome_shell_ver.version_compare('>' + gnome_shell_versions[-1])
    warning('GNOME Shell version ' + gnome_shell_ver + ' not supported yet, building theme for ' + gnome_shell_versions[-1])
    gnome_shell_ver = gnome_shell_versions[-1]
  else
    error('Unsupported GNOME Shell version')
  endif
endif

# dependency files

sass_depend_files = run_command(
  'find', '-L',
  meson.current_source_dir() / gnome_shell_ver / 'sass',
  '-name', '_*.scss',
  check : true
).stdout().split()

# compile and install

foreach variant : get_option('variants')

  # no darker shell theme
  if variant == 'darker'
    continue
  endif

  # lighter shell theme available only for 3.32-3.38
  if variant == 'lighter'
    if gnome_shell_ver.version_compare('<=3.30') or gnome_shell_ver.version_compare('>=40')
      continue
    endif
  endif

  # generate base SCSS file
  input_scss = configure_file(
    input: meson.current_source_dir() / gnome_shell_ver / 'sass' / 'gnome-shell.scss.in',
    output : 'gnome-shell-' + variant + '.scss',
    configuration : {
      'variant' : variant,
      'transparency' : get_option('transparency').to_string(),
      'sass_path' : meson.current_source_dir() / gnome_shell_ver / 'sass',
    }
  )

  output_css = (variant == 'light' ? 'gnome-shell.css' : 'gnome-shell-' + variant + '.css')

  gnome_shell_css = custom_target(
    output_css,
    input : input_scss,
    output : output_css,
    command : [sassc, sassc_options, '@INPUT@', '@OUTPUT@'],
    build_by_default : true,
    depend_files : sass_depend_files
  )

  if get_option('gnome_shell_gresource')

    # asset dependencies for gresource
    gresource_depend_files = []
    gresource_depend_files += [meson.current_source_dir() / gnome_shell_ver / 'pad-osd.css']
    gresource_depend_files += run_command(
      'find', '-L',
      meson.current_source_dir() / gnome_shell_ver / 'icons',
      meson.current_source_dir() / gnome_shell_ver / 'common-assets',
      meson.current_source_dir() / gnome_shell_ver / variant + '-assets',
      '-not', '-type', 'd',
      check : true
    ).stdout().split()

    gresource_name = (variant == 'light' ? 'gnome-shell-theme' : 'gnome-shell-theme-' + variant)

    gnome_shell_gresource = custom_target(
    gresource_name + '-gresource',
    input : meson.current_source_dir() / gnome_shell_ver / 'gresource' / gresource_name + '.gresource.xml',
    output : gresource_name + '.gresource',
    command : [
      glib_compile_resources,
      '--sourcedir=' + meson.current_source_dir() / gnome_shell_ver,
      '--sourcedir=' + meson.current_build_dir(),
      '--target=@OUTPUT@',
      '@INPUT@'
    ],
    build_by_default : true,
    install : true,
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gnome-shell'),
    depends : gnome_shell_css,
    depend_files: gresource_depend_files
  )
  endif

  meson.add_install_script(
    install_file,
    gnome_shell_css.full_path(),
    '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gnome-shell') / 'gnome-shell.css'
  )

  install_subdir(
    gnome_shell_ver / 'common-assets',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gnome-shell')
  )

  install_subdir(
    gnome_shell_ver / variant + '-assets',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gnome-shell')
  )

endforeach
