//
//  RATNetworking.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATNetworking.h"

@interface RATNetworking ()
{
}

- (NSURL *)p_urlByModifyingParametersInUrl:(NSURL *)url parametersBlock:(void (^)(NSMutableDictionary  *parameters))block;

@end

@implementation RATNetworking

#pragma mark - Public interface

- (void)performRequestForUrlString:(NSString *)urlString headers:(NSDictionary *)headers query:(NSDictionary *)queryParams completionHandler:(void (^)(NSData *data, NSError *error))completionHandler
{
    NSURL *url = [NSURL URLWithString:urlString];

    url = [self p_urlByModifyingParametersInUrl:url parametersBlock:^(NSMutableDictionary *parameters) {
        [parameters setValuesForKeysWithDictionary:queryParams];
    }];

#ifdef DEBUG
    NSLog(@"%@", [url absoluteString]);
#endif

    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];

    for (id key in headers)
    {
        id value = headers[key];
        [mutableRequest addValue:value forHTTPHeaderField:key];
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler != nil)
        {
            if (error == nil)
                completionHandler(data, nil);
            else
                completionHandler(nil, error);
        }
    }];

    [task resume];
}

#pragma mark - Private interface

- (NSURL *)p_urlByModifyingParametersInUrl:(NSURL *)url parametersBlock:(void (^)(NSMutableDictionary *parameters))block
{
    if (url == nil)
        return nil;

    NSString *absoluteString = url.absoluteString;
    NSString *originalQuery = url.query;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

    for (NSString *pairString in [originalQuery componentsSeparatedByString:@"&"])
    {
        NSArray *keyValue = [pairString componentsSeparatedByString:@"="];

        if (keyValue.count == 2)
            params[keyValue.firstObject] = [keyValue.lastObject stringByRemovingPercentEncoding];
    }

    if (block != nil)
        block(params);

    NSString *updatedQuery = nil;

    if (params.count > 0)
    {
        NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:0];

        for (id key in params)
        {
            id value = params[key];

            if ([value isKindOfClass:[NSString class]])
            {
                value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }

            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }

        updatedQuery = [pairs componentsJoinedByString:@"&"];
    }

    if (originalQuery == nil)
    {
        if (updatedQuery != nil)
            absoluteString = [absoluteString stringByAppendingString:[@"?" stringByAppendingString:updatedQuery]];
    }
    else
    {
        if (updatedQuery != nil)
            absoluteString = [absoluteString stringByReplacingOccurrencesOfString:originalQuery withString:updatedQuery];
        else
            absoluteString = [absoluteString stringByReplacingOccurrencesOfString:[@"?" stringByAppendingString:originalQuery] withString:@""];
    }

    return [NSURL URLWithString:absoluteString];
}

@end
