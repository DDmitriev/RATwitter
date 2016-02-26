//
//  RATRouter.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATRouter.h"
#import "RATFeedViewController.h"

@implementation RATRouter

#pragma mark - Class public interface

+ (void)showRootForWindow:(UIWindow *)window withViewMode:(RATFeedViewModel *)viewModel
{
    RATFeedViewController *feedVC = [[RATFeedViewController alloc] initWithFeedViewModel:viewModel];
    UINavigationController *mainController = [[UINavigationController alloc] initWithRootViewController:feedVC];
    window.rootViewController = mainController;
}


@end
