################################################################################
#
# rpi-userland
#
################################################################################

RPI_USERLAND_VERSION = b834074d0c0d9d7e64c133ab14ed691999cee990
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3c
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPTS = -DVMCS_INSTALL_PREFIX=/usr \
	-DCMAKE_C_FLAGS="-DVCFILED_LOCKFILE=\\\"/var/run/vcfiled.pid\\\""

RPI_USERLAND_PROVIDES = libegl libgles libopenmax libopenvg

ifeq ($(BR2_PACKAGE_RPI_USERLAND_START_VCFILED),y)
define RPI_USERLAND_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/rpi-userland/S94vcfiled \
		$(TARGET_DIR)/etc/init.d/S94vcfiled
endef
endif

# Only install subset of libraries for Berryboot
define RPI_USERLAND_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/lib/libvchiq_arm.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/lib/libvcos.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/lib/libbcm_host.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/lib/libvchostif.so $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 0755 $(STAGING_DIR)/usr/lib/libvcfiled_check.so $(TARGET_DIR)/usr/lib
endef

#define RPI_USERLAND_POST_TARGET_CLEANUP
#	rm -f $(TARGET_DIR)/etc/init.d/vcfiled
#	rm -f $(TARGET_DIR)/usr/share/install/vcfiled
#	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/install
#	rm -Rf $(TARGET_DIR)/usr/src
#endef

RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

$(eval $(cmake-package))
