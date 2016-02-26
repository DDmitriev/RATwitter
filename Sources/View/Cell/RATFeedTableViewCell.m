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

static void *RATFTVCContext = &RATFTVCContext;

@interface RATFeedTableViewCell ()

@property (nonatomic, strong, readonly) UILabel *authorLabel;
@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UILabel *bodyLabel;
@property (nonatomic, strong, readonly) UIImageView *mediaView;

- (void)p_setupConstraints;
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
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _authorLabel.numberOfLines = 1.;
        _authorLabel.textAlignment = NSTextAlignmentLeft;
        _authorLabel.textColor = [RATInterface defaultFontColor];
        [self.contentView addSubview:_authorLabel];

        _bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bodyLabel.numberOfLines = 0.;
        _bodyLabel.textAlignment = NSTextAlignmentLeft;
        _bodyLabel.textColor = [RATInterface darkFontColor];
        [self.contentView addSubview:_bodyLabel];

        _mediaView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mediaView.translatesAutoresizingMaskIntoConstraints = NO;
        _mediaView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_mediaView];

        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _dateLabel.numberOfLines = 1.;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.textColor = [RATInterface lightFontColor];
        [self.contentView addSubview:_dateLabel];

        [self adjustDynamicFonts];
        [self p_setupConstraints];
    }

    return self;
}

- (void)dealloc
{
    [self p_removeObserversForTweetVM:_tweetVM];
}

#pragma mark - Property override

- (void)setTweetVM:(RATTweetViewModel *)tweetVM
{
    [self p_removeObserversForTweetVM:_tweetVM];
    _tweetVM = tweetVM;
    [self p_addObserversForTweetVM:_tweetVM];

    [self p_fillFromVM:_tweetVM];
    [_tweetVM userNeedToSeeUI];
}

#pragma mark - Public interface

- (void)adjustDynamicFonts
{
    _authorLabel.font = [RATInterface smallFont];
    _bodyLabel.font = [RATInterface bodyFont];
    _dateLabel.font = [RATInterface smallFont];
}

#pragma mark - Private interface

- (void)p_setupConstraints
{
    CGFloat xOffset = 8.;
    CGFloat yOffset = 4.;

    [self.authorLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:yOffset].active = YES;
    [self.authorLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:xOffset].active = YES;
    [self.authorLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-xOffset].active = YES;

    [self.bodyLabel.topAnchor constraintEqualToAnchor:self.authorLabel.bottomAnchor constant:yOffset].active = YES;
    [self.bodyLabel.leadingAnchor constraintEqualToAnchor:self.authorLabel.leadingAnchor].active = YES;
    [self.bodyLabel.trailingAnchor constraintEqualToAnchor:self.authorLabel.trailingAnchor].active = YES;

    [self.mediaView.topAnchor constraintEqualToAnchor:self.bodyLabel.bottomAnchor constant:yOffset].active = YES;
    [self.mediaView.leadingAnchor constraintEqualToAnchor:self.bodyLabel.leadingAnchor].active = YES;
    [self.mediaView.trailingAnchor constraintEqualToAnchor:self.bodyLabel.trailingAnchor].active = YES;
    [self.mediaView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;

    [self.dateLabel.topAnchor constraintEqualToAnchor:self.mediaView.bottomAnchor constant:yOffset].active = YES;
    [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.bodyLabel.leadingAnchor].active = YES;
    [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.bodyLabel.trailingAnchor].active = YES;

    [self.contentView.bottomAnchor constraintEqualToAnchor:self.dateLabel.bottomAnchor constant:yOffset].active = YES;
    [self.contentView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
}

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
