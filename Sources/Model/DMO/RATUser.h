//
//  RATUser.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RATFeed;

@interface RATUser : NSObject

@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) RATFeed *feed;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUsername:(NSString *)username NS_DESIGNATED_INITIALIZER;

@end
