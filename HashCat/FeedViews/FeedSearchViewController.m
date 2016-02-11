//
//  FeedSearchViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FeedSearchViewController.h"
#import "Global.h"
#import "MenuTabViewController.h"
#import "Global.h"
#import "SearchService.h"
#import "CatProfileViewController.h"
#import "FeedService.h"
#import "FeedMainViewController.h"

@interface FeedSearchViewController ()

@end

@implementation FeedSearchViewController
@synthesize m_strSearchText;
@synthesize bHashtagMode;
@synthesize arrayData;;
@synthesize tableViewBadges;
@synthesize arrayBadges;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayMainViews = [[NSMutableArray alloc] init];
    arrayBadgeViews = [[NSMutableArray alloc] init];
    arrayPhotoViews = [[NSMutableArray alloc] init];

    arrayBadges = [[NSMutableArray alloc] init];
    arrayPhotos = [[NSMutableArray alloc] init];
    arrayData = [[NSMutableArray alloc] init];
    
    self.m_searchBar.delegate = self;
    self.m_searchBar.tintColor = [UIColor whiteColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:MAIN_FONT_NAME size:14.f]}];
    
    UITextField *textfieldField = [self.m_searchBar valueForKey:@"_searchField"];
    [self.m_searchBar setImage:[UIImage imageNamed:@"ic_search_white_24dp.png"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    UIImage *whatSearchImage = [UIImage imageNamed:@"ic_search_white_24dp.png"];
    UIImageView *whatSearchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    whatSearchView.image = whatSearchImage;
    textfieldField.leftViewMode = UITextFieldViewModeAlways;
    textfieldField.leftView = whatSearchView;
    /*
    [self.m_searchBar setImage:[UIImage imageNamed:@"ic_search_white_24dp.png"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
     */

    self.navigationItem.title = NSLocalizedString(@"search_hint", nil);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

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

    bLoad = true;
    
    bLoadSuggestionPhotos = false;
    bLoadSuggestionProfiles = false;
    
    nPreLoadedCount = -1;
    
    if (m_strSearchText.length > 0)
    {
        lBeforeId = 0;
        
        self.m_searchBar.text = m_strSearchText;
        
        nPreLoadedCount = -1;
        
        bLoadSuggestionPhotos = true;

        [self doSearch];
    }
    else
        [self suggestionSearch];

}

- (void) viewWillAppear:(BOOL)animated
{
    if (bLoad)
    {
        if (!g_Delegate.m_bHasBottomBar)
            self.m_viewPart.frame = CGRectMake(self.m_viewPart.frame.origin.x, self.m_viewPart.frame.origin.y, self.m_viewPart.frame.size.width, self.m_viewPart.frame.size.height + MENU_TAB_HEIGHT);
        
        [self makeBadgeAndPhotoScrollView];
        
        bLoad = false;
    }
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void) backToMainView
{
    if (self.m_bFirstView)
        [g_Delegate.m_curMenuTabViewCon.navigationController popViewControllerAnimated:YES];
    else
    {
        MenuTabViewController* parentView = (MenuTabViewController *)self.navigationController.parentViewController;
        [parentView goIndicatorToHome];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) suggestionSearch
{
    if (!bLoadSuggestionPhotos && m_strSearchText.length == 0)
    {
        [self showLoadingView];
        [FeedService suggestionsBasedOnFriendsLikes:0 beforeId:0 withDelegate:self];
        
        return;
    }

    if (!bLoadSuggestionProfiles && m_strSearchText.length == 0)
    {
        [self showLoadingView];
        [FeedService suggestionsBasedOnFriendsFollows:0 beforeId:0 withDelegate:self];
    }
}

- (void) doSearch
{
    [self showLoadingView];
    if (mainSegmentedControl.selectedSegmentIndex == 0)
    {
        if (!bHashtagMode)
            [SearchService searchHashtags:m_strSearchText beforeId:lBeforeId withDelegate:self];
        else
        {
            [SearchService searchCategory:m_strSearchText beforeId:lBeforeId withDelegate:self];
        }
    }
    else
    {
        [SearchService searchProfiles:m_strSearchText beforeId:lBeforeId withDelegate:self];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.m_searchBar.text = @"";
    self.m_searchBar.showsCancelButton = YES;
    for (UIView *subView in self.m_searchBar.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *cancelButton = (UIButton*)subView;

            [cancelButton setImage:[UIImage imageNamed:@"ic_close_white_24dp.png"] forState:UIControlStateNormal];
        }
        
    }
    
    self.m_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.m_searchBar resignFirstResponder];
    
    //search
    m_strSearchText = self.m_searchBar.text;
    lBeforeId = 0;
    
    bHashtagMode = false;
    nPreLoadedCount = -1;
    [self doSearch];
}

//user finished editing the search text
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.m_searchBar resignFirstResponder];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    [self.m_searchBar resignFirstResponder];
}

//user tapped on the cancel button
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.m_searchBar.showsCancelButton = NO;
    
    [self.m_searchBar resignFirstResponder];
    
    self.m_searchBar.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeBadgeAndPhotoScrollView
{
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
    self.m_viewPart.backgroundColor = [UIColor whiteColor];
    CGFloat fScrollHeight = self.m_viewPart.frame.size.height - 50;
    
    self.m_viewPart.layer.cornerRadius = 2.f;
    self.m_viewPart.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_viewPart.layer.borderWidth = 1.f;
    self.m_viewPart.clipsToBounds = YES;
    
    [[Utils sharedObject] makeBoxShadowEffect:self.m_viewPart radius:2.f color:CONTAINER_SHADOW_COLOR corner:2.f];

    // Tying up the segmented control to a scroll view
    mainSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    mainSegmentedControl.sectionTitles = @[[[[NSLocalizedString(@"photos", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"photos", nil) substringFromIndex:1]], NSLocalizedString(@"profiles", nil)];
    mainSegmentedControl.selectedSegmentIndex = 0;
    mainSegmentedControl.backgroundColor = [UIColor colorWithRed:228.f / 255.f green:228.f / 255.f blue:228.f / 255.f alpha:1];
    mainSegmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    mainSegmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : MAIN_COLOR};
    mainSegmentedControl.selectionIndicatorColor = MAIN_COLOR;
    mainSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    mainSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    mainSegmentedControl.tag = 3;
    
    __weak typeof(self) weakSelf = self;
    [mainSegmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.m_badgeAndPhotoScrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, fScrollHeight) animated:YES];
        
        weakSelf.m_searchBar.text = @"";
        weakSelf.m_strSearchText = @"";
        
        [weakSelf suggestionSearch];
    }];
    
    [self.m_viewPart addSubview:mainSegmentedControl];
    
    self.m_badgeAndPhotoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, fScrollHeight)];
    self.m_badgeAndPhotoScrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.m_badgeAndPhotoScrollView.pagingEnabled = YES;
    self.m_badgeAndPhotoScrollView.showsHorizontalScrollIndicator = NO;
    self.m_badgeAndPhotoScrollView.contentSize = CGSizeMake(viewWidth * 2, fScrollHeight);
    self.m_badgeAndPhotoScrollView.delegate = self;
    [self.m_badgeAndPhotoScrollView scrollRectToVisible:CGRectMake(0, 0, viewWidth, fScrollHeight) animated:NO];
    [self.m_viewPart addSubview:self.m_badgeAndPhotoScrollView];
    
    scrollViewPhotos = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, fScrollHeight)];
    scrollViewPhotos.delegate = self;
    scrollViewPhotos.backgroundColor = [UIColor whiteColor];
    [self.m_badgeAndPhotoScrollView addSubview:scrollViewPhotos];
//    [self loadPhotos];

    /*
    scrollViewBadges = [[UIScrollView alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, fScrollHeight)];
    scrollViewBadges.delegate = self;
    scrollViewBadges.backgroundColor = [UIColor whiteColor];
     */
    tableViewBadges = [[UITableView alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, fScrollHeight)];
    tableViewBadges.backgroundColor = [UIColor whiteColor];

    tableViewBadges.delegate = self;
    tableViewBadges.dataSource = self;
    
    tableViewBadges.tableFooterView = [[UIView alloc] init];
    tableViewBadges.separatorColor = [UIColor clearColor];

    [self.m_badgeAndPhotoScrollView addSubview:tableViewBadges];
//    [self loadBagdes];
    
    [scrollViewPhotos addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBelowMore];
    }];

    [tableViewBadges addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadBelowMore];
    }];

}

- (void)insertRowAtBottom {
    __weak FeedSearchViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int nIdx = weakSelf.arrayData.count - 1; nIdx >= 0; nIdx--)
        {
            [weakSelf.tableViewBadges beginUpdates];
            [weakSelf.arrayBadges addObject:[weakSelf.arrayData objectAtIndex:nIdx]];
            [tableViewBadges insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.arrayBadges.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableViewBadges endUpdates];
        }
        
        [weakSelf.tableViewBadges.infiniteScrollingView stopAnimating];
    });
}

- (void) loadBelowMore
{
    [self doSearch];
}

- (void) loadPhotos
{
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
    
    if (nPreLoadedCount == -1)
    {
        for (int nIdx = 0; nIdx < arrayPhotoViews.count; nIdx++)
        {
            UIImageView* subView = (UIImageView *)[arrayPhotoViews objectAtIndex:nIdx];
            subView.hidden = YES;
            [subView removeFromSuperview];
        }

        [arrayPhotoViews removeAllObjects];
    }
    
    float fItemSizeWidth = viewWidth / 4.f;
    float fItemSizeHeight = fItemSizeWidth;
    
    int nCatItemIdx = nPreLoadedCount;
    int nRowIdx = nCatItemIdx / 4;
    
    for (int nIdx = nPreLoadedCount + 1; nIdx < arrayPhotos.count; nIdx++)
    {
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 4;
        
        PhotoEntity* photoEntity = [arrayPhotos objectAtIndex:nIdx];
        
        UIImageView* catSubView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight)];
        catSubView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        catSubView.contentMode = UIViewContentModeScaleAspectFill;
        catSubView.layer.borderColor = [UIColor whiteColor].CGColor;
        catSubView.layer.borderWidth = 1.f;
        catSubView.layer.cornerRadius = 0.f;
        catSubView.clipsToBounds = YES;
        catSubView.center = CGPointMake(fItemSizeWidth / 2.f * (nCatItemIdx % 4 * 2 + 1),fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) - 1.f);
        catSubView.tag = 120 + nIdx;
        catSubView.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture setDelegate:self];
        [catSubView addGestureRecognizer:tapGesture];
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntity.m_strPhotoLink imageView:catSubView];
        
        [scrollViewPhotos addSubview:catSubView];
        [arrayPhotoViews addObject:catSubView];
        
        lBeforeId = photoEntity.m_nID;
    }
    
    nPreLoadedCount = (int)arrayPhotos.count - 1;

    float fScrollHeight = fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + fItemSizeHeight / 2.f - 1.f;
    
    scrollViewPhotos.contentSize = CGSizeMake(viewWidth, fScrollHeight);
    
}

- (void) tapGesture:(UITapGestureRecognizer *) sender
{
    NSLog(@"tapped photo");
    UIImageView* catImageView = (UIImageView *)(sender.view);
    int nCatIdx = (int)(catImageView.tag) - 120;
    
    PhotoEntity* photoEntity = [arrayPhotos objectAtIndex:nCatIdx];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
    feedMainView.m_lPhotoId = photoEntity.m_nID;
    
    [self.navigationController pushViewController:feedMainView animated:YES];
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

    //load image=================================
    NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:strPhoto imageView:cell.m_imageView];
    //=======================================
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);

    cell.m_viewContainer.frame = CGRectMake(3, 3, viewWidth - 6.f, 74.f);
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.m_badgeAndPhotoScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [mainSegmentedControl setSelectedSegmentIndex:page animated:YES];
        
        self.m_searchBar.text = @"";
        m_strSearchText = @"";
    }
}

- (void) actionClickAdd:(SearchProfileView *)searchProfileView index:(int)nSelectedIndex
{
    NSLog(@"clicked add button");
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:nSelectedIndex inSection:0];
    curSelectedSearchView = (SearchProfileView *)[self.tableViewBadges cellForRowAtIndexPath:selectedIndexPath];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) showLoadingView
{
    [self.view endEditing:YES];
    
    [YXSpritesLoadingView showWithText:NSLocalizedString(@"loading", nil) andShimmering:YES andBlurEffect:NO];
}

- (void) hideLoadingView
{
    [YXSpritesLoadingView dismiss];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [scrollViewBadges.infiniteScrollingView stopAnimating];
    [scrollViewPhotos.infiniteScrollingView stopAnimating];

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

    NSArray* arrResponse = [receivedData JSONValue];
    
    NSString* strToSortBy = @"id";
    NSArray* arraySorted = [arrResponse sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString* s1 = [obj1 objectForKey:strToSortBy];
        NSString* s2 = [obj2 objectForKey:strToSortBy];
        
        long long lStr1 = [s1 longLongValue];
        long long lStr2 = [s2 longLongValue];
        
        NSComparisonResult result;
        
        if (lStr1 < lStr2) result = NSOrderedDescending;
        else if (lStr1 == lStr2) result = NSOrderedSame;
        else if (lStr1 > lStr2) result = NSOrderedAscending;
        //                {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};
        
        return result;
        //        return [s1 caseInsensitiveCompare:s2];
    }];

    if (mainSegmentedControl.selectedSegmentIndex == 0)
    {
        if (nPreLoadedCount == -1)
        {
            [arrayPhotos removeAllObjects];
        }
        
        for (int nIdx = 0; nIdx < arraySorted.count; nIdx++)
        {
            NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
            PhotoEntity* photoEntity = [[PhotoEntity alloc] initWithDictInfo:dictOne];
            [arrayPhotos addObject:photoEntity];
            
            lBeforeId = photoEntity.m_nID;
        }
        
        if (!bLoadSuggestionPhotos)
        {
            bLoadSuggestionPhotos = true;
            
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Configure for text only and offset down
            hub.mode = MBProgressHUDModeText;
            hub.labelText = NSLocalizedString(@"search_photo_suggestions", nil);
            hub.margin = 10.f;
            hub.removeFromSuperViewOnHide = YES;
            
            [hub hide:YES afterDelay:2.f];
        }
        
        bLoadSuggestionPhotos = true;
        
        [self loadPhotos];
    }
    else
    {
        [arrayData removeAllObjects];

        if (lBeforeId == 0)
        {
            [arrayBadges removeAllObjects];
            [self.tableViewBadges reloadData];
        }

        for (int nIdx = (int)(arraySorted.count - 1); nIdx >= 0 ; nIdx--)
        {
            NSDictionary* dictOne = [arraySorted objectAtIndex:nIdx];
            ProfileEntity* profileEntity = [[ProfileEntity alloc] initWithDictInfo:dictOne];
            [arrayData addObject:profileEntity];
            
            lBeforeId = profileEntity.m_nId;
        }

        if (!bLoadSuggestionProfiles)
        {
            bLoadSuggestionProfiles = true;
            
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Configure for text only and offset down
            hub.mode = MBProgressHUDModeText;
            hub.labelText = NSLocalizedString(@"search_profile_suggestions", nil);
            hub.margin = 10.f;
            hub.removeFromSuperViewOnHide = YES;
            
            [hub hide:YES afterDelay:2.f];
        }
        
        bLoadSuggestionProfiles = true;

        [self insertRowAtBottom];

    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [scrollViewBadges.infiniteScrollingView stopAnimating];
    [scrollViewPhotos.infiniteScrollingView stopAnimating];

    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}


@end
