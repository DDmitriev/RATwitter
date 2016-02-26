//
//  RATRouter.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RATFeedViewModel;

@interface RATRouter : NSObject

+ (void)showRootForWindow:(UIWindow *)window withViewMode:(RATFeedViewModel *)viewModel;


@end
