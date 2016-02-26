//
//  RATTwitterService.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATTwitterService.h"
#import "RATTweet.h"
#import "RATNetworking.h"
#import "RATFeed.h"
#import "RATUser.h"

static NSString *const kNetworkFeedUrl = @"https://api.twitter.com/1.1/statuses/user_timeline.json?exclude_replies=1";
static NSString *const kNetworkApiToken = @"AAAAAAAAAAAAAAAAAAAAAJWwfwAAAAAA5O%2FIxHo%2FaVh0op1ahnNWm4QwOLQ%3D0OcHWhOxzURbqaBvWOvCCZoambGywYHURkSyykhi0CwYXdBTQQ";
static NSUInteger const kTweetsCountPerPage = 50;

@interface RATTwitterService ()
{
    RATNetworking *_networking;
}

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (NSArray *)p_tweetModelsFromData:(NSData *)data;
- (void)p_requestFeedDataForUserName:(NSString *)username sinceTweetId:(NSString *)sinceId fromTweetId:(NSString *)fromId handler:(void (^)(NSData *data, NSError *error))completionHandler;

@end

@implementation RATTwitterService

#pragma mark - Initializers

- (instancetype)init
{
    @throw nil;
}

- (instancetype)initWithNetworking:(RATNetworking *)networking
{
    self = [super init];
    if (self)
    {
        _networking = networking;
    }

    return self;
}

#pragma mark - Public interface

- (void)fetchFeed:(RATFeed *)feed withHandler:(void (^)(NSError *error))completionHandler;
{
    __weak __typeof(self) weakSelf = self;

    [self p_requestFeedDataForUserName:feed.username sinceTweetId:nil fromTweetId:nil handler:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *tweets = [weakSelf p_tweetModelsFromData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                [feed updateWithTweets:tweets];

                if (completionHandler != nil)
                    completionHandler(error);
            });
        });
    }];
}

- (void)fetchNextForFeed:(RATFeed *)feed withHandler:(void (^)(NSArray *addedTweets, NSError *error))completionHandler;
{
    RATTweet *lastTweet = feed.tweets.lastObject;

    NSDecimalNumber *lastId = [lastTweet.tweetId decimalNumberBySubtracting:[NSDecimalNumber one]];

    __weak __typeof(self) weakSelf = self;
    [self p_requestFeedDataForUserName:feed.username sinceTweetId:nil fromTweetId:[lastId stringValue] handler:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *nextTweets = [weakSelf p_tweetModelsFromData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                [feed addNextFromTweets:nextTweets];

                if (completionHandler != nil)
                    completionHandler(nextTweets, error);
            });
        });
    }];
}

- (void)fetchUpdatesForFeed:(RATFeed *)feed withHandler:(void (^)(NSError *error))completionHandler;
{
    RATTweet *firstTweet = feed.tweets.firstObject;
    NSString *sinceId = firstTweet.tweetIdString;

    __weak __typeof(self) weakSelf = self;
    [self p_requestFeedDataForUserName:feed.username sinceTweetId:sinceId fromTweetId:nil handler:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *tweets = [weakSelf p_tweetModelsFromData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                [feed updateWithTweets:tweets];

                if (completionHandler != nil)
                    completionHandler(error);
            });
        });
    }];
}

#pragma mark - Private interface

- (NSArray *)p_tweetModelsFromData:(NSData *)data
{
    if (data == nil)
        return nil;

    NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    if (![result isKindOfClass:[NSArray class]])
        return  nil;

    NSMutableArray *tweetsTemp = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in result)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            RATTweet *tweet = [[RATTweet alloc] initWithDictionary:dict];
            if (tweet != nil)
                [tweetsTemp addObject:tweet];
        }
    }

    NSArray *tweets = [tweetsTemp copy];

    return tweets;
}

- (void)p_requestFeedDataForUserName:(NSString *)username sinceTweetId:(NSString *)sinceId fromTweetId:(NSString *)fromId handler:(void (^)(NSData *data, NSError *error))completionHandler
{
    if (username == nil)
    {
        if (completionHandler != nil)
            completionHandler(nil, nil);

        return;
    }

    NSString *authString = [@"Bearer " stringByAppendingString:kNetworkApiToken];
    NSDictionary *headers = @{@"Authorization" : authString};

    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithCapacity:0];
    if (username != nil)
        [query setObject:username forKey:@"screen_name"];

    if (fromId != nil)
        [query setObject:fromId forKey:@"max_id"];

    if (sinceId != nil)
        [query setObject:sinceId forKey:@"since_id"];

    NSString *count = [NSString stringWithFormat:@"%li", (unsigned long)kTweetsCountPerPage];
    [query setObject:count forKey:@"count"];

    [_networking performRequestForUrlString:kNetworkFeedUrl headers:headers query:query completionHandler:completionHandler];
}

@end
