# Installing Arc from the source

## Getting the source

To get the source, either clone the git repository with e.g.

    git clone https://github.com/jnsh/arc-theme --depth 1

Or download and extract a [snapshot](https://github.com/jnsh/arc-theme/archive/master.zip) of the master git branch, or the latest [release tarball](https://github.com/jnsh/arc-theme/releases/latest).

## Dependencies

#### Build dependencies

To build the theme the following packages are required:
* `meson`

The following packages are only required for building certain themes:
* `sassc` for GTK 3, Cinnamon, and GNOME Shell
* `inkscape` for GTK 2, GTK 3, and Xfwm

You can avoid these dependencies by choosing to not build specific themes using the `themes` build option.

#### Runtime dependencies

For the GTK 2 theme to function properly, install the following:
* `gnome-themes-extra`, or `gnome-themes-standard` before GNOME version 3.28
* The murrine GTK 2 engine. This has different names depending on the distribution:
  * `gtk-engine-murrine` (Arch Linux)
  * `gtk2-engines-murrine` (Debian, Ubuntu, elementary OS)
  * `gtk-murrine-engine` (Fedora)
  * `gtk2-engine-murrine` (openSUSE)
  * `gtk-engines-murrine` (Gentoo)

## Building and installation

Arc-theme uses [Meson](https://mesonbuild.com/) build system, refer to its documentation for further information about the build process.

The following instructions should work for most common cases.

#### Setup and configure a build directory

First you need to setup and configure a new build directory (e.g. `build/`) from the cloned/extracted source code directory.

You should at least configure the build prefix with `--prefix=` option, usually `/usr` for system wide installation, or `$HOME/.local` for installing for your user only. Additionally you may set any Arc-theme specific [build options](#build-options) according to your needs and preferences, with `-Doption=value` command line argument.

For example, configure to install in your home directory, and to only build the Arc-Darker variant with:

    meson setup --prefix=$HOME/.local -Dvariants=darker build/

The build options can later be changed with `meson configure` command, e.g.

    meson configure --prefix=/usr -Dvariants=light,darker build/

#### Build and install

Build and install the theme according to your configuration by running the following:

    meson install -C build/

#### Note about installation in user's home directory

Some themes (at least GTK 2) aren't loaded from `~/.local/share/themes/`. You can work around this e.g. by symlinking the Arc theme directories in `~/.local/share/themes/` to `~/.themes/` with following commands:

    mkdir -p ~/.themes/
    for d in Arc{,-Dark,-Darker,-Lighter}{,-solid}; do
      [ -d ~/.local/share/themes/$d ] && ln -s ~/.local/share/themes/$d ~/.themes/;
    done

## Versioned themes

The source code comes branched for different versions of GTK 3, GNOME Shell, and Cinnamon. Only one version of those themes will be built and installed, and using the wrong versions will likely result in visual issues.

The versions that will be built can be set manually with `cinnamon_version`, `gnome_shell_version` and `gtk3_version` build options.

Otherwise the build system tries to determine correct versions using the following packages on the build environment:
* `gnome-shell` for detecting GNOME Shell version
* `cinnamon` for detecting Cinnamon version
* `pkgconf` and the GTK 3 package, or its development files for distributions that ship those separately (e.g. `libgtk-3-dev` for Debian based distros or `gtk3-devel` for RPM based distros), for detecting GTK 3 version

**Note:** The build setup for GTK 3, Cinnamon and GNOME Shell themes will fail, if their versions can't be determined either from the build options, or from installed packages.

## Build options

Arc-theme specific build options can be set or changed with `meson configure -Doption=value <build_directory>` e.g.

    meson configure -Dthemes=gtk3,plank,xfwm -Dtransparency=false -Dgtk3_version=3.24 build/

Option | Default value | Description
--- | --- | ---
`themes` | `cinnamon,gnome-shell,gtk2,gtk3,metacity,plank,unity,xfwm` | List of themes to build
`variants` | `light,darker,dark,lighter` |  List of theme variants to build
`transparency` | `true` | Enable or disable transparency
`cinnamon_version` | - | Build Cinnamon theme for specific version
`gnome_shell_version` | - | Build GNOME Shell theme for specific version
`gtk3_version` | - | Build GTK 3 theme for specific version
`gnome_shell_gresource` | `false` | Compile GNOME Shell theme into a gresource file

## Uninstallation

Manually remove the theme directories from your install location, e.g.

    rm -rf ~/.local/share/themes/Arc{,-Dark,-Darker,-Lighter}{,-solid}
