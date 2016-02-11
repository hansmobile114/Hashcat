//
//  UserListViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/4/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "UserListViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "UserProfileViewController.h"
#import "CatProfileViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController
@synthesize m_arrayResult;
@synthesize m_bViewMode;
@synthesize m_arrayData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.m_bViewMode)
        self.navigationItem.title = [[[NSLocalizedString(@"followers_or_following_title_following", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"followers_or_following_title_following", nil) substringFromIndex:1]];
    else
        self.navigationItem.title = [[[NSLocalizedString(@"followers_or_following_title_followers", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"followers_or_following_title_followers", nil) substringFromIndex:1]];

    arrayViews = [[NSMutableArray alloc] init];
    m_arrayResult = [[NSMutableArray alloc] init];
    m_arrayData = [[NSMutableArray alloc] init];
    
    lBeforeId = 0;
    lSinceId = 0;

    __weak UserListViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.m_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadAboveMore];
    }];
    
    // setup infinite scrolling
    [self.m_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBelowMore];
    }];

    self.m_scrollView.delegate = self;
    
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    FAKFontAwesome *naviBackIcon = [FAKFontAwesome arrowLeftIconWithSize:NAVI_ICON_SIZE];
    [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imgButton = [naviBackIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item0.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
    self.navigationItem.leftBarButtonItems = @[item0, item1];
    
    bLoad = false;
    nPreLoadedCount = -1;
    fScrollHeight = 0.f;
    
    bDirectionMode = false;
    lBeforeId = 0;
    lSinceId = 0;
    
    if (!g_Delegate.m_bHasBottomBar)
        self.m_tableView.frame = CGRectMake(self.m_tableView.frame.origin.x, self.m_tableView.frame.origin.y, self.m_tableView.frame.size.width, self.m_tableView.frame.size.height + MENU_TAB_HEIGHT);

    [self getFollowingRequest];
}

- (void)insertRowAtTop {
    __weak UserListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = 0; nIdx < weakSelf.m_arrayData.count; nIdx++)
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
    __weak UserListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        for (int nIdx = weakSelf.m_arrayData.count - 1; nIdx >= 0; nIdx--)
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

- (void) loadAboveMore
{
    bDirectionMode = true;
    
    [self getFollowingRequest];
}

- (void) loadBelowMore
{
    bDirectionMode = false;
    
    [self getFollowingRequest];
}

- (void) getFollowingRequest
{
    [self showLoadingView];
    
    nRequestMode = GET_FOLLOWING_REQUEST;
    
    if (self.m_bViewMode)
    {
        if (!bLoad)
            [FeedService following:self.m_nId withSinceId:0 beforeId:0 withDelegate:self];
        else
        {
            if (bDirectionMode)
                [FeedService following:self.m_nId withSinceId:lSinceId beforeId:0 withDelegate:self];
            else
                [FeedService following:self.m_nId withSinceId:0 beforeId:lBeforeId withDelegate:self];
        }

    }
    else
    {
        if (!bLoad)
            [FeedService followers:self.m_nId withSinceId:0 beforeId:0 withDelegate:self];
        else
        {
            if (bDirectionMode)
                [FeedService followers:self.m_nId withSinceId:lSinceId beforeId:0 withDelegate:self];
            else
                [FeedService followers:self.m_nId withSinceId:0 beforeId:lBeforeId withDelegate:self];
        }
    }
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

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self.navigationController navigationBar] setBarTintColor:NAVI_COLOR];
    self.navigationController.navigationBar.translucent = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) actionViewProfile:(SearchProfileView *) searchProfileView index:(int) nSelectedIndex
{
    FollowEntity* entity = [m_arrayResult objectAtIndex:nSelectedIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];

    if (self.m_bViewMode)
    {
        ProfileEntity* profile = entity.m_profile;
        
        CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
        
        viewCon.m_nProfileId = profile.m_nId;
        viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:profile.m_strUsername];
        viewCon.m_strProfileUsername = profile.m_strUsername;
        viewCon.m_profileEntity = profile;
        
        [self.navigationController pushViewController:viewCon animated:YES];

    }
    else
    {
        UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
        viewCon.m_bMyProfile = false;
        viewCon.m_nUserId = entity.m_user.m_nID;
        
        [self.navigationController pushViewController:viewCon animated:YES];

    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) actionClickAdd:(SearchProfileView *)searchProfileView index:(int)nSelectedIndex
{
    NSLog(@"clicked add button");

    
//    curSelectedSearchView = (SearchProfileView *)[arrayViews objectAtIndex:nSelectedIndex];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:nSelectedIndex inSection:0];
    curSelectedSearchView = (SearchProfileView *)[self.m_tableView cellForRowAtIndexPath:selectedIndexPath];
    
    bSelectedFollowed = searchProfileView.m_bFollowed;
    nSelectedFollowIdx = nSelectedIndex;
    
    FollowEntity* entity = [m_arrayResult objectAtIndex:nSelectedIndex];

    ProfileEntity* profile = entity.m_profile;
    
    //check whether this photo is current user's
    if ([[Utils sharedObject] checkMyProfileIdWithProfileInfo:profile])
    {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hub.mode = MBProgressHUDModeText;
        hub.labelText = NSLocalizedString(@"feed_toast_already_follow", nil);
        hub.margin = 10.f;
        hub.removeFromSuperViewOnHide = YES;
        
        [hub hide:YES afterDelay:1];
        
        return;
    }
    
    [self showLoadingView];
    
    nRequestMode = FOLLOW_REQUEST;
    
    [FeedService followCat:profile.m_nId withDelegate:self];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrayResult.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.m_bViewMode)
        return 80.f;
    else
        return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customcell";
    
    SearchProfileView *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchProfileView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.m_imageView.image = [UIImage imageNamed:@"avatar_add_profile.png"];
    cell.delegate = self;
    cell.m_nIndex = (int)indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.m_bViewMode)
    {
        FollowEntity* followEntity = [m_arrayResult objectAtIndex:indexPath.row];
        
        ProfileEntity* profile = followEntity.m_profile;
        
        cell.m_lblName.text = profile.m_strUsername;
        cell.m_lblUserName.text = profile.m_strName;
        
        cell.m_bFollowed = false;
        
        for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
        {
            FollowEntity* followEntityOfCurrentUser = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
            
            //load image=================================
            NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
            [[Utils sharedObject] loadImageFromServerAndLocal:strPhoto imageView:cell.m_imageView];
            //=======================================
            
            if (followEntityOfCurrentUser.m_profile.m_nId == profile.m_nId)
            {
                cell.m_bFollowed = true;
                cell.m_nFollowIndex = nIdx;
                
                [cell.m_btnAdd setImage:[UIImage imageNamed:@"btn_added.png"] forState:UIControlStateNormal];
                
                break;
            }
        }
    }
    else
    {
        FollowEntity* followEntity = [m_arrayResult objectAtIndex:indexPath.row];
        cell.m_lblName.hidden = NO;
        cell.m_lblUserName.hidden = YES;
        cell.m_btnAdd.hidden = YES;
        cell.m_lblName.center = CGPointMake(cell.m_lblName.center.x, cell.m_imageView.center.y);
        
        cell.m_lblName.font = [UIFont fontWithName:MAIN_FONT_NAME size:18.f];
        
        cell.m_lblName.text = followEntity.m_user.m_strUsername;
        //load image=================================
        NSString* strPhoto = followEntity.m_user.m_strAvatarUrl;
        [[Utils sharedObject] loadImageFromServerAndLocal:strPhoto imageView:cell.m_imageView];
        //=======================================
        
        cell.m_lblName.center = CGPointMake(cell.m_lblName.center.x, 30.f);
        cell.m_imageView.center = CGPointMake(cell.m_imageView.center.x, 30.f);
        
    }

    if (self.m_bViewMode)
        cell.m_viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, 74.f);
    else
        cell.m_viewContainer.frame = CGRectMake(3, 3, self.m_tableView.frame.size.width - 6.f, 54.f);
    
    cell.m_viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    cell.m_viewContainer.layer.borderWidth = 1.f;
    cell.m_viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:cell.m_viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [self.m_tableView.pullToRefreshView stopAnimating];
    [self.m_tableView.infiniteScrollingView stopAnimating];
    
    NSString *receivedData = [request responseString];
    if ([receivedData isEqualToString:@"null"])
    {
        if (nRequestMode == FOLLOW_REQUEST && bSelectedFollowed)
        {
            curSelectedSearchView.m_bFollowed = false;
            [curSelectedSearchView.m_btnAdd setImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
            
            [g_Delegate.m_currentUser.m_arrFollowings removeObjectAtIndex:curSelectedSearchView.m_nFollowIndex];
            return;
        }
    }
    if (nRequestMode == FOLLOW_REQUEST && !bSelectedFollowed)
    {
        NSDictionary *dictResponse = [receivedData JSONValue];
        if (dictResponse == nil)
        {
            [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
            return;
        }
        
        curSelectedSearchView.m_bFollowed = true;
        [curSelectedSearchView.m_btnAdd setImage:[UIImage imageNamed:@"btn_added.png"] forState:UIControlStateNormal];
        
        FollowEntity* newFollowEntity = [[FollowEntity alloc] initWithDictInfo:dictResponse];
        [g_Delegate.m_currentUser.m_arrFollowings addObject:newFollowEntity];
        
        curSelectedSearchView.m_nFollowIndex = (int)g_Delegate.m_currentUser.m_arrFollowings.count - 1;
        return;
    }

    if (nRequestMode == GET_FOLLOWING_REQUEST)
    {
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
        
        if (nPreLoadedCount == -1)
        {
            [m_arrayResult removeAllObjects];
        }
        
        NSMutableArray* arrTemp = [[NSMutableArray alloc] init];
        for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
        {
            NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
            
            FollowEntity* followEntity = [[FollowEntity alloc] initWithDictInfo:dictOne];
            [arrTemp addObject:followEntity];
        }

        [m_arrayData removeAllObjects];

        if (!bLoad)
        {
            [m_arrayData addObjectsFromArray:arrTemp];
            
            lBeforeId = ((FollowEntity *)[arrTemp lastObject]).m_nID;
            lSinceId = ((FollowEntity *)[arrTemp firstObject]).m_nID;
            
            bLoad = true;
            
            [self insertRowAtBottom];
        }
        else
        {
            if (bDirectionMode)
            {
                nPreLoadedCount = -1;
                
                lSinceId = ((FollowEntity *)[arrTemp firstObject]).m_nID;
                for (int nIdx = (int)arrTemp.count - 1; nIdx >= 0 ; nIdx--)
                {
                    FollowEntity* followEntity = [arrTemp objectAtIndex:nIdx];
                    [m_arrayData insertObject:followEntity atIndex:0];
                }
                
                [self insertRowAtTop];
            }
            else
            {
                [m_arrayData addObjectsFromArray:arrTemp];
                
                lBeforeId = ((FollowEntity *)[arrTemp lastObject]).m_nID;
                
                [self insertRowAtBottom];
            }
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

@end
