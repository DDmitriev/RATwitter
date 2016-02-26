//
//  RATTweetViewModel.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATTweetViewModel.h"
#import "RATTweet.h"

@interface RATTweetViewModel ()
{
    RATTweet *_tweet;

}

@property (nonatomic, strong, readwrite) NSString *authorNameText;
@property (nonatomic, strong, readwrite) NSString *bodyText;
@property (nonatomic, strong, readwrite) NSString *dateText;
@property (nonatomic, strong, readwrite) UIImage *mediaImage;
@property (nonatomic, assign, readwrite) BOOL imageLoading;


- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithServices:(RATServices *)services NS_DESIGNATED_INITIALIZER;

- (NSDateFormatter *)p_twitterDateFormatter;
- (NSDateFormatter *)p_shortDateFormatter;

@end

@implementation RATTweetViewModel

#pragma mark - Initializers

- (instancetype)init
{
    @throw nil;
}

- (instancetype)initWithServices:(RATServices *)services
{
    @throw nil;
}

- (instancetype)initWithTweet:(RATTweet *)tweet withServices:(RATServices *)services
{
    self = [super initWithServices:services];
    if (self)
    {
        _tweet = tweet;

        _authorNameText = _tweet.authorName;
        _bodyText = _tweet.body;
        NSDate *date = [[self p_twitterDateFormatter] dateFromString:_tweet.date];
        _dateText = [[self p_shortDateFormatter] stringFromDate: date];
    }

    return self;
}

#pragma mark - Public interface

- (void)userNeedToSeeUI
{
    if (self.imageLoading || self.mediaImage != nil)
        return;

    self.imageLoading = YES;
    NSURL *url = [NSURL URLWithString:_tweet.mediaUrl];

    __weak __typeof(self) weakSelf = self;
    [self.services.imageService fetchImageFromURL:url withHandler:^(UIImage *image) {
        weakSelf.mediaImage = image;
        weakSelf.imageLoading = NO;
    }];
}


#pragma mark - Private interface

- (NSDateFormatter *)p_twitterDateFormatter
{
    static NSDateFormatter *twitterDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        twitterDateFormatter = [[NSDateFormatter alloc] init];
        twitterDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [twitterDateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    });

    return twitterDateFormatter;
}

- (NSDateFormatter *)p_shortDateFormatter
{
    static NSDateFormatter *shortDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shortDateFormatter = [[NSDateFormatter alloc] init];
        shortDateFormatter.dateFormat = @"dd MMM yyyy";
    });

    return shortDateFormatter;
}

@end
