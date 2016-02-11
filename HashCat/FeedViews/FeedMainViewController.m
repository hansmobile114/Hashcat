//
//  FeedMainViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FeedMainViewController.h"
#import "Global.h"
#import "MenuTabViewController.h"
#import "FeedService.h"
#import "GameService.h"
#import "CommentViewController.h"
#import "CatProfileViewController.h"
#import "FeedSearchViewController.h"
#import "SuggestionsViewController.h"
#import "BadgeListViewController.h"
#import "SettingViewController.h"
#import "ConnectFacebookViewController.h"
#import "HelpViewController.h"
#import "LikeUsersViewController.h"

#define ACTION_VIEW_HEIGHT      32
#define TOP_INFO_HEIGHT         45
#define BOTTOM_VIEW_HEIGHT      77

@interface FeedMainViewController ()

@end

@implementation FeedMainViewController
@synthesize m_arrayResult;
@synthesize m_arrayViews;
@synthesize m_arrayData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"HashCat";
    [self makeCustomNavigationBar];
    
    FAKFontAwesome *naviInfoIcon = [FAKFontAwesome ellipsisVIconWithSize:NAVI_ICON_SIZE];
    [naviInfoIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    UIImage *imgOption = [naviInfoIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil
                              action:nil];
    item3.width = NAVI_BUTTON_OFFSET;
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_setting_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    self.navigationItem.rightBarButtonItems = @[item3, item4];

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
    
    m_arrayResult = [[NSMutableArray alloc] init];
    m_arrayData = [[NSMutableArray alloc] init];
    m_arrayViews = [[NSMutableArray alloc] init];
    
    nCurViewMode = 0;
    
    lBeforeId = 0;
    lSinceId = 0;

    self.m_scrollView.delegate = self;
    
    if (self.m_lPhotoId == -1)
    {
        __weak FeedMainViewController *weakSelf = self;
        
        // setup pull-to-refresh
        [self.m_tableView addPullToRefreshWithActionHandler:^{
            [weakSelf loadAboveMore];
        }];
        
        // setup infinite scrolling
        [self.m_tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadBelowMore];
        }];
    }
    
    if (!g_Delegate.m_bHasBottomBar)
        self.m_tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    
    self.m_tableView.tableFooterView = [[UIView alloc] init];
    self.m_tableView.separatorColor = [UIColor clearColor];

    [self.m_tableView reloadData];
    
    bLoad = false;
    nPreLoadedCount = -1;
    fScrollHeight = 0.f;
    
    bDirectionMode = false;
    lBeforeId = 0;
    lSinceId = 0;
    
    fScrollCurPos = 0;

    [self getFeedRequest];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    fScrollCurPos = scrollView.contentOffset.y;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (!g_Delegate.m_curMenuTabViewCon)
        return;
    
    if (fScrollCurPos < (int)scrollView.contentOffset.y) {
        self.m_tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        g_Delegate.m_bHasBottomBar = false;
        [g_Delegate.m_curMenuTabViewCon hideMenuTabView];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    else if (fScrollCurPos > (int)scrollView.contentOffset.y) {
        self.m_tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - MENU_TAB_HEIGHT);
        g_Delegate.m_bHasBottomBar = true;
        [g_Delegate.m_curMenuTabViewCon showMenuTabView];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)insertRowAtTop {
    __weak FeedMainViewController *weakSelf = self;
    
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
    __weak FeedMainViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = weakSelf.m_arrayData.count - 1; nIdx >= 0; nIdx--)
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
    
    [self getFeedRequest];
}

- (void) loadBelowMore
{
    bDirectionMode = false;
    
    [self getFeedRequest];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    self.navigationController.navigationBar.translucent = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) getFeedRequest
{
    [self showLoadingView];
    
    nRequestMode = GET_FEED_REQUEST;
    
    if (!bLoad)
        [FeedService getFeedWithPhotoId:self.m_lPhotoId withSinceId:0 beforeId:0 withDelegate:self];
    else
    {
        if (bDirectionMode)
            [FeedService getFeedWithPhotoId:self.m_lPhotoId withSinceId:lSinceId beforeId:0 withDelegate:self];
        else
            [FeedService getFeedWithPhotoId:self.m_lPhotoId withSinceId:0 beforeId:lBeforeId withDelegate:self];
    }
}

- (void) backToMainView
{
    if (self.m_bFirstView)
        [g_Delegate.m_curMenuTabViewCon.navigationController popViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
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

- (void) showSettings
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:NSLocalizedString(@"settings_find_friends", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:0],
      [KxMenuItem menuItem:NSLocalizedString(@"settings_badges", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:1],
      [KxMenuItem menuItem:NSLocalizedString(@"facebook_connect", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:2],
      [KxMenuItem menuItem:NSLocalizedString(@"share_title", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:3],
      [KxMenuItem menuItem:NSLocalizedString(@"settings_settings", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:4],
      [KxMenuItem menuItem:NSLocalizedString(@"settings_help", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:5],
      [KxMenuItem menuItem:NSLocalizedString(@"settings_logout", nil)
                     image:nil
                    target:self
                    action:@selector(toggleViewMode:)
                       tag:6]
      ];
    
    KxMenuItem *first = menuItems[nCurViewMode];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentLeft;
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(self.view.frame.size.width - 30.f, -20.f, 24, 24)
                 menuItems:menuItems];
}

- (void) toggleViewMode:(id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    nCurViewMode = ((KxMenuItem *)sender).m_nTag;
    if (nCurViewMode == 0)
    {
        SuggestionsViewController*viewCon = [storyboard instantiateViewControllerWithIdentifier:@"suggestionsview"];
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else if (nCurViewMode == 1)
    {
        BadgeListViewController*viewCon = [storyboard instantiateViewControllerWithIdentifier:@"badgelistview"];
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else if (nCurViewMode == 2)
    {
        //facebook connect
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
        
        ConnectFacebookViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"facebookview"];
        
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else if (nCurViewMode == 3)
    {
        //spread the meow!
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[NSLocalizedString(@"share_message", nil), [UIImage imageNamed:@"hashcat_logo.png"]]
         applicationActivities:nil];
        
        [self presentViewController:activityController animated:YES completion:nil];
    }
    else if (nCurViewMode == 4)
    {
        SettingViewController*viewCon = [storyboard instantiateViewControllerWithIdentifier:@"settingview"];
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else if (nCurViewMode == 5)
    {
        //help
        HelpViewController* helpViewCon = [storyboard instantiateViewControllerWithIdentifier:@"helpview"];
        helpViewCon.m_nHelpMode = HELP_TOTAL;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:helpViewCon animated:YES completion:nil];
        });

    }
    else
    {
        [self logout];
    }
}

- (void) logout
{
    [[FacebookUtility sharedObject]logoutFromFacebook];
    [[UserDefaultHelper sharedObject] setFacebookLoginRequest:nil];
    
    [g_Delegate.m_curMenuTabViewCon.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeCustomNavigationBar
{
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(60, 0, self.view.bounds.size.width - 120, 44)];
    UIImage *markImage = [UIImage imageNamed:@"logo.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:markImage];
    myImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    float fTitleImageWidth = 180.f;//120.f
    myImageView.frame = CGRectMake(myView.frame.size.width / 2 - fTitleImageWidth / 2, 4, fTitleImageWidth, 36);
    myImageView.backgroundColor = [UIColor clearColor];
    
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) addTagListView:(UIView *)parentView itemNames:(NSMutableArray *) arrTags
{
    if (arrTags.count == 0)
        return;
    
    DWTagList *_tagList = [[DWTagList alloc] initWithFrame:CGRectMake(0.f, (parentView.frame.size.height  - 30.f) / 2, parentView.frame.size.width, 30.f)];
    [_tagList setAutomaticResize:NO];
    [_tagList setTags:arrTags];
    [_tagList setTagDelegate:self];
    
    // Customisation
    [_tagList setCornerRadius:4.0f];
    [_tagList setBorderColor:[UIColor clearColor]];
    [_tagList setBorderWidth:.0f];
    
    [parentView addSubview:_tagList];
}

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    NSRange range;
    range.location = 1; range.length = tagName.length - 1;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    FeedSearchViewController *searchViewCon = [storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    searchViewCon.m_strSearchText = [tagName substringWithRange:range];
    searchViewCon.bHashtagMode = true;
    MenuTabViewController* parentView = (MenuTabViewController *)self.navigationController.parentViewController;
    [parentView goIndicatorToSearch];
    
    [self.navigationController pushViewController:searchViewCon animated:YES];
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
    float fTableViewWidth = [[UIScreen mainScreen] bounds].size.width - 6.f;
    
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:indexPath.row];

    float fPostTextHeight = [[Utils sharedObject] getHeightOfText:photoEntity.m_strDescription fontSize:18 width:self.m_tableView.frame.size.width - 16.f] + 20.f;

    return TOP_INFO_HEIGHT + fTableViewWidth + ACTION_VIEW_HEIGHT + fPostTextHeight + BOTTOM_VIEW_HEIGHT + 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customcell";
    
    PostSubView *cell = [tableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostSubView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    float fTableViewWidth = [[UIScreen mainScreen] bounds].size.width - 6.f;

    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:indexPath.row];

    float fPostTextHeight = [[Utils sharedObject] getHeightOfText:photoEntity.m_strDescription fontSize:18 width:self.m_tableView.frame.size.width - 16.f] + 20.f;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.delegate = self;
    cell.m_nIndex = (int)indexPath.row;
    cell.m_userImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    cell.m_postImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    cell.m_lblUserName.text = photoEntity.m_profile.m_strUsername;
    cell.m_postImageView.clipsToBounds = YES;
    
    cell.m_lblPostText.text = photoEntity.m_strDescription;

    cell.m_postImageView.frame = CGRectMake(cell.m_postImageView.frame.origin.x, TOP_INFO_HEIGHT, fTableViewWidth, fTableViewWidth);
    cell.m_viewAction.frame = CGRectMake(cell.m_viewAction.frame.origin.x, fTableViewWidth + TOP_INFO_HEIGHT, fTableViewWidth, ACTION_VIEW_HEIGHT);
    cell.m_lblPostText.frame = CGRectMake(10, fTableViewWidth + ACTION_VIEW_HEIGHT + TOP_INFO_HEIGHT, fTableViewWidth - 2.f, fPostTextHeight);
    cell.m_viewBottomPart.frame = CGRectMake(cell.m_viewBottomPart.frame.origin.x, fTableViewWidth + TOP_INFO_HEIGHT + ACTION_VIEW_HEIGHT + fPostTextHeight, fTableViewWidth, BOTTOM_VIEW_HEIGHT);
    
    NSMutableArray* arrTags = [[NSMutableArray alloc] init];
    for (int nCatgIdx = 0; nCatgIdx < photoEntity.m_arrCategories.count; nCatgIdx++)
    {
        CategoriesEntity* categoriesEntity = [photoEntity.m_arrCategories objectAtIndex:nCatgIdx];
        if (categoriesEntity.m_category.m_bSelectable)
            [arrTags addObject:[NSString stringWithFormat:@"#%@", categoriesEntity.m_category.m_strName]];
    }
    [self addTagListView:cell.m_viewCategory itemNames:arrTags];
    
    [cell.m_btnLikeB setTitle:[NSString stringWithFormat:@"%d %@", photoEntity.m_nLikeCnt, NSLocalizedString(@"badge_type_likes", nil)] forState:UIControlStateNormal];
    [cell.m_btnCommentB setTitle:[NSString stringWithFormat:@"%d %@", photoEntity.m_nCommentsCount, NSLocalizedString(@"feed_label_comments", nil)] forState:UIControlStateNormal];
    cell.m_lblTime.text = [[Utils sharedObject] DateToString:[[Utils sharedObject] getDateFromMilliSec:photoEntity.m_nDate] withFormat:@"MMM dd"];
    
    [cell.m_lblTime sizeToFit];
    cell.m_lblTime.center = CGPointMake(fTableViewWidth - 5.f - cell.m_lblTime.frame.size.width / 2, cell.m_userImageView.center.y);
    cell.m_imgClock.center = CGPointMake(cell.m_lblTime.frame.origin.x - 5.f - cell.m_imgClock.frame.size.width / 2, cell.m_userImageView.center.y);
    
    if (photoEntity.m_bUserAlreadyLikes)
    {
        cell.m_btnLikeImage.highlighted = YES;
    }
    else
    {
        cell.m_btnLikeImage.highlighted = NO;
    }
    
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntity.m_profile.m_strCaminhoThumbnailLink imageView:cell.m_userImageView];
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntity.m_strPhotoLink imageView:cell.m_postImageView];
    
    float fTableHeight = TOP_INFO_HEIGHT + fTableViewWidth + ACTION_VIEW_HEIGHT + fPostTextHeight + BOTTOM_VIEW_HEIGHT;

    cell.mn_viewContainer.frame = CGRectMake(3, 3, fTableViewWidth, fTableHeight);
    
    cell.mn_viewContainer.layer.borderColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1.f].CGColor;
    cell.mn_viewContainer.layer.borderWidth = 1.f;
    cell.mn_viewContainer.clipsToBounds = YES;
    
    [[Utils sharedObject] makeShadowEffect:cell.mn_viewContainer radius:3.f color:BOX_SHADOW_COLOR corner:0.f];
    
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
    
    if (nRequestMode == GET_FEED_REQUEST)
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
        
        /*
        if (nPreLoadedCount == -1)
        {
            [m_arrayResult removeAllObjects];
        }
         */
        
        NSMutableArray* arrTemp = [[NSMutableArray alloc] init];
        for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
        {
            NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
            PhotoEntity* photoEntity = [[PhotoEntity alloc] initWithDictInfo:dictOne];
            [arrTemp addObject:photoEntity];
        }

        NSMutableArray* arrFeedOrder = [[NSMutableArray alloc] init];
        for (int nIdx = arrResponse.count - 1; nIdx >= 0 ; nIdx--)
        {
            NSDictionary* dictOne = [arrResponse objectAtIndex:nIdx];
            PhotoEntity* photoEntity = [[PhotoEntity alloc] initWithDictInfo:dictOne];
            [arrFeedOrder addObject:photoEntity];
        }
        
        [m_arrayData removeAllObjects];
        
        if (!bLoad)
        {
            [m_arrayData addObjectsFromArray:arrFeedOrder];
            
            lBeforeId = ((PhotoEntity *)[arrTemp lastObject]).m_nID;
            lSinceId = ((PhotoEntity *)[arrTemp firstObject]).m_nID;
            
            bLoad = true;
            
            [self insertRowAtBottom];
        }
        else
        {
            if (bDirectionMode)
            {
                nPreLoadedCount = -1;
                lSinceId = ((PhotoEntity *)[arrTemp firstObject]).m_nID;
                for (int nIdx = (int)arrFeedOrder.count - 1; nIdx >= 0 ; nIdx--)
                {
                    PhotoEntity* photoEntity = [arrFeedOrder objectAtIndex:nIdx];
                    [m_arrayData insertObject:photoEntity atIndex:0];
                }
                
                [self insertRowAtTop];
            }
            else
            {
                [m_arrayData addObjectsFromArray:arrFeedOrder];
                lBeforeId = ((PhotoEntity *)[arrTemp lastObject]).m_nID;
                
                [self insertRowAtBottom];
            }
        }
    }
    else if (nRequestMode == LIKE_REQUEST)
    {
        int nLikePlus = 0;
        
        if ([receivedData isEqualToString:@"true"])
        {
            nLikePlus = 1;
        }
        else
        {
            nLikePlus = -1;
        }
        
        NSIndexPath* selectedIndexPath = [NSIndexPath indexPathForRow:nSelectedLikePhotoId inSection:0];
        PostSubView* subView = (PostSubView *)[self.m_tableView cellForRowAtIndexPath:selectedIndexPath];
        //(PostSubView *)[m_arrayViews objectAtIndex:nSelectedLikePhotoId];
        PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nSelectedLikePhotoId];
        
        if (nLikePlus == 1)
        {
            subView.m_btnLikeImage.highlighted = YES;
        }
        else if (nLikePlus == -1)
        {
            subView.m_btnLikeImage.highlighted = NO;
        }

        int nFinalLike = photoEntity.m_nLikeCnt + nLikePlus;
        if (nFinalLike < 0) nFinalLike = 0;
        photoEntity.m_nLikeCnt = nFinalLike;
        [m_arrayResult replaceObjectAtIndex:nSelectedLikePhotoId withObject:photoEntity];
        
        [subView.m_btnLikeB setTitle:[NSString stringWithFormat:@"%i %@", nFinalLike, NSLocalizedString(@"badge_type_likes", nil)] forState:UIControlStateNormal];
    }
    else if (nRequestMode == REPORT_REQUEST)
    {
        if ([receivedData isEqualToString:@"true"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feed_dialog_title_reported", nil) message:NSLocalizedString(@"feed_dialog_content_reported", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"continue_string", nil) otherButtonTitles:nil];
            alertView.tag = 999;
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"comment_dialog_title_not_reported", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"continue_string", nil) otherButtonTitles:nil];
            alertView.tag = 999;
            [alertView show];
        }
    }
    else if (nRequestMode == REMOVE_PHOTO_REQUEST)
    {
        if ([receivedData isEqualToString:@"true"])
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feed_photo_removed", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"continue_string", nil), nil];
            alertView.tag = 999;
            
            [alertView show];

            [m_arrayResult removeObjectAtIndex:nSelectedReportPhotId];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nSelectedReportPhotId inSection:0];
            [self.m_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feed_dialog_title_error_remove_photo", nil) message:NSLocalizedString(@"feed_dialog_content_error_remove_photo", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"continue_string", nil), nil];
            alertView.tag = 999;
            
            [alertView show];
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

- (void) actionViewProfile:(PostSubView *) subView withIndex:(int) nIndex
{
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nIndex];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    viewCon.m_nProfileId = photoEntity.m_profile.m_nId;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileId:photoEntity];
    viewCon.m_strProfileUsername = photoEntity.m_profile.m_strUsername;
    viewCon.m_profileEntity = photoEntity.m_profile;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) actionClickLike:(PostSubView *) subView withIndex:(int) nIndex
{
    nSelectedLikePhotoId = nIndex;
    
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nIndex];
    
    //check whether this photo is current user's
    if ([[Utils sharedObject] checkMyProfileId:photoEntity])
    {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Configure for text only and offset down
        hub.mode = MBProgressHUDModeText;
        hub.labelText = NSLocalizedString(@"feed_toast_already_liked", nil);
        hub.margin = 10.f;
        hub.removeFromSuperViewOnHide = YES;
        
        [hub hide:YES afterDelay:1];

        return;
    }
    
    [self showLoadingView];
    
    nRequestMode = LIKE_REQUEST;
    [FeedService likePhoto:photoEntity.m_nID withDelegate:self];
}

- (void) actionClickLikeUsers:(PostSubView *)subView withIndex:(int)nIndex
{
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    LikeUsersViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"likeuserview"];
    viewCon.m_nId = photoEntity.m_nID;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) actionClickComment:(PostSubView *) subView withIndex:(int) nIndex
{
    MenuTabViewController* parentView = (MenuTabViewController *)self.navigationController.parentViewController;
    [parentView hideMenuTabView];
    
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nIndex];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CommentViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"commentview"];
    viewCon.m_nPhotoId = photoEntity.m_nID;
    viewCon.m_photoEntity = photoEntity;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) actionClickReport:(PostSubView *) subView withIndex:(int) nIndex
{
    nSelectedReportPhotId = nIndex;
    
    PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nIndex];

    //check if it is user's profile
    bool bUserPhoto = false;
    
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrProfiles.count; nIdx++)
    {
        ProfileEntity* profile = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nIdx];

        if ([profile.m_strUsername isEqualToString:photoEntity.m_profile.m_strUsername])
        {
            bUserPhoto = true;
            break;
        }
    }
    
    if (bUserPhoto)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:photoEntity.m_profile.m_strUsername message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"feed_remove_photo", nil), NSLocalizedString(@"feed_dialog_title_report_photo", nil), nil];
        alertView.tag = 200;
        
        [alertView show];

    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"user_dialog_title_report_user", nil) message:NSLocalizedString(@"user_dialog_content_report", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        alertView.tag = 100;
        [alertView show];
    }
}

- (void) actionClickHashTag:(PostSubView *) subView withString:(NSString *) strHashTag
{
    NSRange range;
    range.location = 1; range.length = strHashTag.length - 1;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    FeedSearchViewController *searchViewCon = [storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    searchViewCon.m_strSearchText = [strHashTag substringWithRange:range];
    
    MenuTabViewController* parentView = (MenuTabViewController *)self.navigationController.parentViewController;
    [parentView goIndicatorToSearch];

    [self.navigationController pushViewController:searchViewCon animated:YES];
}

- (void) actionClickUserName:(PostSubView *) subView withString:(NSString *) strUsername
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];

    NSRange range;
    range.location = 1; range.length = strUsername.length - 1;

    viewCon.m_nProfileId = -1;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:strUsername];
    
    viewCon.m_strProfileUsername = [strUsername substringWithRange:range];
    viewCon.m_profileEntity = nil;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nSelectedReportPhotId];
            
            [self showLoadingView];
            
            nRequestMode = REPORT_REQUEST;
            [GameService reportPhoto:photoEntity.m_nID withDelegate:self];
        }
    }
    
    if (alertView.tag == 200)
    {
        if (buttonIndex == 1)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feed_dialog_title_remove_photo", nil) message:NSLocalizedString(@"feed_dialog_content_remove_photo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
            alertView.tag = 300;
            [alertView show];

        }
        
        if (buttonIndex == 2)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"user_dialog_title_report_user", nil) message:NSLocalizedString(@"user_dialog_content_report", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
            alertView.tag = 100;
            [alertView show];

        }
    }
    
    if (alertView.tag == 300)
    {
        if (buttonIndex == 1)
        {
            PhotoEntity* photoEntity = [m_arrayResult objectAtIndex:nSelectedReportPhotId];
            NSDictionary * dictSessionInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
            NSString* strPassword = @"";
            if ([[dictSessionInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
                strPassword = [dictSessionInfo valueForKey:@"userpassword"];
            else
                strPassword = [dictSessionInfo valueForKey:@"password"];

            nRequestMode = REMOVE_PHOTO_REQUEST;
            
            [self showLoadingView];
            [FeedService removePhoto:photoEntity.m_nID withPassword:strPassword withDelegate:self];
        }
    }
}

@end
