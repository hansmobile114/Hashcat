//
//  SuggestionsViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "SuggestionsViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "CatProfileViewController.h"

@interface SuggestionsViewController ()

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"suggestions", nil);
    
    arrayBadgeViews = [[NSMutableArray alloc] init];
    arrayBadges = [[NSMutableArray alloc] init];

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

    if (!g_Delegate.m_bHasBottomBar)
        self.m_viewBottomPart.frame = CGRectMake(self.m_viewBottomPart.frame.origin.x, self.m_viewBottomPart.frame.origin.y, self.m_viewBottomPart.frame.size.width, self.m_viewBottomPart.frame.size.height + MENU_TAB_HEIGHT);
    
    self.m_viewBottomPart.layer.cornerRadius = 2.f;
    self.m_viewBottomPart.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_viewBottomPart.layer.borderWidth = 1.f;
    self.m_viewBottomPart.clipsToBounds = YES;
    
    [[Utils sharedObject] makeBoxShadowEffect:self.m_viewBottomPart radius:2.f color:CONTAINER_SHADOW_COLOR corner:2.f];

    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    [self showLoadingView];
    [FeedService suggestionsWithDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionFollowAll:(id)sender {
    if (arrayBadges.count == 0)
        return;
    
    [self showLoadingView];
    
    nRequestMode = FOLLOW_ALL_REQUEST;
    [FeedService followAllWithDelegate:self];
}

- (IBAction)actionContinue:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayBadges.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
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
    
    ProfileEntity* profile = [arrayBadges objectAtIndex:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.m_imageView.image = [UIImage imageNamed:@"avatar_add_profile.png"];
    cell.delegate = self;
    cell.m_nIndex = (int)indexPath.row;
    cell.m_lblName.text = profile.m_strUsername;
    cell.m_lblUserName.text = profile.m_strName;
    
    cell.m_bFollowed = false;
    
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
    {
        FollowEntity* followEntity = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
        if (followEntity.m_profile.m_nId == profile.m_nId)
        {
            cell.m_bFollowed = true;
            cell.m_nFollowIndex = nIdx;
            
            [cell.m_btnAdd setImage:[UIImage imageNamed:@"btn_added.png"] forState:UIControlStateNormal];
            
            break;
        }
    }
    
    cell.m_viewContainer.frame = CGRectMake(3, 3, self.m_viewBottomPart.frame.size.width - 6.f, 74.f);
    
    cell.m_viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    cell.m_viewContainer.layer.borderWidth = 1.f;
    cell.m_viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:cell.m_viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];
    
    //load image=================================
    NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
    [[Utils sharedObject] loadImageFromServerAndLocal:strPhoto imageView:cell.m_imageView];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) loadBagdes
{
    CGFloat viewWidth = CGRectGetWidth(self.m_scrollView.frame);
    
    for (int nIdx = 0; nIdx < arrayBadgeViews.count; nIdx++)
    {
        SearchProfileView* subView = (SearchProfileView *)[arrayBadgeViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [arrayBadgeViews removeAllObjects];
    
    float fItemSizeWidth = self.m_scrollView.frame.size.width - 6.f;
    float fItemSizeHeight = 80.f;
    
    int nCatItemIdx = -1;
    int nRowIdx = nCatItemIdx;
    
    for (int nIdx = 0; nIdx < arrayBadges.count; nIdx++)
    {
        ProfileEntity* profile = [arrayBadges objectAtIndex:nIdx];
        
        nCatItemIdx++;
        nRowIdx++;
        
        SearchProfileView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"SearchProfileView" owner:self options:nil] objectAtIndex:0];
        catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
        catSubView.m_imageView.image = [UIImage imageNamed:@"avatar_add_profile.png"];
        catSubView.delegate = self;
        catSubView.m_nIndex = nIdx;
        catSubView.m_lblName.text = profile.m_strUsername;
        catSubView.m_lblUserName.text = profile.m_strName;
        
        catSubView.m_bFollowed = false;
        
        for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
        {
            FollowEntity* followEntity = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
            if (followEntity.m_profile.m_nId == profile.m_nId)
            {
                catSubView.m_bFollowed = true;
                catSubView.m_nFollowIndex = nIdx;
                
                [catSubView.m_btnAdd setImage:[UIImage imageNamed:@"btn_added.png"] forState:UIControlStateNormal];
                
                break;
            }
        }
        
        catSubView.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
        catSubView.layer.borderWidth = 1.f;
        catSubView.clipsToBounds = YES;
        
        catSubView.center = CGPointMake(self.m_scrollView.frame.size.width / 2.f, (nRowIdx + 1) * 3.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
        
        [self.m_scrollView addSubview:catSubView];
        [arrayBadgeViews addObject:catSubView];
        
        //load image=================================
        NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
        [[Utils sharedObject] loadImageFromServerAndLocal:strPhoto imageView:catSubView.m_imageView];
        //=======================================
    }
    
    float fScrollHeight = (nRowIdx + 1) * 3.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + 3.f + fItemSizeHeight / 2.f;
    
    self.m_scrollView.contentSize = CGSizeMake(viewWidth, fScrollHeight);
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    
}

- (void) actionClickAdd:(SearchProfileView *)searchProfileView index:(int)nSelectedIndex
{
    NSLog(@"clicked add button");
    
    NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:nSelectedIndex inSection:0];
    curSelectedSearchView = (SearchProfileView *)[self.m_tableView cellForRowAtIndexPath:selectedIndexPath];
    
    bSelectedFollowed = searchProfileView.m_bFollowed;
    nSelectedFollowIdx = nSelectedIndex;
    
    ProfileEntity* profile = [arrayBadges objectAtIndex:nSelectedFollowIdx];
    
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

- (void) actionViewProfile:(SearchProfileView *) searchProfileView index:(int) nSelectedIndex
{
    ProfileEntity* profile = [arrayBadges objectAtIndex:nSelectedIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    viewCon.m_nProfileId = profile.m_nId;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:profile.m_strUsername];
    viewCon.m_strProfileUsername = profile.m_strUsername;
    viewCon.m_nProfileIndexInUser = (int)index;
    viewCon.m_profileEntity = profile;
    
    [self.navigationController pushViewController:viewCon animated:YES];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    NSString *receivedData = [request responseString];
    if ([receivedData isEqualToString:@"null"])
    {
        if (nRequestMode == FOLLOW_REQUEST && bSelectedFollowed)
        {
            curSelectedSearchView.m_bFollowed = false;
            [curSelectedSearchView.m_btnAdd setImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
            
            [g_Delegate.m_currentUser.m_arrFollowings removeObjectAtIndex:curSelectedSearchView.m_nFollowIndex];
//            [arrayBadgeViews replaceObjectAtIndex:nSelectedFollowIdx withObject:curSelectedSearchView];
            return;
        }
    }
    
    if (nRequestMode == RELOGIN_REQUEST)
    {
        NSDictionary *dictResponse = [receivedData JSONValue];
        if (dictResponse == nil)
        {
            [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
            return;
        }
        
        g_Delegate.m_currentUser = [[UserEntity alloc] initWithDictInfo:dictResponse];
        
        [self backToMainView];
        
        return;
    }

    if (nRequestMode == FOLLOW_ALL_REQUEST)
    {
        if ([receivedData isEqualToString:@"true"])
        {
            NSDictionary * dictSessionInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
            
            nRequestMode = RELOGIN_REQUEST;

            [self showLoadingView];
            
            [FeedService logInWithUsername:[dictSessionInfo valueForKey:@"username"] withPass:[dictSessionInfo valueForKey:@"password"] withPushID:[dictSessionInfo valueForKey:@"pusId"] withModel:DEVICE_MODEL withDelegate:self];
            
            return;
        }
        else
        {
            [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"failed_follow_all_alert_title", nil)];
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
//        [arrayBadgeViews replaceObjectAtIndex:nSelectedFollowIdx withObject:curSelectedSearchView];
        
        return;
    }
    
    NSArray* arrResponse = [receivedData JSONValue];
    
    NSString* strToSortBy = @"id";
    NSArray* arraySorted = [arrResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString* s1 = [obj1 objectForKey:strToSortBy];
        NSString* s2 = [obj2 objectForKey:strToSortBy];
        
        long long lStr1 = [s1 longLongValue];
        long long lStr2 = [s2 longLongValue];
        
        NSComparisonResult result;
        
        if (lStr1 > lStr2) result = NSOrderedDescending;
        else if (lStr1 == lStr2) result = NSOrderedSame;
        else if (lStr1 < lStr2) result = NSOrderedAscending;
        //                {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};
        
        return result;
        //        return [s1 caseInsensitiveCompare:s2];
    }];
    
    [arrayBadges removeAllObjects];
    
    for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
    {
        NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
        ProfileEntity* profileEntity = [[ProfileEntity alloc] initWithDictInfo:dictOne];
        [arrayBadges addObject:profileEntity];
    }
  
    [self.m_tableView reloadData];
//    [self loadBagdes];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}


@end
