project(
  'arc-theme',
  version : '20210412',
  meson_version: '>= 0.50.0',
  license : 'GPL3'
)

variant_name = {
  'light' : (get_option('transparency') ? 'Arc' : 'Arc-solid'),
  'darker' : (get_option('transparency') ? 'Arc-Darker' : 'Arc-Darker-solid'),
  'dark' : (get_option('transparency') ? 'Arc-Dark' : 'Arc-Dark-solid'),
  'lighter' : (get_option('transparency') ? 'Arc-Lighter' : 'Arc-Lighter-solid'),
}

prefix = get_option('prefix')
datadir = get_option('datadir')

install_dir = {
  'light' : datadir / 'themes' / variant_name.get('light'),
  'darker' : datadir / 'themes' / variant_name.get('darker'),
  'dark' : datadir / 'themes' / variant_name.get('dark'),
  'lighter' : datadir / 'themes' / variant_name.get('lighter'),
}

# sh dependency
sh = find_program('sh')
if meson.version().version_compare('>= 0.55.0')
  # avoid spamming "Program sh found: YES"
  sh = find_program('sh')
else
  # use of a string to stay compatible with meson < 0.55 (since sh is used with add_install_script)
  sh = 'sh'
endif

# sassc dependency
foreach theme : ['cinnamon', 'gnome-shell', 'gtk3']
  if theme in get_option('themes')
    sassc = find_program('sassc')
    break
  endif
endforeach

# inkscape dependency
foreach theme : ['gtk2', 'gtk3', 'xfwm']
  if theme in get_option('themes')
    inkscape = find_program('inkscape')
    inkscape_ver = run_command(inkscape, '--version').stdout().split()[1]
    break
  endif
endforeach

subdir('common')
