//
//  RATAppDelegate.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 13.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATAppDelegate.h"

#import "RATNetworking.h"
#import "RATServices.h"
#import "RATUser.h"
#import "RATRouter.h"
#import "RATFeedViewModel.h"


@interface RATAppDelegate ()

- (void)p_configure;

@end

@implementation RATAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    [self p_configure];

    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - Private interface

- (void)p_configure
{
    RATServices *services = [[RATServices alloc] init];
    RATUser *user = [[RATUser alloc] initWithUsername:@"rickastley"];
    RATFeedViewModel *feedVM = [[RATFeedViewModel alloc] initWithUser:user withServices:services];
    [RATRouter showRootForWindow:self.window withViewMode:feedVM];
}

@end
