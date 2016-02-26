//
//  RATTweet.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RATTweet : NSObject

@property (nonatomic, strong, readonly) NSDecimalNumber *tweetId;
@property (nonatomic, strong, readonly) NSString *tweetIdString;
@property (nonatomic, strong, readonly) NSString *authorName;
@property (nonatomic, strong, readonly) NSString *body;
@property (nonatomic, strong, readonly) NSString *mediaUrl;
@property (nonatomic, strong, readonly) NSString *date;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

@end
