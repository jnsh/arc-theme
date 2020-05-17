AC_INIT(
    [arc-theme],
    [20200513],
    [https://github.com/jnsh/arc-theme/issues],
    [arc-theme],
    [https://github.com/jnsh/arc-theme],
    []
)

AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([no-dist-gzip dist-xz foreign])
AC_PROG_LN_S
AC_PROG_MKDIR_P

ARC_ENABLE([LIGHT],         [light],         [Arc Light],     [disable])
ARC_ENABLE([DARKER],        [darker],        [Arc Darker],    [disable])
ARC_ENABLE([DARK],          [dark],          [Arc Dark],      [disable])
ARC_ENABLE([LIGHTER],       [lighter],       [Arc Lighter],   [disable])
ARC_ENABLE([CINNAMON],      [cinnamon],      [Cinnamon],      [disable])
ARC_ENABLE([GNOME_SHELL],   [gnome-shell],   [GNOME Shell],   [disable])
ARC_ENABLE([GTK2],          [gtk2],          [GTK2],          [disable])
ARC_ENABLE([GTK3],          [gtk3],          [GTK3],          [disable])
ARC_ENABLE([METACITY],      [metacity],      [Metacity],      [disable])
ARC_ENABLE([UNITY],         [unity],         [Unity],         [disable])
ARC_ENABLE([XFWM],          [xfwm],          [XFWM],          [disable])
ARC_ENABLE([TRANSPARENCY],  [transparency],  [transparency],  [disable])
ARC_ENABLE([PLANK],         [plank],         [Plank theme],   [disable])
ARC_ENABLE([OPENBOX],       [openbox],       [Openbox],       [disable])

AS_IF([test "x$ENABLE_TRANSPARENCY" != xno], [
    AC_SUBST([themedir], [${datadir}/themes/Arc])
    AC_SUBST([themedarkerdir], [${datadir}/themes/Arc-Darker])
    AC_SUBST([themedarkdir], [${datadir}/themes/Arc-Dark])
    AC_SUBST([themelighterdir], [${datadir}/themes/Arc-Lighter])
], [
    AC_SUBST([themedir], [${datadir}/themes/Arc-solid])
    AC_SUBST([themedarkerdir], [${datadir}/themes/Arc-Darker-solid])
    AC_SUBST([themedarkdir], [${datadir}/themes/Arc-Dark-solid])
    AC_SUBST([themelighterdir], [${datadir}/themes/Arc-Lighter-solid])
])

AS_IF([test "x$ENABLE_GTK3" != xno], [ARC_GTK3])
AS_IF([test "x$ENABLE_GNOME_SHELL" != xno],
    [ARC_GNOME_SHELL]
    [GNOME_SHELL_VERSMNR=`echo $GNOME_SHELL_VERSION | cut -d. -f2`])
AM_CONDITIONAL([GNOME_SHELL_3_32_OR_NEWER], [test "0$GNOME_SHELL_VERSMNR" -ge 31])
AS_IF([test "x$ENABLE_CINNAMON" != xno], [ARC_CINNAMON])

AS_IF([test "x$ENABLE_GTK2" != xno -o "x$ENABLE_GTK3" != xno -o "x$ENABLE_XFWM" != xno], [
    AC_PATH_PROG([RSVG_CONVERT], [rsvg-convert])
    AS_IF([test "x$ac_cv_path_RSVG_CONVERT" = x], [AC_MSG_ERROR([rsvg-convert not found])])
    AC_PATH_PROG([OPTIPNG], [optipng])
    AS_IF([test "x$ac_cv_path_OPTIPNG" = x], [AC_MSG_ERROR([optipng not found])])
])

AS_IF([test "x$ENABLE_GTK3" != xno -o "x$ENABLE_CINNAMON" != xno -o "x$ENABLE_GNOME_SHELL" != xno], [
    AC_PATH_PROG([SASSC], [sassc])
    AS_IF([test "x$ac_cv_path_SASSC" = x], [AC_MSG_ERROR([sassc not found])])
])

AC_CONFIG_FILES([
    common/gtk-2.0/Makefile
    common/gtk-3.0/Makefile
    common/gtk-3.0/3.18/Makefile
    common/gtk-3.0/3.20/Makefile
    common/gtk-3.0/3.22/Makefile
    common/gtk-3.0/3.24/Makefile
    common/xfwm4/Makefile
    common/Makefile
    Makefile
])

AC_OUTPUT
