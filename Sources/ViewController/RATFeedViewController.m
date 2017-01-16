//
//  RATFeedViewController.m
//  RATwitter
//
//  Created by Dmitriy Dmitriev on 14.02.16.
//  Copyright © 2016 Dmitriy Dmitriev. All rights reserved.
//

#import "RATFeedViewController.h"
#import "RATFeedViewModel.h"
#import "RATFeedView.h"
#import "RATFeedTableViewCell.h"

static void *RATFVCContext = &RATFVCContext;

@interface RATFeedViewController () <UITableViewDataSource, UITableViewDelegate, RATFeedTableViewCellDelegate>
{
    RATFeedViewModel *_feedVM;
    RATFeedView *_feedView;
}

- (void)p_reloadData;

@end

@interface RATFeedViewController (Actions)

@end

@interface RATFeedViewController (Notifications)

- (void)p_didReceiveUIContentSizeCategoryDidChangeNotification:(NSNotification *)notification;

@end

@interface RATFeedViewController (KVO)

- (void)p_collectionStateChanged;
- (void)p_tweetViewModelsChanged;
- (void)p_recentlyLoadedNextTweetViewModelsChanged;
- (void)p_showActivityChanged;
- (void)p_errorTextChanged;

@end

@implementation RATFeedViewController

#pragma mark - Initializers

- (instancetype)initWithFeedViewModel:(RATFeedViewModel*)feedVM
{
    self = [super init];
    if (self)
    {
        _feedVM = feedVM;
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    @try {
        [_feedVM removeObserver:self forKeyPath:NSStringFromSelector(@selector(tweetViewModels)) context:RATFVCContext];
        [_feedVM removeObserver:self forKeyPath:NSStringFromSelector(@selector(recentlyLoadedNextTweetViewModels)) context:RATFVCContext];
        [_feedVM removeObserver:self forKeyPath:NSStringFromSelector(@selector(showActivity)) context:RATFVCContext];
        [_feedVM removeObserver:self forKeyPath:NSStringFromSelector(@selector(errorText)) context:RATFVCContext];
    }
    @catch (NSException *__unused exception) {}
}

#pragma mark - View controller methods

- (void)loadView
{
    _feedView = [[RATFeedView alloc] initWithFrame:CGRectZero];
    self.view = _feedView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = _feedVM.screenTitleText;

    NSString *cellIdentifier = NSStringFromClass([RATFeedTableViewCell class]);
    [_feedView.tableView registerClass:[RATFeedTableViewCell class] forCellReuseIdentifier:cellIdentifier];

    _feedView.tableView.dataSource = self;
    _feedView.tableView.delegate = self;

    [_feedVM addObserver:self forKeyPath:NSStringFromSelector(@selector(tweetViewModels)) options:NSKeyValueObservingOptionNew context:RATFVCContext];
    [_feedVM addObserver:self forKeyPath:NSStringFromSelector(@selector(recentlyLoadedNextTweetViewModels)) options:NSKeyValueObservingOptionNew context:RATFVCContext];
    [_feedVM addObserver:self forKeyPath:NSStringFromSelector(@selector(showActivity)) options:NSKeyValueObservingOptionNew context:RATFVCContext];
    [_feedVM addObserver:self forKeyPath:NSStringFromSelector(@selector(errorText)) options:NSKeyValueObservingOptionNew context:RATFVCContext];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_didReceiveUIContentSizeCategoryDidChangeNotification:) name:UIContentSizeCategoryDidChangeNotification object:nil];

    [_feedVM userNeedToSeeUI];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [self p_reloadData];
}

#pragma mark - Private interface

- (void)p_reloadData
{
    [_feedView.tableView reloadData];
}

#pragma mark -
#pragma mark *** UITableViewDelegate, UITableViewDataSource interface ***
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feedVM.tweetViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = NSStringFromClass([RATFeedTableViewCell class]);
    RATFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.tweetVM = _feedVM.tweetViewModels[indexPath.item];
    cell.delegate = self;

    [cell adjustDynamicFonts];

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == scrollView.contentSize.height - CGRectGetHeight(scrollView.frame))
    {
        [_feedVM userDidTriggerPagination];
    }
}

#pragma mark - RATFeedTableViewCellDelegate

- (void)didInvalidateLayoutInCell:(RATFeedTableViewCell *)cell forTweetVM:(RATTweetViewModel *)tweetVM
{
    NSInteger row = [_feedVM.tweetViewModels indexOfObject:tweetVM];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_feedView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Notifications

- (void)p_didReceiveUIContentSizeCategoryDidChangeNotification:(NSNotification *)notification
{
    [self p_reloadData];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void* )context
{
    if (context == RATFVCContext)
    {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(tweetViewModels))])
            [self p_tweetViewModelsChanged];
        else if ([keyPath isEqualToString:NSStringFromSelector(@selector(recentlyLoadedNextTweetViewModels))])
            [self p_recentlyLoadedNextTweetViewModelsChanged];
        else if ([keyPath isEqualToString:NSStringFromSelector(@selector(showActivity))])
            [self p_showActivityChanged];
        else if ([keyPath isEqualToString:NSStringFromSelector(@selector(errorText))])
            [self p_errorTextChanged];
    }
}

- (void)p_collectionStateChanged
{
    [self p_reloadData];
}

- (void)p_tweetViewModelsChanged
{
    [self p_reloadData];
}

- (void)p_recentlyLoadedNextTweetViewModelsChanged
{
    if (_feedVM.recentlyLoadedNextTweetViewModels.count == 0)
        return;

    NSMutableArray *mIndexPathsToInsert= [NSMutableArray arrayWithCapacity:0];
    NSInteger index = _feedVM.tweetViewModels.count;

    for (__unused id tweetVM in _feedVM.recentlyLoadedNextTweetViewModels)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [mIndexPathsToInsert addObject:indexPath];
        index++;
    }

    [_feedVM userWillSeeRecenlyLoadedTweets];

    [_feedView.tableView beginUpdates];
    [_feedView.tableView insertRowsAtIndexPaths:mIndexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
    [_feedView.tableView endUpdates];

    [_feedVM userDidSeeRecenlyLoadedTweets];
}

- (void)p_showActivityChanged
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = _feedVM.showActivity;
}

- (void)p_errorTextChanged
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:_feedVM.errorText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
