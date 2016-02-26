//
//  RATFeed.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATFeed.h"
#import "RATTweet.h"

@interface RATFeed ()

@property (nonatomic, strong, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSArray *tweets;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation RATFeed

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
    }

    return self;
}

#pragma mark - Public interface

- (void)updateWithTweets:(NSArray *)tweets
{
    self.tweets = tweets;
}

- (void)addNextFromTweets:(NSArray *)nextTweets
{
    NSDecimalNumber *topNextId = ((RATTweet*)nextTweets.firstObject).tweetId;

    __block NSInteger indexOfBottomObject = 0;

    [self.tweets enumerateObjectsUsingBlock:^(RATTweet *tweet, NSUInteger index, BOOL *stop) {
        NSDecimalNumber *tweetId = tweet.tweetId;

        if ([tweetId compare:topNextId] == NSOrderedDescending)
            indexOfBottomObject = index;
        else
            *stop = YES;
    }];

    NSArray *subArray = [self.tweets subarrayWithRange:NSMakeRange(0, indexOfBottomObject + 1)];

    NSMutableArray *allTweets = [NSMutableArray arrayWithCapacity:0];
    [allTweets addObjectsFromArray:subArray];
    [allTweets addObjectsFromArray:nextTweets];

    self.tweets = [allTweets copy];

}

@end
