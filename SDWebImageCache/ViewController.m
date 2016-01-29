//
//  ViewController.m
//  SDWebImageCache
//
//  Created by XiaoShan on 1/27/16.
//  Copyright © 2016 XiaoShan. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers)
    {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        NSDate *lastModifiedDate = nil;
        
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
            
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";

        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };
    
    //http://7xp20z.com1.z0.glb.clouddn.com/1.jpg
    //http://7xp20z.com1.z0.glb.clouddn.com/2.jpg
    NSURL *imgURL = [NSURL URLWithString:@"http://handy-img-storage.b0.upaiyun.com/3.jpg"];
    [[self imageView] sd_setImageWithURL:imgURL
                        placeholderImage:nil
                                 options:SDWebImageRefreshCached];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 500);
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:_imageView];
    }
    
    return _imageView;
}

@end
