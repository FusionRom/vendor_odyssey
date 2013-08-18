# Inherit common stuff
$(call inherit-product, vendor/odyssey/config/common.mk)

# BT config
PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.nonsmartphone.conf:system/etc/bluetooth/main.conf
