//
//  RATServices.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RATTwitterServiceInterface.h"
#import "RATImageServiceInterface.h"

@interface RATServices : NSObject

@property (nonatomic, strong, readonly) id <RATTwitterServiceInterface> twitterService;
@property (nonatomic, strong, readonly) id <RATImageServiceInterface> imageService;

- (instancetype)init;

@end
