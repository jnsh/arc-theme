foreach variant : get_option('variants')
  # custom install script is necessary here, since install_subdir() currently installs 
  # the symlink target file, instead of the actual symlink, which doesn't install
  # dark variant correctly
  meson.add_install_script(
    sh, '-c',
    'cp -P' + ' ' +
    '-t $MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('unity') + ' ' +
    meson.current_source_dir() / '*.svg'
  )

  install_subdir(
    'dash',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('unity'),
  )

  install_subdir(
    variant == 'light' or variant == 'lighter' ? 'window-buttons' : 'window-buttons-dark',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('unity') / 'window-buttons',
    strip_directory : true
  )
endforeach
