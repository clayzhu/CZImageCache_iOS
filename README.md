# CZImageCache_iOS
自动在请求网络图片后对图片进行缓存，可以通过多种形式读取。

* [1. 介绍](#1-介绍)
* [2. 安装](#2-安装)
* [3. 说明](#3-说明)
* [4. 示例](#4-示例)

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

### 1. 单例方法

```objc
/** 图片缓存类的单例方法 */
+ (instancetype)sharedInstance;
```

### 2. 计算缓存

```objc
/** 计算所有缓存的大小，单位为 M，路径为 /Library/Caches */
- (CGFloat)cacheSize;
/** 计算图片缓存的大小，单位为 M，路径为 /Library/Caches/ImageCache */
- (CGFloat)imageCacheSize;
```

### 3. 清理缓存

```objc
/** 删除所有缓存，路径为 /Library/Caches */
- (void)clearCacheWithCompletion:(void (^)(void))completion;
/** 删除图片缓存，路径为 /Library/Caches/ImageCache */
- (void)clearImageCacheWithCompletion:(void (^)(void))completion;
```

### 4. 对图片缓存

```objc
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

## 4. 示例

1. 在 `Main.storyboard` 中添加一些控件，显示缓存大小、清理缓存、加载显示图片。

![Main.storyboard](http://ompmj0bxx.bkt.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-04-07%2022.25.03.png "Main.storyboard")

2. 设置一个通用的读取缓存的方法，并显示在 label 上。

```objc
/** 读取缓存大小，设置 UI */
- (void)setupCacheLabel {
    self.allCacheSizeLbl.text = [NSString stringWithFormat:@"全部缓存大小：%.2fM", [[CZImageCache sharedInstance] cacheSize]];
    self.imageCacheSizeLbl.text = [NSString stringWithFormat:@"图片缓存大小：%.2fM", [[CZImageCache sharedInstance] imageCacheSize]];
}
```

3. 在 `ViewController` 中启动时，加载图片。

```objc
// 从网络 URL 请求图片，若缓存中存在，则从缓存取
[[CZImageCache sharedInstance] imageForImageView:self.imageView
                                        imageURL:@"http://ompmj0bxx.bkt.clouddn.com/IMG_1382.JPG"
                                placeholderImage:nil
                                         success:^(UIImage *image) {
                                             // 请求到图片后，会缓存到沙盒中，刷新沙盒中缓存的大小
                                             [self setupCacheLabel];
                                         }];
```

4. 清理缓存，并刷新 label 上的缓存大小。

```objc
/** 清理所有缓存，路径为 /Library/Caches */
- (IBAction)clearAllCacheAction:(UIButton *)sender {
    [[CZImageCache sharedInstance] clearCacheWithCompletion:^{
        [self setupCacheLabel];
    }];
}

/** 清理图片缓存，路径为 /Library/Caches/ImageCache */
- (IBAction)clearImageCacheAction:(UIButton *)sender {
    [[CZImageCache sharedInstance] clearImageCacheWithCompletion:^{
        [self setupCacheLabel];
    }];
}
```

