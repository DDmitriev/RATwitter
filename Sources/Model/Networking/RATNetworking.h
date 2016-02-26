//
//  RATNetworking.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RATNetworking : NSObject

- (void)performRequestForUrlString:(NSString *)urlString headers:(NSDictionary *)headers query:(NSDictionary *)queryParams completionHandler:(void (^)(NSData *data, NSError *error))completionHandler;

@end
