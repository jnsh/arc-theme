gtk2_light_assets = []

foreach asset : gtk2_asset_names
  gtk2_light_assets += custom_target(
    'gtk2-light-' + asset,
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
