//
//  RATFeedView.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATFeedView.h"
#import <Masonry/Masonry.h>

@interface RATFeedView ()

@property (nonatomic, strong, readwrite) UITableView *tableView;

@end

@implementation RATFeedView

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor greenColor];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.allowsSelection = NO;
        _tableView.autoresizingMask = self.autoresizingMask;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80.;
        [self addSubview:_tableView];

        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    return self;
}

@end
