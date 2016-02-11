//
//  UserProfileViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Global.h"
#import "CatSubView.h"
#import "SignupViewController.h"
#import "FeedService.h"
#import "CatProfileViewController.h"
#import "BadgeInfoViewController.h"
#import "UserListViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayMainViews = [[NSMutableArray alloc] init];
    arrayBadgeViews = [[NSMutableArray alloc] init];
    arrayPhotoViews = [[NSMutableArray alloc] init];
    
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

    self.m_lblName.text = APP_FULL_NAME;

    self.m_currentUser = nil;

    if (!self.m_bMyProfile)
    {
        self.m_btnEdit.hidden = YES;
        self.m_imageBgView.frame = CGRectMake(self.m_imageBgView.frame.origin.x, self.m_imageBgView.frame.origin.y, self.m_imageBgView.frame.size.width, self.m_imageBgView.frame.size.height - self.m_btnEdit.frame.size.height - 5.f);
        self.m_imageTopBgView.frame = CGRectMake(self.m_imageTopBgView.frame.origin.x, self.m_imageTopBgView.frame.origin.y, self.m_imageTopBgView.frame.size.width, self.m_imageTopBgView.frame.size.height - self.m_btnEdit.frame.size.height - 5.f);
        
        self.m_viewPart.frame = CGRectMake(self.m_viewPart.frame.origin.x, self.m_imageTopBgView.frame.origin.y + self.m_imageTopBgView.frame.size.height - 23.f, self.m_viewPart.frame.size.width, self.m_viewPart.frame.size.height + self.m_btnEdit.frame.size.height);
    }

    if (!g_Delegate.m_bHasBottomBar)
        self.m_viewPart.frame = CGRectMake(self.m_viewPart.frame.origin.x, self.m_viewPart.frame.origin.y, self.m_viewPart.frame.size.width, self.m_viewPart.frame.size.height + MENU_TAB_HEIGHT);
    
    float fImageViewHeight = self.m_profileImageView.frame.size.width;
    if (self.m_profileImageView.frame.size.width > self.m_profileImageView.frame.size.height)
    {
        fImageViewHeight = self.m_profileImageView.frame.size.height;
    }
    
    self.m_profileImageView.frame = CGRectMake(self.m_profileImageView.frame.origin.x, self.m_profileImageView.frame.origin.y, fImageViewHeight, fImageViewHeight);
    self.m_profileImageView.center = CGPointMake(self.view.frame.size.width / 2, self.m_profileImageView.center.y);
    
    self.m_profileImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    self.m_profileImageView.layer.cornerRadius = fImageViewHeight / 2.f;
    self.m_profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_profileImageView.layer.borderWidth = 3.f;
    self.m_profileImageView.clipsToBounds = YES;

    [self loadUserProfileInfo];
    
    [self makeBadgeAndPhotoScrollView];
    
    [self showLoadingView];
    [FeedService getUserProfile:self.m_nUserId withUsername:@"" withDelegate:self];
    
    bLoad = true;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) loadUserProfileInfo
{
    if (self.m_currentUser)
    {
        self.m_lblName.text = self.m_currentUser.m_strUsername;
        self.m_lblCatAmount.text = [NSString stringWithFormat:@"%d", (int)self.m_currentUser.m_arrProfiles.count];
        self.m_lblFollowingAmount.text = [NSString stringWithFormat:@"%d", (int)self.m_currentUser.m_nFollowingCnt];
        
        [[Utils sharedObject] loadImageFromServerAndLocal:self.m_currentUser.m_strAvatarUrl imageView:self.m_profileImageView];
        [[Utils sharedObject] makeBlurImage:self.m_currentUser.m_strAvatarUrl  imageView:self.m_imageBgView];
    }
    else
    {
        self.m_lblCatAmount.text = @"0";
        self.m_lblFollowingAmount.text = @"0";
    }
        
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    if (bLoad)
    {
        /*
        float fImageViewHeight = self.m_profileImageView.frame.size.width;
        if (self.m_profileImageView.frame.size.width > self.m_profileImageView.frame.size.height)
        {
            fImageViewHeight = self.m_profileImageView.frame.size.height;
        }
        
        self.m_profileImageView.frame = CGRectMake(self.m_profileImageView.frame.origin.x, self.m_profileImageView.frame.origin.y, fImageViewHeight, fImageViewHeight);
        self.m_profileImageView.center = CGPointMake(self.view.frame.size.width / 2, self.m_profileImageView.center.y);
        
        self.m_profileImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        self.m_profileImageView.layer.cornerRadius = fImageViewHeight / 2.f;
        self.m_profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.m_profileImageView.layer.borderWidth = 3.f;
        self.m_profileImageView.clipsToBounds = YES;
         */
        
        bLoad = false;
    }

}

- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeBadgeAndPhotoScrollView
{
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
    CGFloat fScrollHeight = self.m_viewPart.frame.size.height - 50;
    
    
    self.m_viewPart.layer.cornerRadius = 2.f;
    self.m_viewPart.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_viewPart.layer.borderWidth = 1.f;
    self.m_viewPart.clipsToBounds = YES;
    
    [[Utils sharedObject] makeBoxShadowEffect:self.m_viewPart radius:2.f color:CONTAINER_SHADOW_COLOR corner:2.f];

    // Tying up the segmented control to a scroll view
    mainSegmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    mainSegmentedControl.sectionTitles = @[NSLocalizedString(@"profiles", nil), NSLocalizedString(@"settings_badges", nil)];
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
    scrollViewPhotos.backgroundColor = [UIColor whiteColor];
    [self.m_badgeAndPhotoScrollView addSubview:scrollViewPhotos];
//    [self loadPhotos];
    
    scrollViewBadges = [[UIScrollView alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, fScrollHeight)];
    scrollViewBadges.backgroundColor = [UIColor whiteColor];
    [self.m_badgeAndPhotoScrollView addSubview:scrollViewBadges];
//    [self loadBagdes];
}

- (void) loadPhotos
{
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
    
    for (int nIdx = 0; nIdx < arrayPhotoViews.count; nIdx++)
    {
        CatSubView* subView = (CatSubView *)[arrayPhotoViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [arrayPhotoViews removeAllObjects];
    
    float fItemSizeWidth = (viewWidth - 3.f) / 3.f;
    float fItemSizeHeight = CAT_SUB_VIEW_HEIGHT;
    
    int nCatItemIdx = -1;
    int nRowIdx = 0;
    
    for (int nIdx = 0; nIdx < self.m_currentUser.m_arrProfiles.count; nIdx++)
    {
        ProfileEntity* profile = [self.m_currentUser.m_arrProfiles objectAtIndex:nIdx];
        
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 3;
        
        CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
        catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
        catSubView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        catSubView.m_lblTitle.text = profile.m_strUsername;
        catSubView.m_bCreateNewButton = true;
        catSubView.m_nIndex = nIdx;
        catSubView.delegate = self;
        catSubView.center = CGPointMake((nCatItemIdx % 3 + 1) * 2.f + fItemSizeWidth / 2.f * (nCatItemIdx % 3 * 2 + 1), (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
        
        [scrollViewPhotos addSubview:catSubView];
        [arrayPhotoViews addObject:catSubView];
        
        //load image=================================
        NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
        [[Utils sharedObject] loadImageFromServerAndLocal:strPhoto imageView:catSubView.m_imageView];
        //=======================================
    }
    
    float fScrollHeight = (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + 2.f + fItemSizeHeight / 2.f;
    
    scrollViewPhotos.contentSize = CGSizeMake(viewWidth, fScrollHeight);
}

- (void) loadBagdes
{
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
    
    for (int nIdx = 0; nIdx < arrayBadgeViews.count; nIdx++)
    {
        CatSubView* subView = (CatSubView *)[arrayBadgeViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [arrayBadgeViews removeAllObjects];
    
    float fItemSizeWidth = (viewWidth - 3.f) / 4.f;
    float fItemSizeHeight = CAT_SUB_VIEW_HEIGHT;
    
    int nCatItemIdx = -1;
    int nRowIdx = 0;
    
    for (int nIdx = 0; nIdx < self.m_currentUser.m_arrBadgesAcquired.count; nIdx++)
    {
        BadgeEntity* badgeEntity = ((BadgesAcquiredEntity *)[self.m_currentUser.m_arrBadgesAcquired objectAtIndex:nIdx]).m_badge;
        
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 4;
        
        CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
        catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
        catSubView.m_imageView.image = [UIImage imageNamed:[[Utils sharedObject] getBadgeImageName:badgeEntity]];
        catSubView.m_imageView.layer.borderWidth = 0.f;
        catSubView.m_imageView.layer.borderColor = MAIN_COLOR.CGColor;
        catSubView.m_imageView.clipsToBounds = YES;
        catSubView.m_lblTitle.text = badgeEntity.m_strName;
        catSubView.m_bCreateNewButton = false;
        catSubView.delegate = self;
        catSubView.m_nIndex = nIdx;
        catSubView.center = CGPointMake((nCatItemIdx % 4 + 1) * 2.f + fItemSizeWidth / 2.f * (nCatItemIdx % 4 * 2 + 1), (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
        
        [scrollViewBadges addSubview:catSubView];
        [arrayBadgeViews addObject:catSubView];
    }
    
    float fScrollHeight = (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + 2.f + fItemSizeHeight / 2.f;
    
    scrollViewBadges.contentSize = CGSizeMake(viewWidth, fScrollHeight);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.m_badgeAndPhotoScrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [mainSegmentedControl setSelectedSegmentIndex:page animated:YES];
    }
}

- (void) createNewOne:(CatSubView *) catSubView withIndex:(NSInteger) index
{
    ProfileEntity* profile = [self.m_currentUser.m_arrProfiles objectAtIndex:index];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    viewCon.m_nProfileId = profile.m_nId;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:profile.m_strUsername];
    viewCon.m_strProfileUsername = profile.m_strUsername;
    viewCon.m_nProfileIndexInUser = (int)index;
    viewCon.m_profileEntity = profile;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    
}

- (void) actionViewInfo:(CatSubView *) catSubView withIndex:(NSInteger) index
{
    BadgeEntity* badgeEntity = ((BadgesAcquiredEntity *)[self.m_currentUser.m_arrBadgesAcquired objectAtIndex:index]).m_badge;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    BadgeInfoViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"badgeinfoview"];
    viewCon.m_badge = badgeEntity;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void) actionEditProfile:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    SignupViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"signupview"];
    viewCon.m_bViewMode = false;
    viewCon.m_userEntity = self.m_currentUser;
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    NSString *receivedData = [request responseString];
    NSDictionary *dictResponse = [receivedData JSONValue];
    if (dictResponse == nil)
    {
        [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
        return;
    }
 
    if (self.m_bMyProfile)
    {
        //update current user info
        g_Delegate.m_currentUser.m_strActive = [dictResponse valueForKey:@"active"];
        g_Delegate.m_currentUser.m_strAvatarUrl = [dictResponse valueForKey:@"avatarUrl"];
        g_Delegate.m_currentUser.m_country = [[CountryEntity alloc] initWithDictInfo:[dictResponse valueForKey:@"country"]];
        g_Delegate.m_currentUser.m_strFirstName = [dictResponse valueForKey:@"firstName"];
        
        [g_Delegate.m_currentUser.m_arrProfiles removeAllObjects];
        NSArray* arrayTemp = [dictResponse valueForKey:@"following"];
        for (int nIdx = 0; nIdx < arrayTemp.count; nIdx++)
        {
            NSDictionary* dictOne = [arrayTemp objectAtIndex:nIdx];
            FollowEntity* followEntity = [[FollowEntity alloc] initWithDictInfo:dictOne];
            
            [g_Delegate.m_currentUser.m_arrFollowings addObject:followEntity];
        }
        
        g_Delegate.m_currentUser.m_nFollowingCnt = (int)[[dictResponse valueForKey:@"followingCount"] integerValue];
        g_Delegate.m_currentUser.m_nID = [[dictResponse valueForKey:@"id"] longLongValue];
        g_Delegate.m_currentUser.m_strLastName = [dictResponse valueForKey:@"lastName"];
        g_Delegate.m_currentUser.m_userProfilePhotoEntity = [[PhotoEntity alloc] initWithDictInfo:[dictResponse valueForKey:@"photo"]];
        
        [g_Delegate.m_currentUser.m_arrProfiles removeAllObjects];
        arrayTemp = [dictResponse valueForKey:@"profiles"];
        for (int nIdx = 0; nIdx < arrayTemp.count; nIdx++)
        {
            NSDictionary* dictOne = [arrayTemp objectAtIndex:nIdx];
            ProfileEntity* profileEntity = [[ProfileEntity alloc] initWithDictInfo:dictOne];
            
            [g_Delegate.m_currentUser.m_arrProfiles addObject:profileEntity];
        }
        
        [g_Delegate.m_currentUser.m_arrBadgesAcquired removeAllObjects];
        arrayTemp = [dictResponse valueForKey:@"badgesAcquired"];
        for (int nIdx = 0; nIdx < arrayTemp.count; nIdx++)
        {
            NSDictionary* dictOne = [arrayTemp objectAtIndex:nIdx];
            BadgesAcquiredEntity* badgeAcquiredEntity = [[BadgesAcquiredEntity alloc] initWithDictInfo:dictOne];
            
            [g_Delegate.m_currentUser.m_arrBadgesAcquired addObject:badgeAcquiredEntity];
        }
        
        g_Delegate.m_currentUser.m_nReportCnt = (int)[[self checkAvaiablityForNumber:[dictResponse valueForKey:@"reports"]] integerValue];
        g_Delegate.m_currentUser.m_strUsername = [dictResponse valueForKey:@"username"];
        self.m_currentUser = g_Delegate.m_currentUser;
        //========================
    }
    else
        self.m_currentUser = [[UserEntity alloc] initWithDictInfo:dictResponse];
    
    [self loadBagdes];
    [self loadPhotos];
    
    [self loadUserProfileInfo];
    
    if (self.m_bShowBadge)
    {
        CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
        CGFloat fScrollHeight = self.m_viewPart.frame.size.height - 50;
        
        mainSegmentedControl.selectedSegmentIndex = 1;
        [self.m_badgeAndPhotoScrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, fScrollHeight) animated:YES];
    }

}

- (NSString *) checkAvaiablityForNumber:(id) pObj
{
    if ([pObj isKindOfClass:[NSNull class]])
        return @"0";
    else
        return pObj;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
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

- (IBAction)actionshowFollowing:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserListViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userlistview"];
    
    viewCon.m_nId = self.m_currentUser.m_nID;
    viewCon.m_bViewMode = true;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

@end
