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
	NSString *documentsDirectory = [paths objectAtIndex:0];
	// 图片缓存到沙盒 Caches 的 CachesImage 目录中
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ImageCache"];
	NSError *error;
	BOOL isDirectory = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDirectory])
		[[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
	return dataPath;
}

@end
