# Default pod makefile distributed with pods version: 12.11.14
# https://sourceforge.net/p/pods/home/Home/

# Adapted for the Meson Build System with Ninja as a backend

.PHONY : default_target
default_target: all

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif

# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="release"
endif

all: $(BUILD_PREFIX)/build.ninja
	ninja -C $(BUILD_PREFIX)

$(BUILD_PREFIX)/build.ninja:
	$(MAKE) configure

.PHONY: configure
configure:
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

	# run meson to generate and configure the build scripts
	@meson --buildtype=$(BUILD_TYPE) $(BUILD_PREFIX)

clean:
	-if [ -d $(BUILD_PREFIX) ]; then ninja -C $(BUILD_PREFIX) clean; fi

# other (custom) targets are passed through to the Meson genarated Ninja file
%::
	ninja -C $(BUILD_PREFIX) $@
