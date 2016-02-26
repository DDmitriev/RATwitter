//
//  RATFeedViewModel.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATFeedViewModel.h"
#import "RATFeed.h"
#import "RATUser.h"
#import "RATTweetViewModel.h"

@interface RATFeedViewModel ()
{
}

@property (nonatomic, strong, readwrite) RATUser *user;

@property (nonatomic, strong, readwrite) NSString *screenTitleText;
@property (nonatomic, strong, readwrite) NSMutableArray *tweetViewModels;
@property (nonatomic, strong, readwrite) NSArray *recentlyLoadedNextTweetViewModels;
@property (nonatomic, assign, readwrite) BOOL showActivity;
@property (nonatomic, strong, readwrite) NSString *errorText;
@property (nonatomic, assign, readwrite) BOOL pageLoading;


- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithServices:(RATServices *)services NS_DESIGNATED_INITIALIZER;

- (NSMutableArray *)p_tweetVMsFromTweetDMOs:(NSArray *)tweetDMOs;

@end

@implementation RATFeedViewModel

@synthesize tweetViewModels;

#pragma mark - Initializers

- (instancetype)init
{
    @throw nil;
}

- (instancetype)initWithServices:(RATServices *)services
{
    @throw nil;
}

- (instancetype)initWithUser:(RATUser *)user withServices:(RATServices *)services
{
    self = [super initWithServices:services];
    if (self)
    {
        _user = user;

        _screenTitleText = [@"@" stringByAppendingString:self.user.feed.username];
        _showActivity = NO;
    }

    return self;
}

#pragma mark - Public interface

- (void)userNeedToSeeUI
{
    self.showActivity = YES;

    __weak __typeof(self) weakSelf = self;
    [self.services.twitterService fetchFeed:self.user.feed withHandler:^(NSError *error) {
        weakSelf.showActivity = NO;

        if (error == nil)
        {
            weakSelf.tweetViewModels = [weakSelf p_tweetVMsFromTweetDMOs:weakSelf.user.feed.tweets];
        }
        else
            weakSelf.errorText = [error localizedDescription];
    }];
}

- (void)userDidTriggerPagination
{
    if (self.pageLoading)
        return;

    self.showActivity = YES;
    self.pageLoading = YES;

    __weak __typeof(self) weakSelf = self;
    [self.services.twitterService fetchNextForFeed:self.user.feed withHandler:^(NSArray *addedTweets, NSError *error) {
        weakSelf.showActivity = NO;
        weakSelf.pageLoading = NO;

        if (error == nil)
        {
            NSMutableArray *tweetVMsToAdd = [weakSelf p_tweetVMsFromTweetDMOs:addedTweets];
            weakSelf.recentlyLoadedNextTweetViewModels = tweetVMsToAdd;
        }
        else
            weakSelf.errorText = [error localizedDescription];
    }];
}

- (void)userWillSeeRecenlyLoadedTweets
{
    [self.tweetViewModels addObjectsFromArray:self.recentlyLoadedNextTweetViewModels];
}

- (void)userDidSeeRecenlyLoadedTweets
{
    self.recentlyLoadedNextTweetViewModels = nil;
}

#pragma mark - Private interface

- (NSMutableArray *)p_tweetVMsFromTweetDMOs:(NSArray *)tweetDMOs
{
    NSMutableArray *tweetVMs = [NSMutableArray arrayWithCapacity:0];
    for (RATTweet *tweet in tweetDMOs)
    {
        RATTweetViewModel *tweetVM = [[RATTweetViewModel alloc] initWithTweet:tweet withServices:self.services];
        [tweetVMs addObject:tweetVM];
    }

    return tweetVMs;
}

@end
