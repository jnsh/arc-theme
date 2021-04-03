gtk2_asset_names = run_command(
  'cat', 'assets.txt',
  check : true
).stdout().split()

subdir('light')
if 'dark' in get_option('variants') or 'darker' in get_option('variants')
  subdir('dark')
endif

foreach variant : get_option('variants')
  light_assets = gtk2_light_assets
  if variant == 'dark'
    dark_assets = gtk2_dark_assets
  endif

  if variant == 'dark'
    install_assets = dark_assets
  else
    install_assets = light_assets
  endif

  if variant == 'light' or variant == 'lighter'
    light_menubar_toolbar_assets = [
      'entry-active-toolbar',
      'entry-disabled-toolbar',
      'entry-toolbar',
      'menubar_button',
      'menubar'
    ]
  elif variant == 'dark' or variant == 'darker'
    light_menubar_toolbar_assets = [
      'button-active',
      'button-hover',
      'button-insensitive',
      'button'
    ]

    dark_menubar_toolbar_assets = [
      'entry-active-toolbar',
      'entry-disabled-toolbar',
      'entry-toolbar',
      'menubar_button',
      'menubar'
    ]
  endif

  install_data(
    [variant / 'gtkrc', 'apps.rc', 'main.rc', 'panel.rc', 'xfce-notify.rc'],
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk2')
  )

  install_data(
    variant == 'light' or variant == 'lighter' ? 'menubar-toolbar' / 'menubar-toolbar.rc' : 'menubar-toolbar' / 'menubar-toolbar-dark.rc',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk2') / 'menubar-toolbar',
  )

  foreach asset : install_assets
    meson.add_install_script(
      'sh', '-c',
      'install -D' + ' ' +
      '-t $MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk2') / 'assets' + ' ' +
      asset.full_path()
    )
  endforeach

  foreach asset : light_menubar_toolbar_assets
    meson.add_install_script(
      'sh', '-c',
      'install -D' + ' ' +
      '-t $MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk2') / 'menubar-toolbar' + ' ' +
      meson.current_build_dir() / 'light' / asset + '.png'
    )
  endforeach

  if variant == 'dark' or variant == 'darker'
    foreach asset : dark_menubar_toolbar_assets
      meson.add_install_script(
        'sh', '-c',
        'install -DT' + ' ' +
        meson.current_build_dir() / 'dark' / asset + '.png' + ' ' +
        '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk2') / 'menubar-toolbar' / asset + '-dark.png'
      )
    endforeach
  endif

endforeach
