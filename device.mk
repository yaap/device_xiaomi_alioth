#
# Copyright (C) 2021 Snuggy Wuggy Research and Development Center 
#                    and The hentaiOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/xiaomi/alioth

AB_OTA_UPDATER := true
TARGET_BOOTLOADER_BOARD_NAME := alioth

PRODUCT_SOONG_NAMESPACES += \
    device/xiaomi/alioth \
    hardware/google/av \
    hardware/google/interfaces \
    hardware/google/pixel

# Enable VAB compression
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

TARGET_PRODUCT_PROP := $(LOCAL_PATH)/product.prop

# Characteristics
PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_SHIPPING_API_LEVEL := 30
BOARD_SHIPPING_API_LEVEL := 30

# Device Overlays
PRODUCT_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-yaap

PRODUCT_PACKAGES += \
    SettingsProviderM2012K11AC \
    SettingsProviderM2012K11AG \
    SettingsProviderM2012K11AI \
    WifiOverlayM2012K11AC \
    WifiOverlayM2012K11AG \
    WifiOverlayM2012K11AI

# Enable Dynamic Paritions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

# Enable reboot free DSDS
PRODUCT_PRODUCT_PROPERTIES += \
    persist.radio.reboot_on_modem_change=false

# Force voLTE/voWIFI/viLTE
PRODUCT_PRODUCT_PROPERTIES += \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.wfc_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1

# Set lmkd options
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.low_ram=false \
    ro.lmk.log_stats=true

# charger
PRODUCT_PRODUCT_PROPERTIES += \
    ro.charger.enable_suspend=true

# Set thermal warm reset
PRODUCT_PRODUCT_PROPERTIES += \
    ro.thermal_warmreset = true

# Set support one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Use FUSE passthrough
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true

# Audio A2DP
PRODUCT_PACKAGES += \
    audio.a2dp.default

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Display config interface
PRODUCT_PACKAGES += \
    vendor.display.config@1.8

# QTI Telephony utils
PRODUCT_PACKAGES += \
    qti-telephony-utils \
    qti_telephony_utils.xml \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-hidl-wrapper \
    qti_telephony_hidl_wrapper.xml

# NFC and Secure Element packages
PRODUCT_PACKAGES += \
    NfcNci \
    Tag \
    SecureElement

PRODUCT_COPY_FILES += \
     $(LOCAL_PATH)/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

# RRO Overlays
PRODUCT_PACKAGES += \
    WifiOverlayGourami \
    ConnectivityOverlayGourami \
    HbmSVManagerGourami

# Hotword Enrollment
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.hardware:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.sm8250 \
    $(LOCAL_PATH)/fstab.hardware:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.sm8250

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.recovery.device.rc:recovery/root/init.recovery.gourami.rc

# Regulatory
PRODUCT_PACKAGES += \
    SafetyRegulatoryInfo \
    SettingsOverlayM2012K11AG \
    SettingsOverlayM2012K11AI

# Keyboard height ratio and bottom padding in dp for portrait mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.height_ratio=1.0 \
    ro.com.google.ime.kb_pad_port_b=14.4

#################################################################################
# This is the Start of device-alioth.mk AB configuration.
#################################################################################
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier

PRODUCT_PACKAGES += \
    tune2fs.vendor_ramdisk \
    resize2fs.vendor_ramdisk

PRODUCT_PACKAGES += \
    update_engine_sideload

# Userdata Checkpointing OTA GC
PRODUCT_PACKAGES += \
    checkpoint_gc

PRODUCT_PACKAGES += \
    bootctrl.gourami \
    bootctrl.gourami.recovery

PRODUCT_PROPERTY_OVERRIDES += \
    ro.cp_system_other_odex=1

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-pixel-legacy \
    android.hardware.boot@1.2-impl-pixel-legacy.recovery \
    android.hardware.boot@1.2-service

# Use /product/etc/fstab.postinstall to mount system_other
PRODUCT_PRODUCT_PROPERTIES += \
    ro.postinstall.fstab.prefix=/product

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.postinstall:$(TARGET_COPY_OUT_PRODUCT)/etc/fstab.postinstall

BOARD_BUILD_VENDOR_RAMDISK_IMAGE := true

$(call inherit-product, vendor/xiaomi/alioth/alioth-vendor.mk)
