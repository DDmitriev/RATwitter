//
//  RATTwitterService.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RATTwitterServiceInterface.h"

@class RATUser;
@class RATNetworking;

@interface RATTwitterService : NSObject <RATTwitterServiceInterface>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNetworking:(RATNetworking *)networking NS_DESIGNATED_INITIALIZER;

@end
