//
//  ViewController.m
//  CZImageCacheDemo
//
//  Created by Apple on 2017/3/16.
//  Copyright © 2017年 Clay Zhu. All rights reserved.
//

#import "ViewController.h"
#import "CZImageCache.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *allCacheSizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *imageCacheSizeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self setupCacheLabel];
	// 从网络 URL 请求图片，若缓存中存在，则从缓存取
	[[CZImageCache sharedInstance] imageForImageView:self.imageView
											imageURL:@"http://ompmj0bxx.bkt.clouddn.com/IMG_1382.JPG"
									placeholderImage:nil
											 success:^(UIImage *image) {
												 // 请求到图片后，会缓存到沙盒中，刷新沙盒中缓存的大小
												 [self setupCacheLabel];
											 }];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/** 读取缓存大小，设置 UI */
- (void)setupCacheLabel {
	self.allCacheSizeLbl.text = [NSString stringWithFormat:@"全部缓存大小：%.2fM", [[CZImageCache sharedInstance] cacheSize]];
	self.imageCacheSizeLbl.text = [NSString stringWithFormat:@"图片缓存大小：%.2fM", [[CZImageCache sharedInstance] imageCacheSize]];
}

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

@end
