TAG := $(or $(TAG), default)
VERSION := $(or $(VERSION), 5.4.4)
CFLAGS := $(or $(CFLAGS), --closure=1 -Oz -flto)
LDFLAGS := $(or $(LDFLAGS), -Oz -flto -sEVAL_CTORS)

MAKE = make CC="emcc" AR="emar rcu" LD="emcc" NM="emnm" RANLIB="emranlib" CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"

BUILD_DIR = build

DIST_DIR = $(BUILD_DIR)/dist
WORK_DIR = $(BUILD_DIR)/work

DIST_LUA_DIR = $(DIST_DIR)/$(VERSION)/$(TAG)
DIST_LIB_DIR = $(DIST_LUA_DIR)/lib
DIST_INC_DIR = $(DIST_LUA_DIR)/include
DIST_LIB = $(DIST_LIB_DIR)/liblua.a

DL_ARCHIVE = lua-$(VERSION).tar.gz
DL_URL = https://www.lua.org/ftp/$(DL_ARCHIVE)

WORK_LUA_DIR = $(WORK_DIR)/$(VERSION)/$(TAG)
WORK_ARCHIVE = $(WORK_DIR)/$(DL_ARCHIVE)

DONE = $(WORK_DIR)/$(VERSION)-$(TAG).ok

$(DONE): $(WORK_LUA_DIR)
	mkdir -p "$(dir $@)"
	mkdir -p "$(PWD)/$(DIST_LUA_DIR)/*"
	cd "$^" && \
		$(MAKE) && \
		$(MAKE) local && \
		rm -rf "$(PWD)/$(DIST_LUA_DIR)/*" && \
		cp -r install/* "$(PWD)/$(DIST_LUA_DIR)/" && \
		touch $(PWD)/$(DONE)

$(WORK_LUA_DIR): $(WORK_ARCHIVE)
	mkdir -p "$@"
	tar -C "$@" --strip-components=1 -x -f "$^"

$(WORK_ARCHIVE): 
	mkdir -p "$(dir $@)"
	rm $(WORK_ARCHIVE) || true
	wget -P "$(dir $@)" "$(DL_URL)"

cflags:
	@echo -L$(PWD)/$(DIST_LIB_DIR) -I$(PWD)/$(DIST_INC_DIR)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean cflags
