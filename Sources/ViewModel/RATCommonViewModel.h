//
//  RATCommonViewModel.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RATServices.h"

@interface RATCommonViewModel : NSObject

@property (nonatomic, readonly) RATServices *services;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithServices:(RATServices *)services NS_DESIGNATED_INITIALIZER;

@end
