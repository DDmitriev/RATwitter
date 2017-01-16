//
//  RATFeedTableViewCell.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 26.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATFeedTableViewCell.h"
#import "RATTweetViewModel.h"
#import "RATInterface.h"

#import <Masonry/Masonry.h>

static void *RATFTVCContext = &RATFTVCContext;

@interface RATFeedTableViewCell ()

@property (nonatomic, strong, readonly) UILabel *authorLabel;
@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UILabel *bodyLabel;
@property (nonatomic, strong, readonly) UIImageView *mediaView;

- (void)p_fillFromVM:(RATTweetViewModel *)tweetVM;
- (void)p_addObserversForTweetVM:(RATTweetViewModel *)tweetVM;
- (void)p_removeObserversForTweetVM:(RATTweetViewModel *)tweetVM;

@end

@interface RATFeedTableViewCell (KVO)

- (void)p_mediaImageChanged;

@end


@implementation RATFeedTableViewCell

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self != nil)
    {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _authorLabel.numberOfLines = 1.;
        _authorLabel.textAlignment = NSTextAlignmentLeft;
        _authorLabel.textColor = [RATInterface defaultFontColor];
        [self.contentView addSubview:_authorLabel];

        _bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bodyLabel.numberOfLines = 0.;
        _bodyLabel.textAlignment = NSTextAlignmentLeft;
        _bodyLabel.textColor = [RATInterface darkFontColor];
        [self.contentView addSubview:_bodyLabel];

        _mediaView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mediaView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_mediaView];

        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.numberOfLines = 1.;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.textColor = [RATInterface lightFontColor];
        [self.contentView addSubview:_dateLabel];

        [self adjustDynamicFonts];
    }

    return self;
}

- (void)dealloc
{
    [self p_removeObserversForTweetVM:_tweetVM];
}

#pragma mark - Class override

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Property override

- (void)setTweetVM:(RATTweetViewModel *)tweetVM
{
    [self p_removeObserversForTweetVM:_tweetVM];
    _tweetVM = tweetVM;
    [self p_addObserversForTweetVM:_tweetVM];

    [self p_fillFromVM:_tweetVM];
    [_tweetVM userNeedToSeeUI];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Override

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.authorLabel.text = nil;
    self.bodyLabel.text = nil;
    self.dateLabel.text = nil;
    self.mediaView.image = nil;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    CGFloat xOffset = 8.;
    CGFloat yOffset = 4.;
    
    [self.authorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(yOffset);
        make.leading.mas_equalTo(self.contentView).mas_offset(xOffset);
        make.trailing.mas_equalTo(self.contentView).mas_offset(-xOffset);
    }];
    
    [self.bodyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authorLabel.mas_bottom).mas_offset(yOffset);
        make.leading.mas_equalTo(self.contentView).mas_offset(xOffset);
        make.trailing.mas_equalTo(self.contentView).mas_offset(-xOffset);
    }];

    [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bodyLabel.mas_bottom).mas_offset(yOffset);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_lessThanOrEqualTo(100.);
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mediaView.mas_bottom).mas_offset(yOffset);
        make.leading.mas_equalTo(self.contentView).mas_offset(xOffset);
        make.trailing.mas_equalTo(self.contentView).mas_offset(-xOffset);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-yOffset);
    }];
}

#pragma mark - Public interface

- (void)adjustDynamicFonts
{
    self.authorLabel.font = [RATInterface smallFont];
    self.bodyLabel.font = [RATInterface bodyFont];
    self.dateLabel.font = [RATInterface smallFont];
}

#pragma mark - Private interface

- (void)p_fillFromVM:(RATTweetViewModel *)tweetVM
{
    self.authorLabel.text = tweetVM.authorNameText;
    self.bodyLabel.text = tweetVM.bodyText;
    self.dateLabel.text = tweetVM.dateText;
    self.mediaView.image = tweetVM.mediaImage;
}

- (void)p_addObserversForTweetVM:(RATTweetViewModel *)tweetVM
{
    if (tweetVM == nil)
        return;

    [tweetVM addObserver:self forKeyPath:NSStringFromSelector(@selector(mediaImage)) options:NSKeyValueObservingOptionNew context:RATFTVCContext];
}

- (void)p_removeObserversForTweetVM:(RATTweetViewModel *)tweetVM
{
    if (tweetVM == nil)
        return;

    @try
    {
        [tweetVM removeObserver:self forKeyPath:NSStringFromSelector(@selector(mediaImage)) context:RATFTVCContext];
    }
    @catch (NSException *__unused exception) {}
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == RATFTVCContext)
    {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(mediaImage))])
            [self p_mediaImageChanged];
    }
}

- (void)p_mediaImageChanged
{
    UIImage *image = _tweetVM.mediaImage;

    if (self.mediaView.image != image)
    {
        self.mediaView.image = image;

        [self.delegate didInvalidateLayoutInCell:self forTweetVM:_tweetVM];
    }
}

@end
