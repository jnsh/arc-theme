# supported versions
gnome_shell_versions = ['3.18', '3.20', '3.22', '3.24', '3.26', '3.28', '3.30', '3.32', '3.34', '3.36', '3.38', '40']

# glib-compile-resources dependency
if get_option('gnome_shell_gresource')
  glib_compile_resources = find_program('glib-compile-resources')
endif

# gnome-shell version
gnome_shell = find_program('gnome-shell', required : false)

if get_option('gnome_shell_version') != ''
  gnome_shell_full_ver = get_option('gnome_shell_version')
elif gnome_shell.found()
  gnome_shell_full_ver = run_command(gnome_shell, '--version').stdout().split()[-1]
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

if get_option('gnome_shell_gresource')
  gresource_depend_files = []

  gresource_depend_files += [
    meson.current_source_dir() / gnome_shell_ver / 'pad-osd.css'
  ]

  gresource_depend_files += run_command(
    'find', '-L',
    meson.current_source_dir() / gnome_shell_ver / 'icons',
    meson.current_source_dir() / gnome_shell_ver / 'common-assets',
    meson.current_source_dir() / gnome_shell_ver / 'light-assets',
    meson.current_source_dir() / gnome_shell_ver / 'dark-assets',
    meson.current_source_dir() / gnome_shell_ver / 'lighter-assets',
    check : true
  ).stdout().split()
endif

# compile and install

foreach variant : get_option('variants')
  if variant != 'darker'
    if not (variant == 'lighter' and gnome_shell_ver.version_compare('<=3.30'))

      if not get_option('transparency') and not gnome_shell_ver.version_compare('<=3.30')
        input_scss = (variant == 'light' ? 'gnome-shell-solid.scss' : 'gnome-shell-solid-' + variant + '.scss')
      else
        input_scss = (variant == 'light' ? 'gnome-shell.scss' : 'gnome-shell-' + variant + '.scss')
      endif

      output_css = (variant == 'light' ? 'gnome-shell.css' : 'gnome-shell-' + variant + '.css')

      gnome_shell_css = custom_target(
        output_css,
        input : meson.current_source_dir() / gnome_shell_ver / 'sass' / input_scss,
        output : output_css,
        command : [sassc, '@INPUT@', '@OUTPUT@'],
        build_by_default : true,
        depend_files : sass_depend_files
      )

      if get_option('gnome_shell_gresource')
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
        sh, '-c',
        'install -DT' + ' ' +
        gnome_shell_css.full_path() + ' ' +
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

    endif
  endif
endforeach
