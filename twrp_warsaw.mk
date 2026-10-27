#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := warsaw
PRODUCT_NAME := twrp_warsaw
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi K90 Ultra
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_USE_DYNAMIC_PARTITIONS := true
