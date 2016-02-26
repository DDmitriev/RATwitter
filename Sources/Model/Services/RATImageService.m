//
//  RATImageService.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATImageService.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation RATImageService

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }

    return self;
}

#pragma mark - Public interface

- (void)fetchImageFromURL:(NSURL *)url withHandler:(void (^)(UIImage *image))completionHandler
{
    [SDWebImageManager.sharedManager downloadImageWithURL:url options:SDWebImageRetryFailed | SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler )
                completionHandler(image);
        });
    }];
}

@end
