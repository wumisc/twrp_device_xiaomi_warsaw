# TWRP device tree for Xiaomi Redmi K90 Ultra (warsaw)

## 设备信息

| 项目 | 值 |
|---|---|
| 设备代号 | `warsaw` |
| 机型 | Xiaomi Redmi K90 Ultra（红米 K90 至尊版） |
| SoC | Qualcomm SM8750-AB Snapdragon 8 Elite（平台代号 `sun`） |
| GPU | Adreno 830 |
| 出厂系统 | Android 16 / HyperOS 3（API 36） |
| 目标系统 | Android 17 / HyperOS 4（本树用于升级系统后的自定义恢复） |
| 分区方案 | A/B（无独立 recovery，recovery 即 boot/recovery 分区，双槽 `recovery_a`/`recovery_b`） |
| Boot header | v4，页大小 4096，ramdisk 用 lz4 |
| 加密 | FBE + metadata encryption（fscrypt policy 2） |

> 说明：`annibale` 是 Redmi K90（非 Ultra）的代号，与本机 `warsaw` 不同。本树按 warsaw 独立型号配置，参考的 SM8750/sun 通用树（thales）仅作为同 SoC 的结构模板。

## 已支持特性（继承自 SM8750/sun 通用配置）

- [x] ADB / Sideload
- [x] FBE + metadata decryption
- [x] Display（RGBX_8888）
- [x] Fastbootd
- [x] Flashing / Dynamic Partitions
- [x] MTP / USB-OTG
- [x] Vibrator（AIDL haptics）
- [x] WLAN（wpa_supplicant）

## Android 17 适配要点

本树针对「设备已升级 Android 17」场景，关键适配：

1. **TWRP 源码版本**：必须用支持 Android 17 的 TWRP 源码分支（`platform_manifest_twrp_aosp` 的 master/最新分支）。设备树的 `SHIPPING_API_LEVEL` 保持出厂 API 36，ramdisk 按出厂系统构建；新系统解密/挂载由 TWRP 主源码处理。
2. **fscrypt / metadata**：保持 `TW_USE_FSCRYPT_POLICY := 2`。Android 17 若调整了 fscrypt v3 / wrappedkey，优先升级 TWRP 主源码而非改设备树。
3. **内核**：recovery 镜像**不含内核**（`BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true`），内核来自设备 `vendor_boot`。`prebuilt/kernel` 仅用于 mkbootimg 打包 header，必须替换为 warsaw 本机内核（见下）。
4. **AVB / dm-verity**：刷入前需解锁 Bootloader；刷 TWRP 后建议 `fastboot flash vbmeta --disable-verity --disable-verification`，否则官方校验会回滚 recovery。

## 构建方法

```bash
# 1. 拉取 TWRP 源码（约 60GB+，需要磁盘与交叉编译工具链）
mkdir twrp-source && cd twrp-source
repo init -u https://github.com/TWRP-Test/platform_manifest_twrp_aosp.git -b twrp-16.0 --depth=1
repo sync -c -j$(nproc)

# 2. 把本树放到 device/xiaomi/warsaw
mkdir -p device/xiaomi/warsaw
# 将本仓库内容放入 device/xiaomi/warsaw

# 3. 同步设备树的依赖（prebuilt/security 等）
# 4.  lunch
source build/envsetup.sh
lunch twrp_warsaw-eng
mka bootimage    # 或 recoveryimage
# 产物：out/target/product/warsaw/boot.img （即 recovery 镜像）
```

## 刷机方案（A/B 双槽，两槽都要刷）

```bash
# 解锁 BL 后进入 fastboot：
fastboot flash recovery_a twrp-3.7.x_17-warsaw.img
fastboot flash recovery_b twrp-3.7.x_17-warsaw.img
# 关闭 AVB（避免校验回滚）：
fastboot flash vbmeta --disable-verity --disable-verification vbmeta.img
# 启动到 recovery：
fastboot reboot recovery
```

> A/B 设备两个 recovery 槽都要刷，否则另一槽回退时会回到官方 rec。

## TODO（需要在真机核对的项）

这些项继承自 SM8750/sun 通用树，首次刷机若异常需按真机调整：

- [ ] `prebuilt/kernel`：替换为 warsaw 本机 `vendor_boot` 提取的内核
  （`magiskboot unpack vendor_boot.img` 或 AOSP `unpack_bootimg.py --boot_img vendor_boot.img`）
- [ ] `BOARD_SUPER_PARTITION_SIZE`：按本机 super 分区实际大小核对
- [ ] 触摸驱动 `.ko` 列表（`TW_LOAD_VENDOR_MODULES`）：核对 `/vendor/lib/modules` 实际触摸驱动名
- [ ] `TW_THEME`：若 TWRP UI 密度异常，改 `portrait_xhdpi` / `portrait_xxhdpi`
- [ ] `TW_BRIGHTNESS_PATH` / `TW_MAX_BRIGHTNESS`：核对本机 backlight 节点与最大亮度

## 致谢

- 设备结构参考 [YuKongA/twrp_device_xiaomi_sm8750_thales](https://github.com/YuKongA/twrp_device_xiaomi_sm8750_thales)（SM8750/sun 通用 TWRP 树）
- [TWRP-Test/platform_manifest_twrp_aosp](https://github.com/TWRP-Test/platform_manifest_twrp_aosp)
- 第三方 warsaw TWRP：`twrp-3.7.1_16-warsaw-lingqiqi5211`
