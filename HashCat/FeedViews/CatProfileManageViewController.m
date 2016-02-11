//
//  CatProfileManageViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CatProfileManageViewController.h"
#import "Global.h"
#import "MenuTabViewController.h"
#import "CreateCatViewController.h"
#import "CatProfileViewController.h"
#import "UserProfileViewController.h"
#import "FeedService.h"

@interface CatProfileManageViewController ()

@end

#define REMOVE_PROFILE      100

@implementation CatProfileManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"create_or_choose_profile", nil);
    
    arrayViews = [[NSMutableArray alloc] init];
    
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
    
    self.m_imageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGestureForImage = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGestureForImage.numberOfTapsRequired = 1;
    [tapGestureForImage setDelegate:self];
    [self.m_imageView addGestureRecognizer:tapGestureForImage];
    
    CGPoint fOriginCenter = CGPointZero;
    fOriginCenter = self.m_imageView.center;
    if (self.m_imageView.frame.size.width > self.m_imageView.frame.size.height)
        self.m_imageView.frame = CGRectMake(0, 0, self.m_imageView.frame.size.height, self.m_imageView.frame.size.height);
    else
        self.m_imageView.frame = CGRectMake(0, 0, self.m_imageView.frame.size.width, self.m_imageView.frame.size.width);
    self.m_imageView.center = fOriginCenter;
    
    fOriginCenter = self.m_bgImageView.center;
    if (self.m_bgImageView.frame.size.width > self.m_bgImageView.frame.size.height)
        self.m_bgImageView.frame = CGRectMake(0, 0, self.m_bgImageView.frame.size.height, self.m_bgImageView.frame.size.height);
    else
        self.m_bgImageView.frame = CGRectMake(0, 0, self.m_bgImageView.frame.size.width, self.m_bgImageView.frame.size.width);
    self.m_bgImageView.center = fOriginCenter;
    
    self.m_bgImageView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f].CGColor;
    self.m_bgImageView.layer.borderWidth = 40.f;
    self.m_bgImageView.layer.cornerRadius = self.m_bgImageView.frame.size.height / 2.f;
    self.m_bgImageView.clipsToBounds = YES;
    
    self.m_imageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.m_imageView.layer.borderWidth = 0.f;
    self.m_imageView.layer.cornerRadius = self.m_imageView.frame.size.height / 2.f;
    self.m_imageView.clipsToBounds = YES;

    [[Utils sharedObject] loadImageFromServerAndLocal:g_Delegate.m_currentUser.m_strAvatarUrl imageView:self.m_imageView];
}

- (void) tapGesture:(UITapGestureRecognizer *) tapGestureRecognizer
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
    
    viewCon.m_bMyProfile = true;
    
    viewCon.m_nUserId = g_Delegate.m_currentUser.m_nID;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    //draw user image
    [self makeScrollView];
}

- (void) makeScrollView
{
    for (int nIdx = 0; nIdx < arrayViews.count; nIdx++)
    {
        CatSubView* subView = (CatSubView *)[arrayViews objectAtIndex:nIdx];
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    
    [arrayViews removeAllObjects];
    
    float fItemSizeWidth = (self.m_scrollView.frame.size.width - 15.f) / 3.f;
    float fItemSizeHeight = CAT_SUB_VIEW_HEIGHT;

    int nCatItemIdx = 0;
    int nRowIdx = nCatItemIdx / 3;
    
    //make create new item
    CatSubView* createNewCatSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
    createNewCatSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
    createNewCatSubView.m_imageView.image = [UIImage imageNamed:@"ic_add_white_48dp.png"];
    createNewCatSubView.m_lblTitle.text = NSLocalizedString(@"profile_add_label_new", nil);
    createNewCatSubView.m_bCreateNewButton = true;
    createNewCatSubView.delegate = self;
    [self.m_scrollView addSubview:createNewCatSubView];
    createNewCatSubView.center = CGPointMake((nCatItemIdx % 3 + 1) * 5.f + fItemSizeWidth / 2.f * (nCatItemIdx % 3 * 2 + 1), (nRowIdx + 1) * 5.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));
    [arrayViews addObject:createNewCatSubView];

    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrProfiles.count; nIdx++)
    {
        ProfileEntity* profile = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nIdx];
        
        nCatItemIdx++;
        nRowIdx = nCatItemIdx / 3;

        CatSubView* catSubView = [[[NSBundle mainBundle] loadNibNamed:@"CatSubView" owner:self options:nil] objectAtIndex:0];
        catSubView.frame = CGRectMake(0, 0, fItemSizeWidth, fItemSizeHeight);
        catSubView.m_imageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
        catSubView.m_lblTitle.text = profile.m_strUsername;
        catSubView.m_bCreateNewButton = false;
        catSubView.delegate = self;
        catSubView.m_nIndex = nIdx;
        catSubView.center = CGPointMake((nCatItemIdx % 3 + 1) * 5.f + fItemSizeWidth / 2.f * (nCatItemIdx % 3 * 2 + 1), (nRowIdx + 1) * 5.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1));

        [self.m_scrollView addSubview:catSubView];
        [arrayViews addObject:catSubView];
        
        //load image=================================
        NSString* strPhoto = profile.m_strCaminhoThumbnailLink;
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:strPhoto imageView:catSubView.m_imageView];
        //=======================================
    }
    
    float fScrollHeight = (nRowIdx + 1) * 5.f + fItemSizeHeight / 2.f * (nRowIdx * 2 + 1) + 5.f + fItemSizeHeight / 2.f;
    
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width, fScrollHeight);
}

- (void) backToMainView
{
    [g_Delegate.m_curMenuTabViewCon.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"create_or_choose_profile_dialog_title_remove_profile", nil) message:NSLocalizedString(@"create_or_choose_profile_dialog_content_remove_profile", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
            alertView.tag = 200;
            
            [alertView show];
        }
        
        if (buttonIndex == 2)
        {
            //goto edit profile
            ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nSelectedProfileIdx];

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
            
            CreateCatViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"createcatview"];
            viewCon.m_bViewMode = false;
            viewCon.m_nProfileIndexInUser = nSelectedProfileIdx;
            viewCon.m_profileEntity = profileEntity;
            viewCon.m_bReloadProfile = true;
            [self.navigationController pushViewController:viewCon animated:YES];
        }
    }
    
    if (alertView.tag == 200)
    {
        if (buttonIndex == 1)
        {
            ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nSelectedProfileIdx];

            [self showLoadingView];
            
            NSDictionary * dictSessionInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
            NSString* strPassword = @"";
            if ([[dictSessionInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
                strPassword = [dictSessionInfo valueForKey:@"userpassword"];
            else
                strPassword = [dictSessionInfo valueForKey:@"password"];

            nRequestMode = REMOVE_PROFILE;
            [FeedService removeProfile:profileEntity.m_nId withPassword:strPassword withDelegate:self];
        }
    }
}

- (void) actionAdditionalProcess:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    nSelectedProfileIdx = (int)index;
    
    ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nSelectedProfileIdx];

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:profileEntity.m_strUsername message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"create_or_choose_profile_remove_profile", nil), NSLocalizedString(@"create_or_choose_profile_edit_profile", nil), nil];
    alertView.tag = 100;
    
    [alertView show];
}

- (void) actionViewInfo:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:index];
    viewCon.m_nProfileId = profileEntity.m_nId;
    viewCon.m_bMyProfile = true;
    viewCon.m_strProfileUsername = profileEntity.m_strUsername;
    viewCon.m_profileEntity = profileEntity;
    viewCon.m_nProfileIndexInUser = (int)index;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void) createNewOne:(CatSubView *)catSubView withIndex:(NSInteger)index
{
    NSLog(@"create one");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CreateCatViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"createcatview"];
    viewCon.m_bViewMode = true;
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    NSString *receivedData = [request responseString];
    if ([receivedData isEqualToString:@"null"])
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"create_or_choose_profile_dialog_title_error_remove_profile", nil) message:NSLocalizedString(@"create_or_choose_profile_dialog_content_error_remove_profile", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"continue_string", nil), nil];
        alertView.tag = 300;
        
        [alertView show];
        return;
    }
    
    if (nRequestMode == REMOVE_PROFILE)
    {
        if ([receivedData isEqualToString:@"true"])
        {
            //success
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"create_or_choose_profile_profile_removed", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"continue_string", nil), nil];
            alertView.tag = 300;
            
            [alertView show];
            
            [g_Delegate.m_currentUser.m_arrProfiles removeObjectAtIndex:nSelectedProfileIdx];
            
            [self makeScrollView];
            
        }
        else
        {
            //false
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"create_or_choose_profile_dialog_title_error_remove_profile", nil) message:NSLocalizedString(@"create_or_choose_profile_dialog_content_error_remove_profile", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"continue_string", nil), nil];
            alertView.tag = 300;
            
            [alertView show];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

@end
