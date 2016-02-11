//
//  FeedNotificationsViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FeedNotificationsViewController.h"
#import "Global.h"
#import "MenuTabViewController.h"
#import "FeedService.h"
#import "UserProfileViewController.h"
#import "CatProfileViewController.h"
#import "FeedMainViewController.h"

@interface FeedNotificationsViewController ()

@end

@implementation FeedNotificationsViewController
@synthesize m_arrayData;
@synthesize m_arrayResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.m_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"settings_notifications", nil);

    m_arrayResult = [[NSMutableArray alloc] init];
    m_arrayData = [[NSMutableArray alloc] init];

    lBeforeId = 0;
    lSinceId = 0;
    
    FAKFontAwesome *naviBackIcon = [FAKFontAwesome arrowLeftIconWithSize:NAVI_ICON_SIZE];
    [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imgBack = [naviBackIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item0.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
    self.navigationItem.leftBarButtonItems = @[item0, item1];
 
    __weak FeedNotificationsViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.m_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadAboveMore];
    }];
    
    // setup infinite scrolling
    [self.m_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBelowMore];
    }];

    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    bLoad = false;
    
    bDirectionMode = false;
    lBeforeId = 0;
    lSinceId = 0;
    
    [self getNotificationRequest];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    self.navigationController.navigationBar.translucent = NO;
}

- (void) loadAboveMore
{
    bDirectionMode = true;
    
    [self getNotificationRequest];
}

- (void) loadBelowMore
{
    bDirectionMode = false;
    
    [self getNotificationRequest];
}

- (void)insertRowAtTop {
    __weak FeedNotificationsViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = weakSelf.m_arrayData.count - 1; nIdx >= 0; nIdx--)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult insertObject:[weakSelf.m_arrayData objectAtIndex:nIdx] atIndex:0];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.pullToRefreshView stopAnimating];
    });
}


- (void)insertRowAtBottom {
    __weak FeedNotificationsViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = 0; nIdx < weakSelf.m_arrayData.count; nIdx++)
        {
            [weakSelf.m_tableView beginUpdates];
            [weakSelf.m_arrayResult addObject:[weakSelf.m_arrayData objectAtIndex:nIdx]];
            [weakSelf.m_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.m_arrayResult.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.m_tableView endUpdates];
        }
        
        [weakSelf.m_tableView.infiniteScrollingView stopAnimating];
    });
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) getNotificationRequest
{
    [self showLoadingView];

    if (!bLoad)
        [FeedService getNotificationsWithSiceId:0 beforeId:0 withDelegate:self];
    else
    {
        if (bDirectionMode)
            [FeedService getNotificationsWithSiceId:lSinceId beforeId:0 withDelegate:self];
        else
            [FeedService getNotificationsWithSiceId:0 beforeId:lBeforeId withDelegate:self];
    }
}

- (void) backToMainView
{
    [g_Delegate.m_curMenuTabViewCon.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLoadingView
{
    [self.view endEditing:YES];
    
    [YXSpritesLoadingView showWithText:NSLocalizedString(@"loading", nil) andShimmering:YES andBlurEffect:NO];
}

- (void) hideLoadingView
{
    [YXSpritesLoadingView dismiss];
}

- (void) tapGesture:(UITapGestureRecognizer *) sender
{
    NSLog(@"tapped photo");
    UIImageView* catImageView = (UIImageView *)(sender.view);
    int nCatIdx = (int)[catImageView.accessibilityLabel integerValue];
    
    NotificationEntity* notificationEntity = [m_arrayResult objectAtIndex:nCatIdx];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    if ([notificationEntity.m_strActionType isEqualToString:@"LIKE"] || [notificationEntity.m_strActionType isEqualToString:@"FOLLOW_REQUEST"] || [notificationEntity.m_strActionType isEqualToString:@"NEW_FRIEND"] || [notificationEntity.m_strActionType isEqualToString:@"NEW_PROFILE"])
    {
        UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
        viewCon.m_bMyProfile = false;
        viewCon.m_nUserId = notificationEntity.m_nFromUserID;
        
        [self.navigationController pushViewController:viewCon animated:YES];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
}

- (CGFloat) getCellHeight:(int) nIdx
{
    NotificationEntity* notificationEntity = [m_arrayResult objectAtIndex:nIdx];
    
    NSString* strText = @"";
    float fImageWidth = 0.f;
    
    if ([notificationEntity.m_strActionType isEqualToString:@"BADGE"])
    {
        strText = notificationEntity.m_strText;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"FOLLOW_REQUEST"])
    {
        strText = notificationEntity.m_strText;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"LIKE"] || [notificationEntity.m_strActionType isEqualToString:@"COMMENT"])
    {
        strText = notificationEntity.m_strText;
        fImageWidth = 60.f;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_FRIEND"])
    {
        strText = notificationEntity.m_strText;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_PROFILE"])
    {
        strText = notificationEntity.m_strText;
    }
    
    float fHeight = 0.f;
    
    if (strText.length == 0 || [strText isEqualToString:@""])
        fHeight = 54.f;
    else
        fHeight = [[Utils sharedObject] getHeightOfText:strText fontSize:16.f width:self.view.frame.size.width - 60.f - fImageWidth] + 30.f;
    
    return fHeight + 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_arrayResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"notificationcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NotificationEntity* notificationEntity = [m_arrayResult objectAtIndex:indexPath.row];
    
    UIImageView* imageView = (UIImageView *)[cell viewWithTag:10];
    imageView.layer.cornerRadius = imageView.frame.size.height / 2.f;
    imageView.layer.borderColor = MAIN_COLOR.CGColor;
    imageView.layer.borderWidth = 3.f;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    
    imageView.userInteractionEnabled = YES;
    imageView.accessibilityLabel = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    UITapGestureRecognizer *tapGestureForImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGestureForImage.numberOfTapsRequired = 1;
    [tapGestureForImage setDelegate:self];
    [imageView addGestureRecognizer:tapGestureForImage];

    UIImageView* imagePhotoView = (UIImageView *)[cell viewWithTag:13];
    imagePhotoView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    UILabel* lblText = (UILabel *)[cell viewWithTag:11];
    UILabel* lblDate = (UILabel *)[cell viewWithTag:12];
    UIView* viewContainer = (UIView *)[cell viewWithTag:20];
    
    lblText.numberOfLines = 0;
    lblText.lineBreakMode = NSLineBreakByWordWrapping;
    
    imagePhotoView.hidden = YES;
    NSString* strText = @"";
    
    imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    if ([notificationEntity.m_strActionType isEqualToString:@"BADGE"])
    {
        imageView.layer.borderWidth = 0.f;
        imageView.layer.borderColor = MAIN_COLOR.CGColor;
        imageView.clipsToBounds = YES;
        strText = notificationEntity.m_strText;
        imageView.image = [UIImage imageNamed:[[Utils sharedObject] getBadgeImageName:notificationEntity.m_badge]];
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"FOLLOW_REQUEST"])
    {
        strText = notificationEntity.m_strText;
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:notificationEntity.m_strProfileImageLink imageView:imageView];
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"LIKE"] || [notificationEntity.m_strActionType isEqualToString:@"COMMENT"])
    {
        imagePhotoView.hidden = NO;
        strText = notificationEntity.m_strText;
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:notificationEntity.m_strProfileImageLink imageView:imageView];
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:notificationEntity.m_strDeatilImageLink imageView:imagePhotoView];
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_FRIEND"])
    {
        strText = notificationEntity.m_strText;
        if (notificationEntity.m_strProfileImageLink.length == 0 || [notificationEntity.m_strProfileImageLink isEqualToString:@""])
            imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        else
            [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:notificationEntity.m_strProfileImageLink imageView:imageView];
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_PROFILE"])
    {
        strText = notificationEntity.m_strText;
        if (notificationEntity.m_strProfileImageLink.length == 0 || [notificationEntity.m_strProfileImageLink isEqualToString:@""])
            imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        else
            [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:notificationEntity.m_strProfileImageLink imageView:imageView];
    }

    float fHeight = 0.f;
    
    imagePhotoView.center = CGPointMake(self.view.frame.size.width - 5.f - 60.f / 2, [self getCellHeight:indexPath.row] / 2.f);
    
    if ([notificationEntity.m_strActionType isEqualToString:@"LIKE"] || [notificationEntity.m_strActionType isEqualToString:@"COMMENT"])
    {
        fHeight = [[Utils sharedObject] getHeightOfText:strText fontSize:16.f width:self.view.frame.size.width - 50.f - 60.f];
        
        lblText.frame = CGRectMake(50.f, 0.f, self.view.frame.size.width - 60.f - 60.f, fHeight + 30.f);
    }
    else
    {
        fHeight = [[Utils sharedObject] getHeightOfText:strText fontSize:16.f width:self.view.frame.size.width - 50.f];
        
        lblText.frame = CGRectMake(50.f, 0.f, self.view.frame.size.width - 50.f, fHeight + 30.f);
    }
    
    lblDate.frame = CGRectMake(50.f, 5.f + fHeight + 30.f, 200.f, 20.f);
    
    lblText.text = strText;
    lblDate.text = [[Utils sharedObject] DateToString:[[Utils sharedObject] getDateFromMilliSec:notificationEntity.m_nDate] withFormat:@"MMM dd"];
    
    NSString* strHeightText = @"";
    float fImageWidth = 0.f;
    
    if ([notificationEntity.m_strActionType isEqualToString:@"BADGE"])
    {
        strHeightText = notificationEntity.m_strText;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"FOLLOW_REQUEST"])
    {
        strHeightText = notificationEntity.m_strText;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"LIKE"] || [notificationEntity.m_strActionType isEqualToString:@"COMMENT"])
    {
        strHeightText = notificationEntity.m_strText;
        fImageWidth = 60.f;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_FRIEND"])
    {
        strHeightText = notificationEntity.m_strText;
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_PROFILE"])
    {
        strHeightText = notificationEntity.m_strText;
    }
    
    if (strText.length == 0 || [strText isEqualToString:@""])
        fHeight = 54.f;
    else
        fHeight = [[Utils sharedObject] getHeightOfText:strText fontSize:16.f width:self.view.frame.size.width - 60.f - fImageWidth] + 30.f;

    viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, fHeight + 30.f - 6.f);
    
    viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    viewContainer.layer.borderWidth = 1.f;
    viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];

    NotificationEntity* notificationEntity = [m_arrayResult objectAtIndex:indexPath.row];
    if ([notificationEntity.m_strActionType isEqualToString:@"FOLLOW_REQUEST"])
    {
        CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
        
        viewCon.m_nProfileId = -1;
        viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:notificationEntity.m_strDestinationName];
        
        viewCon.m_strProfileUsername = notificationEntity.m_strDestinationName;
        viewCon.m_profileEntity = nil;
        
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"BADGE"])
    {
        if ([notificationEntity.m_badge.m_strType isEqualToString:@"PROFILE"])
        {
            CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
            
            viewCon.m_nProfileId = -1;
            viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:notificationEntity.m_strDestinationName];
            viewCon.m_bShowBadge = true;
            viewCon.m_strProfileUsername = notificationEntity.m_strDestinationName;
            viewCon.m_profileEntity = nil;
            
            [self.navigationController pushViewController:viewCon animated:YES];
        }
        else
        {
            UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
            viewCon.m_bMyProfile = false;
            viewCon.m_bShowBadge = true;
            viewCon.m_nUserId = notificationEntity.m_owner.m_nID;
            
            [self.navigationController pushViewController:viewCon animated:YES];
        }
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"LIKE"] || [notificationEntity.m_strActionType isEqualToString:@"COMMENT"])
    {
        FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
        feedMainView.m_lPhotoId = notificationEntity.m_nPhotoId;
        
        [self.navigationController pushViewController:feedMainView animated:YES];
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_PROFILE"])
    {
        UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
        viewCon.m_bMyProfile = false;
        viewCon.m_nUserId = notificationEntity.m_nFromUserID;
        
        [self.navigationController pushViewController:viewCon animated:YES];

        /*
        CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
        
        viewCon.m_nProfileId = -1;
        viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:notificationEntity.m_strDestinationName];
        viewCon.m_bShowBadge = true;
        viewCon.m_strProfileUsername = notificationEntity.m_strDestinationName;
        viewCon.m_profileEntity = nil;
        
        [self.navigationController pushViewController:viewCon animated:YES];
         */
    }
    else if ([notificationEntity.m_strActionType isEqualToString:@"NEW_FRIEND"])
    {
        UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
        viewCon.m_bMyProfile = false;
        viewCon.m_nUserId = notificationEntity.m_nFromUserID;
        
        [self.navigationController pushViewController:viewCon animated:YES];
    }

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];

    [self.m_tableView.pullToRefreshView stopAnimating];
    [self.m_tableView.infiniteScrollingView stopAnimating];

    NSString *receivedData = [request responseString];
    NSArray* arrResponse = [receivedData JSONValue];
    
    if (arrResponse.count == 0) return;
    
    NSString* strToSortBy = @"id";
    NSArray* arraySorted = [arrResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString* s1 = [obj1 objectForKey:strToSortBy];
        NSString* s2 = [obj2 objectForKey:strToSortBy];
        
        long long lStr1 = [s1 longLongValue];
        long long lStr2 = [s2 longLongValue];
        
        NSComparisonResult result;
        
        if (lStr1 < lStr2) result = NSOrderedDescending;
        else if (lStr1 == lStr2) result = NSOrderedSame;
        else if (lStr1 >	 lStr2) result = NSOrderedAscending;
        
        return result;
    }];

    [m_arrayData removeAllObjects];

    if (!bLoad)
    {
        [m_arrayResult removeAllObjects];
        [self.m_tableView reloadData];
    }
    
    for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
    {
        NSDictionary* dictInfo = [arraySorted objectAtIndex:nIdx];
        NotificationEntity* notificationEntity = [[NotificationEntity alloc] initWithDictInfo:dictInfo];;

        [m_arrayData addObject:notificationEntity];
    }

    if (!bLoad)
    {
        lBeforeId = ((NotificationEntity *)[m_arrayData lastObject]).m_nID;
        lSinceId = ((NotificationEntity *)[m_arrayData firstObject]).m_nID;
        
        bLoad = true;
        
        [self insertRowAtBottom];
    }
    else
    {
        if (bDirectionMode)
        {
            [self insertRowAtTop];
            lSinceId = ((NotificationEntity *)[m_arrayData firstObject]).m_nID;
        }
        else
        {
            [self insertRowAtBottom];
            lBeforeId = ((NotificationEntity *)[m_arrayData lastObject]).m_nID;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];

    [self.m_tableView.pullToRefreshView stopAnimating];
    [self.m_tableView.infiniteScrollingView stopAnimating];

    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
