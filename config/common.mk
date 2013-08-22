PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    persist.sys.root_access=1 

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/odyssey/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/odyssey/prebuilt/common/bin/50-slim.sh:system/addon.d/50-slim.sh \
    vendor/odyssey/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/odyssey/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# SLIM-specific init file
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/etc/init.local.rc:root/init.slim.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/odyssey/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

# Audio Config for DSPManager
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/vendor/etc/audio_effects.conf:system/vendor/etc/audio_effects.conf
#LOCAL SLIM CHANGES  - END

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/odyssey/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/odyssey/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/odyssey/prebuilt/common/bin/sysinit:system/bin/sysinit

# Workaround for NovaLauncher zipalign fails
PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/app/NovaLauncher.apk:system/app/NovaLauncher.apk \
    vendor/odyssey/prebuilt/common/app/KLPC3.1.apk:system/app/KLP.apk

# Embed SuperUser
SUPERUSER_EMBEDDED := true

# Required packages
PRODUCT_PACKAGES += \
    Camera \
    Development \
    SpareParts \
    Superuser \
    su

# Optional packages
PRODUCT_PACKAGES += \
    AppSettings \
    Basic \
    HoloSpiralWallpaper \
    HALO \
    NoiseField \
    Galaxy4 \
    LiveWallpapersPicker \
    PhaseBeam \
    RoundR \
    XposedInstaller

# Extra Optional packages
PRODUCT_PACKAGES += \
    DashClock \
    LatinIME \

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs

PRODUCT_PACKAGE_OVERLAYS += vendor/odyssey/overlay/common

# T-Mobile theme engine
include vendor/odyssey/config/themes_common.mk

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/odyssey/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/odyssey/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

# Versioning System
# Prepare for 4.3 weekly beta.2
PRODUCT_VERSION_MAJOR = v-2
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = RC-1
ifdef ODYSSEY_BUILD_EXTRA
    ODYSSEY_POSTFIX := -$(ODYSSEY_BUILD_EXTRA)
endif
ifndef ODYSSEY_BUILD_TYPE
    ODYSSEY_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
    ODYSSEY_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
ODYSSEY_VERSION := Odyssey-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(ODYSSEY_BUILD_TYPE)$(ODYSSEY_POSTFIX)
ODYSSEY_MOD_VERSION := Odyssey-$(ODYSSEY_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(ODYSSEY_BUILD_TYPE)$(ODYSSEY_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    odyssey.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.odyssey.version=$(ODYSSEY_VERSION) \
    ro.modversion=$(ODYSSEY_MOD_VERSION)
