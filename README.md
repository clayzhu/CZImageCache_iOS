# CZImageCache_iOS
自动在请求网络图片后对图片进行缓存，可以通过多种形式读取。

* [1. 介绍](#1-介绍)
* [2. 安装](#2-安装)
* [3. 说明](#3-说明)

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

`CZImageCache` 使用单例模式构建，图片路径设置在 iOS 应用沙盒的 `/Library/Caches/ImageCache` 目录下，并且可以按需要计算和清理图片缓存或整个 `Caches` 文件夹缓存的大小。

```objc
/** 图片缓存类的单例方法 */
+ (instancetype)sharedInstance;
```

```objc
#pragma mark - 计算、清理缓存
/** 计算所有缓存的大小，单位为 M，路径为 /Library/Caches */
- (CGFloat)cacheSize;
/** 计算图片缓存的大小，单位为 M，路径为 /Library/Caches/ImageCache */
- (CGFloat)imageCacheSize;

/** 删除所有缓存，路径为 /Library/Caches */
- (void)clearCacheWithCompletion:(void (^)(void))completion;
/** 删除图片缓存，路径为 /Library/Caches/ImageCache */
- (void)clearImageCacheWithCompletion:(void (^)(void))completion;
```

```objc
#pragma mark - 对图片缓存
/**
 *  根据图片 URL 缓存图片到沙盒 /Library/Caches/ImageCache 目录中。通过图片 URL 缓存
 *
 *  @param image   需要缓存的图片
 *  @param url     图片 URL
 *
 *  @return YES 缓存成功，NO 缓存失败
 */
- (BOOL)saveImage:(UIImage *)image imageURL:(NSString *)url;

/**
 *  根据图片 URL 为一个 imageView 设置图片，缓存中存在该图片直接读取缓存，否则通过网络下载。可以设置一个默认图片，success 和 failure 在网络下载的情况下调用。通过图片 URL 缓存
 *
 *  @param imageView        显示图片的 imageView
 *  @param url              图片 URL
 *  @param placeholderImage 默认图片
 *  @param success          缓存中无图片，通过网络下载图片成功后的 block
 */
- (void)imageForImageView:(UIImageView *)imageView
                 imageURL:(NSString *)url
         placeholderImage:(UIImage *)placeholderImage
                  success:(void (^)(UIImage *image))success;
```

