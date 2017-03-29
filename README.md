# CZImageCache_iOS
自动在请求网络图片后对图片进行缓存，可以通过多种形式读取。

[1. 介绍](#1-介绍)
[2. 安装](#2-安装)

## 1. 介绍

随着移动网络和移动设备的高速发展，很多人在月底都要经历几天共同的煎熬：流量不足 >_<

因此，我们在设计、开发 App 的过程中，要考虑到图片这个流量大户的合理缓存。另一方面，获取缓存的图片，也能有效减少加载图片的时间，优化应用的用户体验。

CZImageCache_iOS 提供了关于图片缓存的多种功能：

* 计算缓存大小
* 清理缓存
* 请求图片并缓存
* 读取缓存的图片

## 2. 安装

[下载 CZImageCache_iOS](https://github.com/clayzhu/CZImageCache_iOS/archive/master.zip)，将 `/CZImageCacheDemo/CZImageCache` 文件夹拖入项目中，记得在 `Destination: Copy items if needed` 前面打勾。

## 3. 说明

`/CZImageCacheDemo/CZImageCache` 文件夹下的 `CZImageCache.h`、`CZImageCache.m`，是主要实现文件。

