//
//  BadgeInfoViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/30/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "BadgeInfoViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "CatProfileViewController.h"
#import "UserProfileViewController.h"

@interface BadgeInfoViewController ()

@end

@implementation BadgeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.m_badge.m_strName;
    
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

    arrayResult = [[NSMutableArray alloc] init];
    arrayPhotoViews = [[NSMutableArray alloc] init];
    
    /*
    self.m_viewBadgeCondition.layer.cornerRadius = 5.f;
    self.m_viewBadgeCondition.clipsToBounds = YES;
     */
    
    if ([self.m_badge.m_strName isKindOfClass:[NSNull class]])
        self.m_lblBadgeName.text = @"";
    else
        self.m_lblBadgeName.text = self.m_badge.m_strName;
    
    if ([self.m_badge.m_strDescription isKindOfClass:[NSNull class]])
        self.m_lblBadgeCondition.text = @"";
    else
        self.m_lblBadgeCondition.text = self.m_badge.m_strDescription;
    
    self.m_badgeImageView.image = [UIImage imageNamed:[[Utils sharedObject] getBadgeImageName:self.m_badge]];
    
    NSArray* viewControllers = [self.navigationController viewControllers];
    
    UIViewController *previousViewController = [viewControllers objectAtIndex:([viewControllers indexOfObject:self]-1)];
    if([previousViewController isKindOfClass:[UserProfileViewController class]])
        bGetProfile = false;
    else
        bGetProfile = true;
    
    self.m_viewBadgeCondition.layer.cornerRadius = 2.f;
    self.m_viewBadgeCondition.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_viewBadgeCondition.layer.borderWidth = 1.f;
    self.m_viewBadgeCondition.clipsToBounds = YES;
    
    [[Utils sharedObject] makeBoxShadowEffect:self.m_viewBadgeCondition radius:2.f color:CONTAINER_SHADOW_COLOR corner:2.f];

    self.m_viewBottomView.layer.cornerRadius = 2.f;
    self.m_viewBottomView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_viewBottomView.layer.borderWidth = 1.f;
    self.m_viewBottomView.clipsToBounds = YES;
    
    [[Utils sharedObject] makeBoxShadowEffect:self.m_viewBottomView radius:2.f color:CONTAINER_SHADOW_COLOR corner:2.f];

    [self getBadgeDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    CGPoint ptOrigin = self.m_badgeImageView.center;
    if (self.m_badgeImageView.frame.size.width > self.m_badgeImageView.frame.size.height)
    {
        self.m_badgeImageView.frame = CGRectMake(0, 0, self.m_badgeImageView.frame.size.height, self.m_badgeImageView.frame.size.height);
        self.m_badgeImageView.layer.cornerRadius = self.m_badgeImageView.frame.size.height / 2.f;
    }
    else
    {
        self.m_badgeImageView.frame = CGRectMake(0, 0, self.m_badgeImageView.frame.size.width, self.m_badgeImageView.frame.size.width);
        self.m_badgeImageView.layer.cornerRadius = self.m_badgeImageView.frame.size.width / 2.f;
    }
    
    self.m_badgeImageView.center = ptOrigin;
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getBadgeDescription
{
    [self showLoadingView];
    nRequestMode = 1;
    
    [FeedService getBadge:self.m_badge.m_nID WithDelegate:self];
}

- (void) getBadgeInfo
{
    [self showLoadingView];
    
    nRequestMode = 2;

    if (bGetProfile)
        [FeedService latestProfiles:self.m_badge.m_nID withDelegate:self];
    else
        [FeedService latestUsers:self.m_badge.m_nID withDelegate:self];
}

- (void) loadPhotos
{
    CGFloat viewWidth = CGRectGetWidth(self.m_mainScrollView.frame);
    
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
    
    for (int nIdx = 0; nIdx < arrayResult.count; nIdx++)
    {
        if (bGetProfile)
        {
            ProfileEntity* profile = [arrayResult objectAtIndex:nIdx];
            
            nCatItemIdx++;
            nRowIdx = nCatItemIdx / 3;
            
            CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
            catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
            catSubView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
            catSubView.m_lblTitle.text = profile.m_strUsername;
            catSubView.m_bCreateNewButton = false;
            catSubView.m_nIndex = nIdx;
            catSubView.delegate = self;
            catSubView.center = CGPointMake((nCatItemIdx % 3 + 1) * 2.f + fItemSizeWidth / 2.f * (nCatItemIdx % 3 * 2 + 1), (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
            
            [self.m_mainScrollView addSubview:catSubView];
            [arrayPhotoViews addObject:catSubView];
            
            //load image=================================
            NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
            [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:strPhoto imageView:catSubView.m_imageView];
            //=======================================
        }
        else
        {
            OwnerEntity* profile = [arrayResult objectAtIndex:nIdx];
            
            nCatItemIdx++;
            nRowIdx = nCatItemIdx / 3;
            
            CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
            catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
            catSubView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
            catSubView.m_lblTitle.text = profile.m_strUsername;
            catSubView.m_bCreateNewButton = false;
            catSubView.m_nIndex = nIdx;
            catSubView.delegate = self;
            catSubView.center = CGPointMake((nCatItemIdx % 3 + 1) * 2.f + fItemSizeWidth / 2.f * (nCatItemIdx % 3 * 2 + 1), (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
            
            [self.m_mainScrollView addSubview:catSubView];
            [arrayPhotoViews addObject:catSubView];
            
            //load image=================================
            NSString* strPhoto = profile.m_strAvatarUrl;
            [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:strPhoto imageView:catSubView.m_imageView];
            //=======================================
        }
    }
    
    float fScrollHeight = (nRowIdx + 1) * 2.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + 2.f + fItemSizeHeight / 2.f;
    
    self.m_mainScrollView.contentSize = CGSizeMake(viewWidth, fScrollHeight);
}

- (void) createNewOne:(CatSubView *) catSubView withIndex:(NSInteger) index
{
    
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) actionViewInfo:(CatSubView *) catSubView withIndex:(NSInteger) index
{
    if (bGetProfile)
    {
        //show profile
        ProfileEntity* profile = [arrayResult objectAtIndex:index];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
        
        CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
        
        viewCon.m_nProfileId = profile.m_nId;
        viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:profile.m_strUsername];
        viewCon.m_strProfileUsername = profile.m_strUsername;
        viewCon.m_profileEntity = profile;
        
        [self.navigationController pushViewController:viewCon animated:YES];
    }
    else
    {
        OwnerEntity* ownerEntity = [arrayResult objectAtIndex:index];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
        
        UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
        
        if ([g_Delegate.m_currentUser.m_strUsername isEqualToString:ownerEntity.m_strUsername])
            viewCon.m_bMyProfile = true;
        else
            viewCon.m_bMyProfile = false;
        
        viewCon.m_nUserId = ownerEntity.m_nID;
        
        [self.navigationController pushViewController:viewCon animated:YES];
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    NSString *receivedData = [request responseString];
    if (nRequestMode == 1)
    {
        NSDictionary* dictResponse = [receivedData JSONValue];
        if (dictResponse == nil)
        {
            [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
            return;
        }
        
        self.m_badge = [[BadgeEntity alloc] initWithDictInfo:dictResponse];
        self.m_lblBadgeCondition.text = self.m_badge.m_strDescription;
        
        [self getBadgeInfo];
        
        return;
    }
    
    if (nRequestMode == 2)
    {
        NSArray *arrResponse = [receivedData JSONValue];
        if (arrResponse.count == 0)
        {
            return;
        }
        
        [arrayResult removeAllObjects];
        for (int nIdx = 0; nIdx < arrResponse.count; nIdx++)
        {
            NSDictionary* dictOne = [arrResponse objectAtIndex:nIdx];
            
            if (bGetProfile)
            {
                ProfileEntity* profile = [[ProfileEntity alloc] initWithDictInfo:dictOne];
                [arrayResult addObject:profile];
            }
            else
            {
                OwnerEntity* profile = [[OwnerEntity alloc] initWithDictInfo:dictOne];
                [arrayResult addObject:profile];
            }
            
        }
        
        [self loadPhotos];
    }
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

@end
