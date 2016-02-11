//
//  PlayGameViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/4/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "PlayGameViewController.h"
#import "Global.h"
#import "GameService.h"
#import "FeedService.h"
#import "CatProfileViewController.h"

@interface PlayGameViewController ()

@end

@implementation PlayGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Do any additional setup after loading the view.
    if (self.m_categoryEntity.m_bSelectable)
        self.navigationItem.title = [NSString stringWithFormat:@"#%@", self.m_categoryEntity.m_strName];
    else
        self.navigationItem.title = [NSString stringWithFormat:@"%@", self.m_categoryEntity.m_strName];
    
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
    
    self.m_viewCatInfo.hidden = YES;
    
    photoEntityOne = nil;
    photoEntityTwo = nil;

    bFollowOne = false;
    bFollowTwo = false;
    
    lWinnerId = -1;
    lLooseId = -1;
    
//    self.m_topImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);

    self.m_imageCat1.userInteractionEnabled = YES;
    self.m_imageCat2.userInteractionEnabled = YES;
    
    self.m_imageCat1.clipsToBounds = YES;
    self.m_imageCat2.clipsToBounds = YES;
    
    self.m_imageCat1.tag = 10;
    self.m_imageCat2.tag = 11;
    
    UITapGestureRecognizer *tapGestureOne = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGestureOne.numberOfTapsRequired = 1;
    [tapGestureOne setDelegate:self];
    [self.m_imageCat1 addGestureRecognizer:tapGestureOne];

    UITapGestureRecognizer *tapGestureTwo = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGestureTwo.numberOfTapsRequired = 1;
    [tapGestureTwo setDelegate:self];
    [self.m_imageCat2 addGestureRecognizer:tapGestureTwo];

    //adjust size
    CGPoint fOriginCenter = CGPointZero;
    fOriginCenter = self.m_btnFollow1.center;
    if (self.m_btnFollow1.frame.size.width > self.m_btnFollow1.frame.size.height)
        self.m_btnFollow1.frame = CGRectMake(0, 0, self.m_btnFollow1.frame.size.height, self.m_btnFollow1.frame.size.height);
    else
        self.m_btnFollow1.frame = CGRectMake(0, 0, self.m_btnFollow1.frame.size.width, self.m_btnFollow1.frame.size.width);
    self.m_btnFollow1.center = fOriginCenter;

    fOriginCenter = self.m_btnViewInfo1.center;
    if (self.m_btnViewInfo1.frame.size.width > self.m_btnViewInfo1.frame.size.height)
        self.m_btnViewInfo1.frame = CGRectMake(0, 0, self.m_btnViewInfo1.frame.size.height, self.m_btnViewInfo1.frame.size.height);
    else
        self.m_btnViewInfo1.frame = CGRectMake(0, 0, self.m_btnViewInfo1.frame.size.width, self.m_btnViewInfo1.frame.size.width);
    self.m_btnViewInfo1.center = fOriginCenter;

    fOriginCenter = self.m_btnFollow2.center;
    if (self.m_btnFollow2.frame.size.width > self.m_btnFollow2.frame.size.height)
        self.m_btnFollow2.frame = CGRectMake(0, 0, self.m_btnFollow2.frame.size.height, self.m_btnFollow2.frame.size.height);
    else
        self.m_btnFollow2.frame = CGRectMake(0, 0, self.m_btnFollow2.frame.size.width, self.m_btnFollow2.frame.size.width);
    self.m_btnFollow2.center = fOriginCenter;
    
    fOriginCenter = self.m_btnViewInfo2.center;
    if (self.m_btnViewInfo2.frame.size.width > self.m_btnViewInfo2.frame.size.height)
        self.m_btnViewInfo2.frame = CGRectMake(0, 0, self.m_btnViewInfo2.frame.size.height, self.m_btnViewInfo2.frame.size.height);
    else
        self.m_btnViewInfo2.frame = CGRectMake(0, 0, self.m_btnViewInfo2.frame.size.width, self.m_btnViewInfo2.frame.size.width);
    self.m_btnViewInfo2.center = fOriginCenter;
    //------------
    
    //adjust cat views
    if (self.m_imageCat1.frame.size.width > self.m_imageCat1.frame.size.height)
    {
        float fDiff = self.m_imageCat1.frame.size.width - self.m_imageCat1.frame.size.height;
        self.m_viewCat1.frame = CGRectMake(self.m_viewCat1.frame.origin.x, self.m_viewCat1.frame.origin.y - fDiff / 2.f, self.m_viewCat1.frame.size.width, self.m_viewCat1.frame.size.height + fDiff);
    }

    if (self.m_imageCat2.frame.size.width > self.m_imageCat2.frame.size.height)
    {
        float fDiff = self.m_imageCat2.frame.size.width - self.m_imageCat2.frame.size.height;
        self.m_viewCat2.frame = CGRectMake(self.m_viewCat2.frame.origin.x, self.m_viewCat2.frame.origin.y - fDiff / 2.f, self.m_viewCat2.frame.size.width, self.m_viewCat2.frame.size.height + fDiff);
    }

    [self.m_btnFollow1 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];
    [self.m_btnFollow2 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];

    self.m_viewCat1.layer.cornerRadius = 12.f;
    self.m_viewCat1.layer.borderWidth = 1.f;
    self.m_viewCat1.layer.borderColor = [MAIN_COLOR colorWithAlphaComponent:0.6f].CGColor;
    self.m_viewCat1.clipsToBounds = YES;
    
    self.m_viewCat2.layer.cornerRadius = 12.f;
    self.m_viewCat2.layer.borderWidth = 1.f;
    self.m_viewCat2.layer.borderColor = [MAIN_COLOR colorWithAlphaComponent:0.6f].CGColor;
    self.m_viewCat2.clipsToBounds = YES;
    
    //------------round effect with shadow-----------------
    [[Utils sharedObject] makeShadowEffect:self.m_viewCat1 radius:3.f color:MAIN_COLOR corner:12.f];
    [[Utils sharedObject] makeShadowEffect:self.m_viewCat2 radius:3.f color:MAIN_COLOR corner:12.f];
    //------------round effect with shadow-----------------
    

    //-----------------
    [self getMash];
}

- (void) tapGesture:(UITapGestureRecognizer *) gesture
{
    UIImageView* touchedView = (UIImageView *)(gesture.view);
    int nTag = (int)touchedView.tag;
    if (nTag == 10)
    {
        if (photoEntityOne == nil)
        {
            [self performSelector:@selector(getMash) withObject:nil afterDelay:0.1f];
            return;
        }
        
        lWinnerId = photoEntityOne.m_nID;
        if (photoEntityTwo == nil)
            lLooseId = -1;
        else
            lLooseId = photoEntityTwo.m_nID;
    }
    else
    {
        if (photoEntityTwo == nil)
        {
            [self performSelector:@selector(getMash) withObject:nil afterDelay:0.1f];
            return;
        }
        
        lWinnerId = photoEntityTwo.m_nID;
        if (photoEntityTwo == nil)
            lLooseId = -1;
        else
            lLooseId = photoEntityOne.m_nID;
    }

    [self voteProcess];
}

-(void) getMash
{
    [self.m_btnFollow1 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];
    [self.m_btnFollow2 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];

    self.m_imageCat1.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    self.m_imageCat2.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    
    lWinnerId = -1;
    lLooseId = -1;

    [self showLoadingView];

    nRequestMode = MASH_REQUEST;
    
    [GameService mashCategory:self.m_categoryEntity.m_nID withCache:false withDelegate:self];
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    //adjust size
    CGPoint fOriginCenter = CGPointZero;
    fOriginCenter = self.m_btnFollow1.center;
    if (self.m_btnFollow1.frame.size.width > self.m_btnFollow1.frame.size.height)
        self.m_btnFollow1.frame = CGRectMake(0, 0, self.m_btnFollow1.frame.size.height, self.m_btnFollow1.frame.size.height);
    else
        self.m_btnFollow1.frame = CGRectMake(0, 0, self.m_btnFollow1.frame.size.width, self.m_btnFollow1.frame.size.width);
    self.m_btnFollow1.center = fOriginCenter;
    
    fOriginCenter = self.m_btnViewInfo1.center;
    if (self.m_btnViewInfo1.frame.size.width > self.m_btnViewInfo1.frame.size.height)
        self.m_btnViewInfo1.frame = CGRectMake(0, 0, self.m_btnViewInfo1.frame.size.height, self.m_btnViewInfo1.frame.size.height);
    else
        self.m_btnViewInfo1.frame = CGRectMake(0, 0, self.m_btnViewInfo1.frame.size.width, self.m_btnViewInfo1.frame.size.width);
    self.m_btnViewInfo1.center = fOriginCenter;
    
    fOriginCenter = self.m_btnFollow2.center;
    if (self.m_btnFollow2.frame.size.width > self.m_btnFollow2.frame.size.height)
        self.m_btnFollow2.frame = CGRectMake(0, 0, self.m_btnFollow2.frame.size.height, self.m_btnFollow2.frame.size.height);
    else
        self.m_btnFollow2.frame = CGRectMake(0, 0, self.m_btnFollow2.frame.size.width, self.m_btnFollow2.frame.size.width);
    self.m_btnFollow2.center = fOriginCenter;
    
    fOriginCenter = self.m_btnViewInfo2.center;
    if (self.m_btnViewInfo2.frame.size.width > self.m_btnViewInfo2.frame.size.height)
        self.m_btnViewInfo2.frame = CGRectMake(0, 0, self.m_btnViewInfo2.frame.size.height, self.m_btnViewInfo2.frame.size.height);
    else
        self.m_btnViewInfo2.frame = CGRectMake(0, 0, self.m_btnViewInfo2.frame.size.width, self.m_btnViewInfo2.frame.size.width);
    self.m_btnViewInfo2.center = fOriginCenter;
    //------------

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

- (void) voteProcess
{
    [self showLoadingView];
    
    nRequestMode = VOTE_REQUEST;
    
    [GameService voteWinner:lWinnerId withLooser:lLooseId withCategory:self.m_categoryEntity.m_nID withDelegate:self];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        nRequestMode = REPORT_REQUEST;
        [self showLoadingView];
        [GameService reportPhoto:photoEntityOne.m_nID withDelegate:self];
    }
    else if (buttonIndex == 1)
    {
        nRequestMode = REPORT_REQUEST;
        [self showLoadingView];
        [GameService reportPhoto:photoEntityTwo.m_nID withDelegate:self];
    }

}

- (IBAction)actionReport:(id)sender {
    if (photoEntityOne == nil || photoEntityTwo == nil)
        return;
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"game_main_dialog_title_report", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:photoEntityOne.m_profile.m_strUsername, photoEntityTwo.m_profile.m_strUsername, nil];
    [actionSheet showInView:self.view];
}

- (IBAction)actionFollow1:(id)sender {
    if (photoEntityOne == nil)
        return;
    
    [self showLoadingView];
    
    bWhichCatFollow = true;
    
    nRequestMode = FOLLOW_REQUEST;
    
    [FeedService followCat:photoEntityOne.m_profile.m_nId withDelegate:self];
}

- (IBAction)actionViewCat1:(id)sender {
    if (photoEntityOne == nil)
        return;
    
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntityOne.m_strPhotoLink imageView:self.m_imageView];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.m_viewCatInfo.hidden = NO;
}

- (IBAction)actionViewInfo1:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    viewCon.m_nProfileId = photoEntityOne.m_profile.m_nId;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:photoEntityOne.m_profile.m_strUsername];
    viewCon.m_strProfileUsername = photoEntityOne.m_profile.m_strUsername;
    viewCon.m_profileEntity = photoEntityOne.m_profile;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (IBAction)actionFollow2:(id)sender {
    if (photoEntityTwo == nil)
        return;
    
    [self showLoadingView];
    
    bWhichCatFollow = false;
 
    nRequestMode = FOLLOW_REQUEST;
    
    [FeedService followCat:photoEntityTwo.m_profile.m_nId withDelegate:self];

}

- (IBAction)actionViewCat2:(id)sender {
    if (photoEntityTwo == nil)
        return;
    
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntityTwo.m_strPhotoLink imageView:self.m_imageView];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.m_viewCatInfo.hidden = NO;
}

- (IBAction)actionViewInfo2:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catprofileview"];
    
    viewCon.m_nProfileId = photoEntityTwo.m_profile.m_nId;
    viewCon.m_bMyProfile = [[Utils sharedObject] checkMyProfileIdWithOnlyUsername:photoEntityTwo.m_profile.m_strUsername];
    viewCon.m_strProfileUsername = photoEntityTwo.m_profile.m_strUsername;
    viewCon.m_profileEntity = photoEntityTwo.m_profile;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (IBAction)actionViewClose:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.m_viewCatInfo.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) drawInfo
{
    [self.m_btnFollow1 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];
    [self.m_btnFollow2 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];

    if (photoEntityOne == nil)
    {
        self.m_lblCat1.text = @"";
        return;
    }
    
    bFollowOne = false;
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
    {
        FollowEntity* followEntity = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
        if (followEntity.m_profile.m_nId == photoEntityOne.m_profile.m_nId)
        {
            bFollowOne = true;
            nFollowOneIndex = nIdx;
           
            [self.m_btnFollow1 setImage:[UIImage imageNamed:@"btn_cat_add_orange.png"] forState:UIControlStateNormal];

            break;
        }
    }

    self.m_lblCat1.text = photoEntityOne.m_profile.m_strUsername;
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntityOne.m_strPhotoLink imageView:self.m_imageCat1];

    if (photoEntityTwo == nil)
    {
        self.m_lblCat2.text = @"";
        return;
    }
    
    bFollowTwo = false;
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrFollowings.count; nIdx++)
    {
        FollowEntity* followEntity = [g_Delegate.m_currentUser.m_arrFollowings objectAtIndex:nIdx];
        if (followEntity.m_profile.m_nId == photoEntityTwo.m_profile.m_nId)
        {
            bFollowTwo = true;
            nFollowTwoIndex = nIdx;
            
            [self.m_btnFollow2 setImage:[UIImage imageNamed:@"btn_cat_add_orange.png"] forState:UIControlStateNormal];
            
            break;
        }
    }

    self.m_lblCat2.text = photoEntityTwo.m_profile.m_strUsername;
    [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:photoEntityTwo.m_strPhotoLink imageView:self.m_imageCat2];

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
    if ([receivedData isEqualToString:@"null"])
    {
        if (bWhichCatFollow)//cat1
        {
            if (nRequestMode == FOLLOW_REQUEST && bFollowOne)
            {
                bFollowOne = false;
                [g_Delegate.m_currentUser.m_arrFollowings removeObjectAtIndex:nFollowOneIndex];
                [self.m_btnFollow1 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];

                return;
            }
        }
        else
        {
            if (nRequestMode == FOLLOW_REQUEST && bFollowTwo)
            {
                bFollowTwo = false;
                [g_Delegate.m_currentUser.m_arrFollowings removeObjectAtIndex:nFollowTwoIndex];
                [self.m_btnFollow2 setImage:[UIImage imageNamed:@"btn_cat_add.png"] forState:UIControlStateNormal];
                
                return;
            }
        }
    }

    if (nRequestMode == REPORT_REQUEST)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feed_dialog_title_reported", nil) message:NSLocalizedString(@"feed_dialog_content_reported", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"continue_string", nil) otherButtonTitles:nil];
        alertView.tag = 130;
        [alertView show];
        
        return;
    }
    
    if (nRequestMode == VOTE_REQUEST)
    {
        if ([receivedData isEqualToString:@"true"] || [receivedData isEqualToString:@"false"])
            [self performSelector:@selector(getMash) withObject:nil afterDelay:0.1f];
        
        return;
    }

    NSDictionary *dictResponse = [receivedData JSONValue];
    if (dictResponse == nil)
    {
        [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
        return;
    }
    
    if (bWhichCatFollow)
    {
        if (nRequestMode == FOLLOW_REQUEST && !bFollowOne)
        {
            bFollowOne = true;
            
            FollowEntity* newFollowEntity = [[FollowEntity alloc] initWithDictInfo:dictResponse];
            [g_Delegate.m_currentUser.m_arrFollowings addObject:newFollowEntity];
            
            nFollowOneIndex = (int)g_Delegate.m_currentUser.m_arrFollowings.count - 1;
            
            [self.m_btnFollow1 setImage:[UIImage imageNamed:@"btn_cat_add_orange.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if (nRequestMode == FOLLOW_REQUEST && !bFollowTwo)
        {
            bFollowTwo = true;
            
            FollowEntity* newFollowEntity = [[FollowEntity alloc] initWithDictInfo:dictResponse];
            [g_Delegate.m_currentUser.m_arrFollowings addObject:newFollowEntity];
            
            nFollowTwoIndex = (int)g_Delegate.m_currentUser.m_arrFollowings.count - 1;
            
            [self.m_btnFollow2 setImage:[UIImage imageNamed:@"btn_cat_add_orange.png"] forState:UIControlStateNormal];
        }
    }

    if (nRequestMode == MASH_REQUEST)
    {
        NSArray* arrPhotos = [dictResponse valueForKey:@"mash"];
        CategoryEntity* categoryEntity = [[CategoryEntity alloc] initWithDictInfo:[dictResponse valueForKey:@"category"]];
        
        photoEntityOne = nil;
        photoEntityTwo = nil;
        
        bool bTwoPhotos = false;
        if (arrPhotos.count == 2)
        {
            bTwoPhotos = true;
            photoEntityOne = [[PhotoEntity alloc] initWithDictInfo:[arrPhotos firstObject]];
            photoEntityTwo = [[PhotoEntity alloc] initWithDictInfo:[arrPhotos lastObject]];
        }
        else if (arrPhotos.count == 1)
        {
            photoEntityOne = [[PhotoEntity alloc] initWithDictInfo:[arrPhotos firstObject]];
        }
        
        if (!bTwoPhotos)
        {
            if ([self.m_categoryEntity.m_strName isEqualToString:NSLocalizedString(@"category_random", nil)])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"game_dialog_title_no_photos", nil) message:NSLocalizedString(@"game_dialog_content_no_photos", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"game_dialog_positive_no_photos", nil), nil];
                alertView.tag = 100;
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"game_dialog_title_no_photos", nil) message:NSLocalizedString(@"game_dialog_content_no_photos", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"game_dialog_positive_no_photos_back", nil), nil];
                alertView.tag = 140;
                [alertView show];
            }
        }
        
        if ([self.m_categoryEntity.m_strName isEqualToString:NSLocalizedString(@"category_overall", nil)])
            self.navigationItem.title = categoryEntity.m_strName;
        else
            self.navigationItem.title = [NSString stringWithFormat:@"#%@", categoryEntity.m_strName];
        
        [self drawInfo];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)//random
    {
        [self performSelector:@selector(getMash) withObject:nil afterDelay:0.1f];
    }
    else if (alertView.tag == 140)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
