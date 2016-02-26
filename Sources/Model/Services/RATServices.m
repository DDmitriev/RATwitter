//
//  RATServices.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATServices.h"
#import "RATTwitterService.h"
#import "RATImageService.h"
#import "RATNetworking.h"

@implementation RATServices

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        RATNetworking *networkting = [[RATNetworking alloc] init];
        _twitterService = [[RATTwitterService alloc] initWithNetworking:networkting];
        _imageService = [[RATImageService alloc] init];
    }

    return self;
}

@end
