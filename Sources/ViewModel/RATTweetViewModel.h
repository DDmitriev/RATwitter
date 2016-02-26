//
//  RATTweetViewModel.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATCommonViewModel.h"

@class RATTweet;

@interface RATTweetViewModel : RATCommonViewModel

@property (nonatomic, strong, readonly) NSString *authorNameText;
@property (nonatomic, strong, readonly) NSString *bodyText;
@property (nonatomic, strong, readonly) NSString *dateText;
@property (nonatomic, strong, readonly) UIImage *mediaImage;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithServices:(RATServices *)services NS_UNAVAILABLE;

- (instancetype)initWithTweet:(RATTweet *)tweet withServices:(RATServices *)services NS_DESIGNATED_INITIALIZER;

- (void)userNeedToSeeUI;

@end
