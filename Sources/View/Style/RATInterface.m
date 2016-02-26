//
//  RATInterface.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATInterface.h"

@implementation RATInterface

#pragma mark - Fonts

+ (UIFont *)bodyFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

}

+ (UIFont *)smallFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

#pragma mark - Colors

+ (UIColor *)defaultFontColor
{
    return [UIColor grayColor];
}

+ (UIColor *)lightFontColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)darkFontColor
{
    return [UIColor darkTextColor];
}


@end
