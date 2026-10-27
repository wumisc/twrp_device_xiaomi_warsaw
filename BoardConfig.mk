#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/warsaw

# Recovery as Boot（K90 Ultra 没有独立recovery分区，必开）
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_BOOT_HEADER_VERSION := 4

# Crypto FBEv2 HyperOS4
TW_INCLUDE_CRYPTO_FBE := true
TW_FBE_V2_SUPPORT := true

# Dynamic Super
PRODUCT_USE_DYNAMIC_PARTITIONS := true
TW_INCLUDE_FASTBOOTD := true

# Storage / Misc
TW_HAS_NO_RECOVERY_PARTITION := true
TW_NO_SCREEN_BLANK := true
TW_SCREEN_BLANK_ON_BOOT := false

# Kernel 预编译路径（重点！）
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image

# AVB
BOARD_AVB_ENABLE := true
