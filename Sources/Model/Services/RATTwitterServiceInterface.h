//
//  RATTwitterServiceInterface.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

@class RATFeed;

@protocol RATTwitterServiceInterface <NSObject>

- (void)fetchFeed:(RATFeed *)feed withHandler:(void (^)(NSError *error))completionHandler;
- (void)fetchNextForFeed:(RATFeed *)feed withHandler:(void (^)(NSArray *addedTweets, NSError *error))completionHandler;
- (void)fetchUpdatesForFeed:(RATFeed *)feed withHandler:(void (^)(NSError *error))completionHandler;

@end
