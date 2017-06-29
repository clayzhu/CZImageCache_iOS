//
//  CZImageCache.m
//  CZImageCacheDemo
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 Clay Zhu. All rights reserved.
//

#import "CZImageCache.h"

@interface CZImageCache ()

@property (strong, nonatomic) NSString *imageCachePath;
@property (strong, nonatomic) NSString *cachePath;

@end

@implementation CZImageCache

+ (instancetype)sharedInstance {
	static CZImageCache *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[CZImageCache alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init {
	if (self = [super init]) {
		self.imageCachePath = [self prepareImagePath];
	}
	return self;
}

- (NSString *)prepareImagePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	self.cachePath = cachesDirectory;
	// 图片缓存到沙盒 Caches 的 CachesImage 目录中，路径为 /Library/Caches/ImageCache
	NSString *dataPath = [cachesDirectory stringByAppendingPathComponent:@"ImageCache"];
	NSError *error;
	BOOL isDirectory = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDirectory])
		[[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];	// 没有 ImageCache 文件夹的话，创建一个
	return dataPath;
}

#pragma mark - 计算、清理缓存
- (long long)fileSizeAtPath:(NSString *)filePath {
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:filePath]) {
		return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
	}
	return 0;
}

- (CGFloat)cacheSize {
	NSFileManager *manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:self.cachePath]) return 0.0;
	NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:self.cachePath] objectEnumerator];
	NSString *fileName;
	long long folderSize = 0;
	while ((fileName = [childFilesEnumerator nextObject]) != nil) {
		NSString *fileAbsolutePath = [self.cachePath stringByAppendingPathComponent:fileName];
		folderSize += [self fileSizeAtPath:fileAbsolutePath];
	}
	return folderSize;
}

- (CGFloat)imageCacheSize {
	NSFileManager *manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:self.imageCachePath]) return 0.0;
	NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:self.imageCachePath] objectEnumerator];
	NSString *fileName;
	long long folderSize = 0;
	while ((fileName = [childFilesEnumerator nextObject]) != nil) {
		NSString *fileAbsolutePath = [self.imageCachePath stringByAppendingPathComponent:fileName];
		folderSize += [self fileSizeAtPath:fileAbsolutePath];
	}
	return folderSize;
}

- (void)clearCacheWithCompletion:(void (^)(void))completion {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:self.cachePath];
		for (NSString *p in files) {
			NSError *error;
			NSString *path = [self.cachePath stringByAppendingPathComponent:p];
			if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
				[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
			}
		}
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (completion) {
				completion();
			}
		});
	});
}

- (void)clearImageCacheWithCompletion:(void (^)(void))completion {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:self.imageCachePath];
		for (NSString *p in files) {
			NSError *error;
			NSString *path = [self.imageCachePath stringByAppendingPathComponent:p];
			if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
				[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
			}
		}
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (completion) {
				completion();
			}
		});
	});
}

#pragma mark - 对图片缓存
- (BOOL)saveImage:(UIImage *)image imageURL:(NSString *)url {
	NSString *imageTitle = [self escapeURLCharacter:url];
	NSString *imagePath = [self.imageCachePath stringByAppendingPathComponent:imageTitle];
//	NSData *imageData = UIImagePNGRepresentation(image);
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	BOOL writeOK = [imageData writeToFile:imagePath atomically:YES];
	return writeOK;
}

- (void)imageForImageView:(UIImageView *)imageView
				 imageURL:(NSString *)url
		 placeholderImage:(UIImage *)placeholderImage
				  success:(void (^)(UIImage *image))success {
	// 先去沙盒里去寻找是否有这个 URL 对应的图片
	NSString *imageTitle = [self escapeURLCharacter:url];
	NSString *imagePath = [self.imageCachePath stringByAppendingPathComponent:imageTitle];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	if (image) {	// 缓存中有该图片
		imageView.image = image;
		if (success) {
			success(image);
		}
	} else {	// 缓存中无该图片，需要网络请求
        NSLog(@"RequestURL:%@", url);
        
		// 设置了默认图片则显示默认图片
		imageView.image = placeholderImage;
		// 图片在网络下载时显示一个菊花
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[imageView addSubview:indicator];
		indicator.color = [UIColor grayColor];
		indicator.center = CGPointMake(CGRectGetWidth(imageView.bounds) / 2, CGRectGetHeight(imageView.bounds) / 2);
		[indicator startAnimating];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[data writeToFile:imagePath atomically:YES];
				UIImage *image = [UIImage imageWithData:data];
				imageView.image = image;
				[indicator stopAnimating];
				if (success) {
					success(image);
				}
			});
		});
	}
}

/** 对 URL 中的特殊字符转义，防止为文件命名时，保存文件失败 */
- (NSString *)escapeURLCharacter:(NSString *)url {
	NSString *urlEscape;
	urlEscape = [url stringByReplacingOccurrencesOfString:@"/" withString:@"%2f"];
	urlEscape = [urlEscape stringByReplacingOccurrencesOfString:@":" withString:@"%3a"];
	return urlEscape;
}

@end
