xfwm_asset_names = run_command(
  'cat', 'assets.txt',
  check : true
).stdout().split()

if 'light' in get_option('variants') or 'lighter' in get_option('variants')
  subdir('light')
endif

if 'dark' in get_option('variants') or 'darker' in get_option('variants')
  subdir('dark')
endif

foreach variant : get_option('variants')
  if variant == 'light' or variant == 'lighter'
    themerc = 'light/themerc'
    assets = xfwm_light_assets
  elif variant == 'dark' or variant == 'darker'
    themerc = 'dark/themerc'
    assets = xfwm_dark_assets
  endif

  install_data(
    themerc,
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('xfwm')
  )

  foreach asset : assets
    meson.add_install_script(
      sh, '-c',
      'install -D ' +
      '-t $MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('xfwm') + ' ' +
      asset.full_path()
    )
  endforeach
endforeach
