//
//  RATTweet.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATTweet.h"

@interface RATTweet ()

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation RATTweet

#pragma mark - Initializers

- (instancetype)init
{
    @throw nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];

    if (self != nil && [dictionary isKindOfClass:[NSDictionary class]])
    {
        NSString *tempString = dictionary[@"id_str"];
        if ([tempString isKindOfClass:[NSString class]])
            _tweetIdString = tempString;

        _date = dictionary[@"created_at"];
        _tweetId = [NSDecimalNumber decimalNumberWithString:_tweetIdString];

        NSDictionary *entities = dictionary[@"entities"];
        NSArray *media = entities[@"media"];

        if (media != nil && [media isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *mediaItem in media)
            {
                NSString *type = mediaItem[@"type"];
                if ([type isEqualToString:@"photo"])
                {
                    _mediaUrl = [mediaItem[@"media_url_https"] stringByAppendingString:@":small"];
                    break;
                }

            }
        }

        if (_tweetIdString == nil || _tweetId == nil)
            return nil;

        NSDictionary *retweetedStatus = dictionary[@"retweeted_status"];
        BOOL isRetweet = retweetedStatus != nil;
        if (isRetweet)
            dictionary = retweetedStatus;

        _body = dictionary[@"text"];

        NSDictionary *user = dictionary[@"user"];
        _authorName = user[@"name"];
    }

    return self;
}

@end
