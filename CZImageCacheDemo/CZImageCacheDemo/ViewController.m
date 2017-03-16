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
	[[CZImageCache sharedInstance] imageForImageView:self.imageView
											imageURL:@"http://ompmj0bxx.bkt.clouddn.com/IMG_1382.JPG"
									placeholderImage:nil
											 success:^(UIImage *image) {
												 [self setupCacheLabel];
											 }];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupCacheLabel {
	self.allCacheSizeLbl.text = [NSString stringWithFormat:@"全部缓存大小：%.2fM", [[CZImageCache sharedInstance] cacheSize]];
	self.imageCacheSizeLbl.text = [NSString stringWithFormat:@"图片缓存大小：%.2fM", [[CZImageCache sharedInstance] imageCacheSize]];
}

- (IBAction)clearAllCacheAction:(UIButton *)sender {
	[[CZImageCache sharedInstance] clearCacheWithCompletion:^{
		[self setupCacheLabel];
	}];
}

- (IBAction)clearImageCacheAction:(UIButton *)sender {
	[[CZImageCache sharedInstance] clearImageCacheWithCompletion:^{
		[self setupCacheLabel];
	}];
}

@end
