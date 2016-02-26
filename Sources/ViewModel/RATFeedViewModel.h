//
//  RATFeedViewModel.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATCommonViewModel.h"

@class RATUser;

@interface RATFeedViewModel : RATCommonViewModel

@property (nonatomic, strong, readonly) NSString *screenTitleText;
@property (nonatomic, strong, readonly) NSMutableArray *tweetViewModels;
@property (nonatomic, strong, readonly) NSArray *recentlyLoadedNextTweetViewModels;
@property (nonatomic, assign, readonly) BOOL showActivity;
@property (nonatomic, strong, readonly) NSString *errorText;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithServices:(RATServices *)services NS_UNAVAILABLE;
- (instancetype)initWithUser:(RATUser *)user withServices:(RATServices *)services NS_DESIGNATED_INITIALIZER;

- (void)userNeedToSeeUI;
- (void)userDidTriggerPagination;
- (void)userWillSeeRecenlyLoadedTweets;
- (void)userDidSeeRecenlyLoadedTweets;

@end
