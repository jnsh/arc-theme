VPATH =

targets := $(shell cat $(srcdir)/assets.txt)
light := $(patsubst %,light/assets/%.png,$(targets))
dark := $(patsubst %,dark/assets/%.png,$(targets))

light: $(light)
dark: $(dark)

light/assets dark/assets:
	$(MKDIR_P) "$@"/

clean:
	rm -rf light/assets/ dark/assets/

$(light): $(srcdir)/light/assets.svg | light/assets
$(dark): $(srcdir)/dark/assets.svg | dark/assets

$(light) $(dark):
	$(RSVG_CONVERT) --format=png --output="$@" --export-id="$(basename $(notdir $@))" --dpi-y=$(if $(filter $(OPTION_GTK2_HIDPI),true),192,96) --dpi-x=$(if $(filter $(OPTION_GTK2_HIDPI),true),192,96) "$<" >/dev/null
	$(OPTIPNG) -o7 --quiet "$@"

.PHONY: light dark clean

if ENABLE_LIGHT
xfwm4themedir = $(themedir)/xfwm4
xfwm4theme_DATA = $(srcdir)/light/themerc $(light)
endif

if ENABLE_DARKER
xfwm4themedarkerdir = $(themedarkerdir)/xfwm4
xfwm4themedarker_DATA = $(srcdir)/dark/themerc $(dark)
endif

if ENABLE_DARK
xfwm4themedarkdir = $(themedarkdir)/xfwm4
xfwm4themedark_DATA = $(srcdir)/dark/themerc $(dark)
endif

if ENABLE_LIGHTER
xfwm4themelighterdir = $(themelighterdir)/xfwm4
xfwm4themelighter_DATA = $(srcdir)/light/themerc $(light)
endif

EXTRA_DIST = \
	assets.txt \
	$(patsubst %,%/assets.svg,light dark) \
	$(patsubst %,%/themerc,light dark)
