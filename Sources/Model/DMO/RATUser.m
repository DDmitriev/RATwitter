//
//  RATUser.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATUser.h"
#import "RATFeed.h"

@interface RATUser ()

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation RATUser

#pragma mark - Initializers

- (instancetype)init
{
    @throw nil;
}

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super init];

    if (self != nil)
    {
        _username = username;
        _feed = [[RATFeed alloc] initWithUsername:_username];
    }

    return self;
}

@end
