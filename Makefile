#!/usr/bin/make -f

NAME=selenium-server
VERSION=2.30.0
ARCH=amd64
PACKAGE_NAME=$(NAME)-$(VERSION)_$(ARCH).deb

TMP_DIR=./tmp
JAR=selenium-server-standalone-$(VERSION).jar
SOURCES_URL=http://selenium.googlecode.com/files/$(JAR)
SOURCES_DIR=$(TMP_DIR)/$(NAME)-$(VERSION)

DEST_DIR=$(TMP_DIR)/build
DEBIAN_DIR=./DEBIAN

all: build

upload: build

build: src_delete src_import deb_prepare deb_build

install:
	mkdir -p $(DEST_DIR)/usr/local/bin
	mkdir -p $(DEST_DIR)/opt/$(NAME)
	cp -r $(SOURCES_DIR)/* $(DEST_DIR)/opt/$(NAME)
	sed -i 's/VERSION/$(VERSION)/' $(DEST_DIR)/opt/$(NAME)/selenium-server

clean: src_delete
	rm -rf $(DEST_DIR)

src_import: clean
	mkdir -p $(SOURCES_DIR)
	wget $(SOURCES_URL) -O $(SOURCES_DIR)/$(JAR)
	cp ./selenium-server $(SOURCES_DIR)

src_delete:
	rm -rf $(SOURCES_DIR)

deb_prepare: install
	mkdir -p $(DEST_DIR)/DEBIAN
	cp $(DEBIAN_DIR)/control $(DEST_DIR)/DEBIAN/control
	cp $(DEBIAN_DIR)/postinst $(DEST_DIR)/DEBIAN/postinst
	chmod +x $(DEST_DIR)/DEBIAN/postinst
	sed -i 's/%VERSION%/$(VERSION)/' $(DEST_DIR)/DEBIAN/control
	sed -i 's/%NAME%/$(NAME)/' $(DEST_DIR)/DEBIAN/control

deb_build:
	dpkg-deb -b $(DEST_DIR)/ $(PACKAGE_NAME)

