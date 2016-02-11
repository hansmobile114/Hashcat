//
//  CatProfileViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CatProfileViewController.h"
#import "Global.h"
#import "UserProfileView.h"
#import "CatProfileView.h"
#import "CatSubView.h"
#import "UserProfileViewController.h"
#import "CreateCatViewController.h"
#import "FeedService.h"
#import "FeedMainViewController.h"
#import "BadgeInfoViewController.h"
#import "UserListViewController.h"

@interface CatProfileViewController ()

@end

@implementation CatProfileViewController

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
    
    self.m_scrollView.delegate = self;
    self.m_scrollView.pagingEnabled = YES;
    
    if (self.m_bMyProfile)
        [self.m_btnEdit setTitle:NSLocalizedString(@"profile_add_button_edit", nil) forState:UIControlStateNormal];
    else
    {
        bFollowed = false;
        [self.m_btnEdit setTitle:NSLocalizedString(@"follow", nil) forState:UIControlStateNormal];

        for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
        {
            FollowEntity* followEntity = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
            if (followEntity.m_profile.m_nId == self.m_nProfileId)
            {
                bFollowed = true;
                nFollowIdx = nIdx;
                
                [self.m_btnEdit setTitle:NSLocalizedString(@"unfollow", nil) forState:UIControlStateNormal];
                
                break;
            }
        }
    }
    
    self.m_viewPart.frame = CGRectMake(self.m_viewPart.frame.origin.x, self.m_imageTopBgView.frame.origin.y + self.m_imageTopBgView.frame.size.height - 23.f, self.m_viewPart.frame.size.width, self.m_viewPart.frame.size.height + self.m_btnEdit.frame.size.height);

    if (!g_Delegate.m_bHasBottomBar)
        self.m_viewPart.frame = CGRectMake(self.m_viewPart.frame.origin.x, self.m_viewPart.frame.origin.y, self.m_viewPart.frame.size.width, self.view.frame.size.height - self.m_viewPart.frame.origin.y - 10.f);
    else
        self.m_viewPart.frame = CGRectMake(self.m_viewPart.frame.origin.x, self.m_viewPart.frame.origin.y, self.m_viewPart.frame.size.width, self.view.frame.size.height - self.m_viewPart.frame.origin.y - MENU_TAB_HEIGHT - 10.f);
    
    [self makeBadgeAndPhotoScrollView];
    if (self.m_nProfileId != -1)
        [self performSelector:@selector(makeProfileScrollView) withObject:nil afterDelay:0.1f];
    
    [self getProfileInfo];
    
    bLoad = false;

    bLoad = true;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    if (bLoad)
    {
    }
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) getProfileInfo
{
    [self showLoadingView];
    
    nRequestMode = GET_PROFILE_REQUEST;
    
    [FeedService getProfile:self.m_nProfileId withUsername:self.m_strProfileUsername withDelegate:self];
}

- (void) makeProfileScrollView
{
    for (int nIdx = 0; nIdx < arrayMainViews.count; nIdx++)
    {
        UIView *subView = (UIView *)[arrayMainViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
        subView = nil;
    }
    
    [arrayMainViews removeAllObjects];
    
    CatProfileView* catProfileView = [[[NSBundle mainBundle] loadNibNamed:@"CatProfileView" owner:self options:nil] objectAtIndex:0];
    catProfileView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.m_scrollView.self.frame.size.height);
    catProfileView.m_lblBreed.text = self.m_profileEntity.m_breed.m_strName;
    [catProfileView.m_lblBreed sizeToFit];
    
    float fTempWidth = 12.f;
    catProfileView.m_lblBreed.center = CGPointMake(catProfileView.m_lblName.center.x + 5.f, catProfileView.m_lblBreed.center.y);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        catProfileView.m_lblBreed.center = CGPointMake(catProfileView.m_lblName.center.x + 10.f, catProfileView.m_lblBreed.center.y);
        fTempWidth = 20.f;
    }
    
    catProfileView.m_icoinBreed.center = CGPointMake(catProfileView.m_lblBreed.center.x - catProfileView.m_lblBreed.frame.size.width / 2 - fTempWidth, catProfileView.m_lblBreed.center.y);
    catProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%d", self.m_profileEntity.nFollowersCnt];
    catProfileView.m_lblPhotoAmount.text = [NSString stringWithFormat:@"%d", self.m_profileEntity.m_nPhotosCnt];
    catProfileView.m_lblName.text = self.m_profileEntity.m_strUsername;
    catProfileView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    [[Utils sharedObject] loadImageFromServerAndLocal:self.m_profileEntity.m_strCaminhoThumbnailLink imageView:catProfileView.m_imageView];
    
    CGPoint ptOriginalImageView = catProfileView.m_imageView.center;
    if (catProfileView.m_imageView.frame.size.width > catProfileView.m_imageView.frame.size.height)
    {
        catProfileView.m_imageView.frame = CGRectMake(0, 0, catProfileView.m_imageView.frame.size.height, catProfileView.m_imageView.frame.size.height);
        catProfileView.m_imageView.layer.cornerRadius = catProfileView.m_imageView.frame.size.height / 2.f;
    }
    else
    {
        catProfileView.m_imageView.frame = CGRectMake(0, 0, catProfileView.m_imageView.frame.size.width, catProfileView.m_imageView.frame.size.width);
        catProfileView.m_imageView.layer.cornerRadius = catProfileView.m_imageView.frame.size.width / 2.f;
    }

    catProfileView.m_imageView.center = ptOriginalImageView;
    catProfileView.m_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    catProfileView.m_imageView.layer.borderWidth = 3.f;
    catProfileView.m_imageView.clipsToBounds = YES;
    

    catProfileView.delegate = self;
    
    [arrayMainViews addObject:catProfileView];
    [self.m_scrollView addSubview:catProfileView];
    
    UserProfileView* userProfileView = [[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil] objectAtIndex:0];
    userProfileView.frame = CGRectMake(self.view.frame.size.width, 0, self.m_scrollView.frame.size.width, self.m_scrollView.self.frame.size.height);
    userProfileView.m_lblPhotoAmount.text = [NSString stringWithFormat:@"%d %@", self.m_profileEntity.m_nPhotosCnt, NSLocalizedString(@"photos", nil)];
    userProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%d %@", self.m_profileEntity.nFollowersCnt, NSLocalizedString(@"badge_type_followers", nil)];
    userProfileView.m_lblUserName.text = self.m_profileEntity.m_strName;
    userProfileView.m_lblDescription.text = self.m_profileEntity.m_strDescription;
    
    userProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%@", self.m_profileEntity.m_country.m_strName];
    userProfileView.m_lblPhotoAmount.text = @"";//[NSString stringWithFormat:@"%d badges", (int)(getProfileEntity.m_arrBadgesAcquired.count)];

    userProfileView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    userProfileView.m_userImageVIew.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];

    CGPoint ptOriginalImageViewForUser = userProfileView.m_imageView.center;
    if (userProfileView.m_imageView.frame.size.width > userProfileView.m_imageView.frame.size.height)
    {
        userProfileView.m_imageView.frame = CGRectMake(0, 0, userProfileView.m_imageView.frame.size.height, userProfileView.m_imageView.frame.size.height);
        userProfileView.m_imageView.layer.cornerRadius = userProfileView.m_imageView.frame.size.height / 2.f;
    }
    else
    {
        userProfileView.m_imageView.frame = CGRectMake(0, 0, userProfileView.m_imageView.frame.size.width, userProfileView.m_imageView.frame.size.width);
        userProfileView.m_imageView.layer.cornerRadius = userProfileView.m_imageView.frame.size.width / 2.f;
    }
    
    userProfileView.m_imageView.center = ptOriginalImageViewForUser;
    userProfileView.m_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    userProfileView.m_imageView.layer.borderWidth = 3.f;
    userProfileView.m_imageView.clipsToBounds = YES;

    CGPoint ptOriginalUserImageViewForUser = userProfileView.m_userImageVIew.center;
    if (userProfileView.m_userImageVIew.frame.size.width > userProfileView.m_userImageVIew.frame.size.height)
    {
        userProfileView.m_userImageVIew.frame = CGRectMake(0, 0, userProfileView.m_userImageVIew.frame.size.height, userProfileView.m_userImageVIew.frame.size.height);
        userProfileView.m_userImageVIew.layer.cornerRadius = userProfileView.m_userImageVIew.frame.size.height / 2.f;
    }
    else
    {
        userProfileView.m_userImageVIew.frame = CGRectMake(0, 0, userProfileView.m_userImageVIew.frame.size.width, userProfileView.m_userImageVIew.frame.size.width);
        userProfileView.m_userImageVIew.layer.cornerRadius = userProfileView.m_userImageVIew.frame.size.width / 2.f;
    }
    
    userProfileView.m_userImageVIew.center = ptOriginalUserImageViewForUser;
    userProfileView.m_userImageVIew.layer.borderColor = [UIColor whiteColor].CGColor;
    userProfileView.m_userImageVIew.layer.borderWidth = 1.f;
    userProfileView.m_userImageVIew.clipsToBounds = YES;

    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:self.m_profileEntity.m_strCaminhoThumbnailLink imageView:userProfileView.m_imageView];
//    [[Utils sharedObject] loadImageFromServerAndLocal:g_Delegate.m_currentUser.m_userProfilePhotoEntity.m_strPhotoLink imageView:userProfileView.m_userImageVIew];

    userProfileView.delegate = self;
    [arrayMainViews addObject:userProfileView];
    [self.m_scrollView addSubview:userProfileView];

    self.m_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.m_scrollView.self.frame.size.height);
    
    [[Utils sharedObject] makeBlurImage:self.m_profileEntity.m_strCaminhoThumbnailLink  imageView:self.m_imageBgView];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == self.m_scrollView)
    {
        CGFloat pageWidth = self.m_scrollView.frame.size.width;
        float fractionalPage = self.m_scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.m_pageControl.currentPage = page;
    }
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
    mainSegmentedControl.sectionTitles = @[[[[NSLocalizedString(@"photos", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"photos", nil) substringFromIndex:1]], [[[NSLocalizedString(@"badges", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"badges", nil) substringFromIndex:1]]];
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
        UIImageView* subView = (UIImageView *)[arrayPhotoViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [arrayPhotoViews removeAllObjects];

    float fItemSizeWidth = viewWidth / 4.f;
    float fItemSizeHeight = fItemSizeWidth;
    
    int nCatItemIdx = -1;
    int nRowIdx = 0;
    
    for (int nIdx = 0; nIdx < getProfileEntity.m_arrPhotos.count; nIdx++)
    {
        PhotoEntity* photoEntity = [getProfileEntity.m_arrPhotos objectAtIndex:nIdx];
        
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 4;
        
        UIImageView* catSubView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight)];
        catSubView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        catSubView.contentMode = UIViewContentModeScaleAspectFill;
        catSubView.layer.borderColor = [UIColor whiteColor].CGColor;
        catSubView.layer.borderWidth = 1.f;
        catSubView.layer.cornerRadius = 0.f;
        catSubView.clipsToBounds = YES;
        catSubView.center = CGPointMake(fItemSizeWidth / 2.f * (nCatItemIdx % 4 * 2 + 1),fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) - 1.f);
        catSubView.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGestureForImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
        tapGestureForImage.numberOfTapsRequired = 1;
        catSubView.tag = 120 + nIdx;
        [tapGestureForImage setDelegate:self];
        [catSubView addGestureRecognizer:tapGestureForImage];

        [scrollViewPhotos addSubview:catSubView];
        [arrayPhotoViews addObject:catSubView];
        
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntity.m_strPhotoLink imageView:catSubView];
    }
    
    float fScrollHeight = fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + fItemSizeHeight / 2.f - 1.f;
    
    scrollViewPhotos.contentSize = CGSizeMake(viewWidth, fScrollHeight);

}

- (void) tapGesture:(UITapGestureRecognizer *) sender
{
    NSLog(@"tapped photo");
    UIImageView* catImageView = (UIImageView *)(sender.view);
    int nCatIdx = (int)(catImageView.tag) - 120;
    
    PhotoEntity* photoEntity = [getProfileEntity.m_arrPhotos objectAtIndex:nCatIdx];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
    feedMainView.m_lPhotoId = photoEntity.m_nID;
    
    [self.navigationController pushViewController:feedMainView animated:YES];
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
    
    for (int nIdx = 0; nIdx < getProfileEntity.m_arrBadgesAcquired.count; nIdx++)
    {
        BadgeEntity* badgeEntity = ((BadgesAcquiredEntity *)[getProfileEntity.m_arrBadgesAcquired objectAtIndex:nIdx]).m_badge;
        
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 4;
        
        CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
        catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
        catSubView.m_imageView.image = [UIImage imageNamed:[[Utils sharedObject] getBadgeImageName:badgeEntity]];
        catSubView.m_imageView.layer.borderWidth = 0.f;
        catSubView.m_imageView.layer.borderColor = MAIN_COLOR.CGColor;
        catSubView.clipsToBounds = YES;
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

- (void) createNewOne:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    NSLog(@"none");
}

- (void) showFollowersInUserProfile:(UserProfileView *)userView
{
    CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
    CGFloat fScrollHeight = self.m_viewPart.frame.size.height - 50;
    
    mainSegmentedControl.selectedSegmentIndex = 1;
    [self.m_badgeAndPhotoScrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, fScrollHeight) animated:YES];

    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserListViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userlistview"];
    viewCon.m_bViewMode = false;
    viewCon.m_nId = self.m_profileEntity.m_nId;

    [self.navigationController pushViewController:viewCon animated:YES];
     */

}

- (void) showFollowersInCatProfile:(CatProfileView *)catView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserListViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userlistview"];
    
    viewCon.m_bViewMode = false;
    viewCon.m_nId = self.m_profileEntity.m_nId;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}


- (void) actionViewInfo:(CatSubView *) catSubView withIndex:(NSInteger) index
{
    BadgeEntity* badgeEntity = ((BadgesAcquiredEntity *)[getProfileEntity.m_arrBadgesAcquired objectAtIndex:index]).m_badge;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    BadgeInfoViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"badgeinfoview"];
    viewCon.m_badge = badgeEntity;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    
}

- (void) actionClickedUserPhoto:(UserProfileView *)userView userInfo:(UserEntity *)userEntity
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
    
    if ([g_Delegate.m_currentUser.m_strUsername isEqualToString:getProfileEntity.m_owner.m_strUsername])
        viewCon.m_bMyProfile = true;
    else
        viewCon.m_bMyProfile = false;
    
    viewCon.m_nUserId = getProfileEntity.m_owner.m_nID;
    
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

- (void) changeFollowingAmounts:(int) nIncreaseVal
{
    for (int nIdx = 0; nIdx < arrayMainViews.count; nIdx++)
    {
        UIView *subView = (UIView *)[arrayMainViews objectAtIndex:nIdx];
        if ([subView isKindOfClass:[CatProfileView class]])
        {
            CatProfileView* catProfileView = (CatProfileView *)subView;
            catProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%d", self.m_profileEntity.nFollowersCnt + nIncreaseVal];
        }
        else if ([subView isKindOfClass:[UserProfileView class]])
        {
            UserProfileView* userProfileView = (UserProfileView *)subView;
            userProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%d %@", self.m_profileEntity.nFollowersCnt + nIncreaseVal, NSLocalizedString(@"badge_type_followers", nil)];
        }
    }
    
    self.m_profileEntity.nFollowersCnt += nIncreaseVal;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];

    NSString *receivedData = [request responseString];
    if ([receivedData isEqualToString:@"null"])
    {
        if (nRequestMode == FOLLOW_REQUEST && bFollowed)
        {
            [self changeFollowingAmounts:-1];
            
            bFollowed = false;
            
            [g_Delegate.m_currentUser.m_arrFollowings removeObjectAtIndex:nFollowIdx];
            [self.m_btnEdit setTitle:NSLocalizedString(@"follow", nil) forState:UIControlStateNormal];
            return;
        }
    }
    
    NSDictionary *dictResponse = [receivedData JSONValue];
    if (dictResponse == nil)
    {
        [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
        return;
    }
    
    if (nRequestMode == FOLLOW_REQUEST && !bFollowed)
    {
        bFollowed = true;
        
        FollowEntity* newFollowEntity = [[FollowEntity alloc] initWithDictInfo:dictResponse];
        [g_Delegate.m_currentUser.m_arrFollowings addObject:newFollowEntity];
        
        nFollowIdx = (int)g_Delegate.m_currentUser.m_arrFollowings.count - 1;
        
        [self changeFollowingAmounts:1];

        [self.m_btnEdit setTitle:NSLocalizedString(@"unfollow", nil) forState:UIControlStateNormal];
    }
    
    if (nRequestMode == GET_PROFILE_REQUEST)
    {
        getProfileEntity = [[GetProfileEntity alloc] initWithDictInfo:dictResponse];
        self.m_profileEntity = [[ProfileEntity alloc] initWithDictInfo:dictResponse];
        
        self.m_nProfileId = getProfileEntity.m_nId;
        
        if (self.m_bMyProfile)
            [self.m_btnEdit setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
        else
        {
            bFollowed = false;
            [self.m_btnEdit setTitle:NSLocalizedString(@"follow", nil) forState:UIControlStateNormal];
            
            for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
            {
                FollowEntity* followEntity = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
                if (followEntity.m_profile.m_nId == self.m_nProfileId)
                {
                    bFollowed = true;
                    nFollowIdx = nIdx;
                    
                    [self.m_btnEdit setTitle:NSLocalizedString(@"unfollow", nil) forState:UIControlStateNormal];
                    
                    break;
                }
            }
        }

        [self loadBagdes];
        [self loadPhotos];
        
        [self makeProfileScrollViewWithServerData];
        if (self.m_bShowBadge)
        {
            CGFloat viewWidth = CGRectGetWidth(self.m_viewPart.frame);
            CGFloat fScrollHeight = self.m_viewPart.frame.size.height - 50;

            mainSegmentedControl.selectedSegmentIndex = 1;
            [self.m_badgeAndPhotoScrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, fScrollHeight) animated:YES];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

- (void) makeProfileScrollViewWithServerData
{
    for (int nIdx = 0; nIdx < arrayMainViews.count; nIdx++)
    {
        UIView *subView = (UIView *)[arrayMainViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
        subView = nil;
    }
    
    [arrayMainViews removeAllObjects];

    CatProfileView* catProfileView = [[[NSBundle mainBundle] loadNibNamed:@"CatProfileView" owner:self options:nil] objectAtIndex:0];
    catProfileView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.m_scrollView.self.frame.size.height);
    catProfileView.m_lblBreed.text = getProfileEntity.m_breed.m_strName;
    [catProfileView.m_lblBreed sizeToFit];

    float fTempWidth = 12.f;
    catProfileView.m_lblBreed.center = CGPointMake(catProfileView.m_lblName.center.x + 5.f, catProfileView.m_lblBreed.center.y);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        catProfileView.m_lblBreed.center = CGPointMake(catProfileView.m_lblName.center.x + 10.f, catProfileView.m_lblBreed.center.y);
        fTempWidth = 20.f;
    }

    catProfileView.m_icoinBreed.center = CGPointMake(catProfileView.m_lblBreed.center.x - catProfileView.m_lblBreed.frame.size.width / 2 - fTempWidth, catProfileView.m_lblBreed.center.y);
    catProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%d", getProfileEntity.nFollowersCnt];
    catProfileView.m_lblPhotoAmount.text = [NSString stringWithFormat:@"%d", getProfileEntity.m_nPhotosCnt];
    catProfileView.m_lblName.text = getProfileEntity.m_strUsername;
    catProfileView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    [[Utils sharedObject] loadImageFromServerAndLocal:getProfileEntity.m_strCaminhoThumbnailLink imageView:catProfileView.m_imageView];
    catProfileView.delegate = self;
    
    [arrayMainViews addObject:catProfileView];
    [self.m_scrollView addSubview:catProfileView];
    CGPoint ptOriginalImageView = catProfileView.m_imageView.center;
    if (catProfileView.m_imageView.frame.size.width > catProfileView.m_imageView.frame.size.height)
    {
        catProfileView.m_imageView.frame = CGRectMake(0, 0, catProfileView.m_imageView.frame.size.height, catProfileView.m_imageView.frame.size.height);
        catProfileView.m_imageView.layer.cornerRadius = catProfileView.m_imageView.frame.size.height / 2.f;
    }
    else
    {
        catProfileView.m_imageView.frame = CGRectMake(0, 0, catProfileView.m_imageView.frame.size.width, catProfileView.m_imageView.frame.size.width);
        catProfileView.m_imageView.layer.cornerRadius = catProfileView.m_imageView.frame.size.width / 2.f;
    }
    
    catProfileView.m_imageView.center = ptOriginalImageView;
    catProfileView.m_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    catProfileView.m_imageView.layer.borderWidth = 3.f;
    catProfileView.m_imageView.clipsToBounds = YES;

    UserProfileView* userProfileView = [[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil] objectAtIndex:0];
    userProfileView.frame = CGRectMake(self.view.frame.size.width, 0, self.m_scrollView.frame.size.width, self.m_scrollView.self.frame.size.height);
    userProfileView.m_lblPhotoAmount.text = [NSString stringWithFormat:@"%d %@", getProfileEntity.m_nPhotosCnt, NSLocalizedString(@"photos", nil)];
    userProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%d %@", self.m_profileEntity.nFollowersCnt, NSLocalizedString(@"badges", nil)];
    userProfileView.m_lblUserName.text = getProfileEntity.m_strName;
    userProfileView.m_lblDescription.text = getProfileEntity.m_strDescription;
    
    userProfileView.m_lblFollowerAmount.text = [NSString stringWithFormat:@"%@", getProfileEntity.m_country.m_strName];
    userProfileView.m_lblPhotoAmount.text = [NSString stringWithFormat:@"%d %@", (int)(getProfileEntity.m_arrBadgesAcquired.count), NSLocalizedString(@"badges", nil)];

    [userProfileView.m_lblFollowerAmount sizeToFit];
    [userProfileView.m_lblPhotoAmount sizeToFit];
    
    userProfileView.m_lblPhotoAmount.center = CGPointMake(userProfileView.m_imagePhotosIcon.frame.origin.x + userProfileView.m_imagePhotosIcon.frame.size.width + 5.f + userProfileView.m_lblPhotoAmount.frame.size.width / 2.f, userProfileView.m_imagePhotosIcon.center.y);
    userProfileView.m_lblFollowerAmount.center = CGPointMake(self.view.frame.size.width - userProfileView.m_lblFollowerAmount.frame.size.width / 2.f - userProfileView.m_imagePhotosIcon.frame.origin.x, userProfileView.m_imageFollowerIcon.center.y);
    userProfileView.m_imageFollowerIcon.center = CGPointMake(userProfileView.m_lblFollowerAmount.frame.origin.x - userProfileView.m_imageFollowerIcon.frame.size.width / 2.f - 5.f, userProfileView.m_imageFollowerIcon.center.y);
    
    userProfileView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    userProfileView.m_userImageVIew.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:getProfileEntity.m_strCaminhoThumbnailLink imageView:userProfileView.m_imageView];
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:getProfileEntity.m_owner.m_strAvatarUrl imageView:userProfileView.m_userImageVIew];
    
    CGPoint ptOriginalImageViewForUser = userProfileView.m_imageView.center;
    if (userProfileView.m_imageView.frame.size.width > userProfileView.m_imageView.frame.size.height)
    {
        userProfileView.m_imageView.frame = CGRectMake(0, 0, userProfileView.m_imageView.frame.size.height, userProfileView.m_imageView.frame.size.height);
        userProfileView.m_imageView.layer.cornerRadius = userProfileView.m_imageView.frame.size.height / 2.f;
    }
    else
    {
        userProfileView.m_imageView.frame = CGRectMake(0, 0, userProfileView.m_imageView.frame.size.width, userProfileView.m_imageView.frame.size.width);
        userProfileView.m_imageView.layer.cornerRadius = userProfileView.m_imageView.frame.size.width / 2.f;
    }
    
    userProfileView.m_imageView.center = ptOriginalImageViewForUser;
    userProfileView.m_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    userProfileView.m_imageView.layer.borderWidth = 3.f;
    userProfileView.m_imageView.clipsToBounds = YES;
    
    CGPoint ptOriginalUserImageViewForUser = userProfileView.m_userImageVIew.center;
    if (userProfileView.m_userImageVIew.frame.size.width > userProfileView.m_userImageVIew.frame.size.height)
    {
        userProfileView.m_userImageVIew.frame = CGRectMake(0, 0, userProfileView.m_userImageVIew.frame.size.height, userProfileView.m_userImageVIew.frame.size.height);
        userProfileView.m_userImageVIew.layer.cornerRadius = userProfileView.m_userImageVIew.frame.size.height / 2.f;
    }
    else
    {
        userProfileView.m_userImageVIew.frame = CGRectMake(0, 0, userProfileView.m_userImageVIew.frame.size.width, userProfileView.m_userImageVIew.frame.size.width);
        userProfileView.m_userImageVIew.layer.cornerRadius = userProfileView.m_userImageVIew.frame.size.width / 2.f;
    }
    
    userProfileView.m_userImageVIew.center = ptOriginalUserImageViewForUser;
    userProfileView.m_userImageVIew.layer.borderColor = [UIColor whiteColor].CGColor;
    userProfileView.m_userImageVIew.layer.borderWidth = 1.f;
    userProfileView.m_userImageVIew.clipsToBounds = YES;

    userProfileView.delegate = self;
    [arrayMainViews addObject:userProfileView];
    [self.m_scrollView addSubview:userProfileView];
    
    self.m_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.m_scrollView.self.frame.size.height);
    
    [[Utils sharedObject] makeBlurImage:getProfileEntity.m_strCaminhoThumbnailLink  imageView:self.m_imageBgView];
}

- (IBAction)actionEditProfile:(id)sender {
    if (self.m_bMyProfile)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
        
        CreateCatViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"createcatview"];
        viewCon.m_bViewMode = false;
        viewCon.m_nProfileIndexInUser = self.m_nProfileIndexInUser;
        viewCon.m_profileEntity = self.m_profileEntity;
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else
    {
        [self showLoadingView];
        
        nRequestMode = FOLLOW_REQUEST;
        
        [FeedService followCat:self.m_nProfileId withDelegate:self];
    }
}
@end
