//
//  RATCommonViewModel.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATCommonViewModel.h"

@interface RATCommonViewModel ()

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation RATCommonViewModel

#pragma mark - Initializers

- (instancetype)init
{
    @throw nil;
}

- (instancetype)initWithServices:(RATServices *)services;
{
    self = [super init];
    if (self)
    {
        _services = services;
    }

    return self;
}

@end
