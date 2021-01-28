xfwm_dark_assets = []

foreach asset : xfwm_asset_names
  xfwm_dark_assets += custom_target(
    'xfwm-dark-' + asset,
    input : 'assets.svg',
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
endforeach
