# supported versions
cinnamon_versions = ['2.8', '3.0', '3.2', '3.4', '3.6', '3.8', '4.0', '4.2', '4.4', '4.6', '4.8']

# cinnamon version
cinnamon = find_program('cinnamon', required : false)

if get_option('cinnamon_version') != ''
  cinnamon_full_ver = get_option('cinnamon_version')
elif cinnamon.found()
  cinnamon_full_ver = run_command(cinnamon, '--version').stdout().split()[-1]
else
  error('Could not determine Cinnamon version')
endif

cinnamon_ver_array = cinnamon_full_ver.split('.')
if cinnamon_ver_array[1].to_int().is_even()
  cinnamon_ver = cinnamon_ver_array[0] + '.' + cinnamon_ver_array[1]
else
  # evenize development versions
  cinnamon_ver = cinnamon_ver_array[0] + '.' + (cinnamon_ver_array[1].to_int() + 1).to_string()
endif

if cinnamon_ver not in cinnamon_versions
  if cinnamon_ver.version_compare('>' + cinnamon_versions[-1])
    warning('Cinnamon version ' + cinnamon_ver + ' not supported yet, building theme for ' + cinnamon_versions[-1])
    cinnamon_ver = cinnamon_versions[-1]
  else
    error('Unsupported Cinnamon version')
  endif
endif

# compile and install

sass_depend_files = run_command(
  'find', '-L',
  meson.current_source_dir() / cinnamon_ver / 'sass',
  '-name', '_*.scss',
  check : true
).stdout().split()

foreach variant : get_option('variants')
  if variant != 'darker' and variant != 'lighter'
    input_scss = (variant == 'light' ? 'cinnamon.scss' : 'cinnamon-' + variant + '.scss')
    output_css = (variant == 'light' ? 'cinnamon.css' : 'cinnamon-' + variant + '.css')

    cinnamon_css = custom_target(
      output_css,
      input : meson.current_source_dir() / cinnamon_ver / 'sass' / input_scss,
      output : output_css,
      command : [sassc, '@INPUT@', '@OUTPUT@'],
      build_by_default : true,
      depend_files : sass_depend_files
    )

    meson.add_install_script(
      sh, '-c',
      'install -DT' + ' ' +
      cinnamon_css.full_path() + ' ' +
      '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('cinnamon') / 'cinnamon.css'
    )

    install_subdir(
      cinnamon_ver / 'common-assets',
      install_dir : prefix / install_dir.get(variant) / common_dirs.get('cinnamon')
    )

    install_subdir(
      cinnamon_ver / variant + '-assets',
      install_dir : prefix / install_dir.get(variant) / common_dirs.get('cinnamon')
    )

    install_data(
      variant == 'light' ? 'thumbnail.png' : 'thumbnail-dark.png',
      rename : 'thumbnail.png',
      install_dir : prefix / install_dir.get(variant) / common_dirs.get('cinnamon')
    )
  endif
endforeach
