//
//  RATFeed.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RATFeed : NSObject

@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSArray *tweets;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUsername:(NSString *)username NS_DESIGNATED_INITIALIZER;

- (void)updateWithTweets:(NSArray *)tweets;
- (void)addNextFromTweets:(NSArray *)nextTweets;

@end
