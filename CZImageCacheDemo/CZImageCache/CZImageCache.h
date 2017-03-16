//
//  CZImageCache.h
//  CZImageCacheDemo
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 Clay Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CZImageCache : NSObject

/** 图片缓存类的单例方法 */
+ (instancetype)sharedInstance;

#pragma mark - 计算、清理缓存
/** 计算所有缓存的大小，单位为 M，路径为 /Library/Caches */
- (CGFloat)cacheSize;
/** 计算图片缓存的大小，单位为 M，路径为 /Library/Caches/ImageCache */
- (CGFloat)imageCacheSize;

/** 删除所有缓存，路径为 /Library/Caches */
- (void)clearCacheWithCompletion:(void (^)(void))completion;
/** 删除图片缓存，路径为 /Library/Caches/ImageCache */
- (void)clearImageCacheWithCompletion:(void (^)(void))completion;

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

@end
