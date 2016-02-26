//
//  RATFeedTableViewCell.h
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 26.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RATTweetViewModel;

@protocol RATFeedTableViewCellDelegate;

@interface RATFeedTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) RATTweetViewModel *tweetVM;
@property (nonatomic, weak, readwrite) id <RATFeedTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)adjustDynamicFonts;

@end


@protocol RATFeedTableViewCellDelegate <NSObject>

- (void)didInvalidateLayoutInCell:(RATFeedTableViewCell *)cell forTweetVM:(RATTweetViewModel *)tweetVM;

@end
