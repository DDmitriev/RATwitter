//
//  RATImageServiceInterface.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RATImageServiceInterface <NSObject>

- (void)fetchImageFromURL:(NSURL *)url withHandler:(void (^)(UIImage *image))completionHandler;

@end
