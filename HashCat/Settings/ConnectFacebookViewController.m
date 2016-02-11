//
//  ConnectFacebookViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "ConnectFacebookViewController.h"
#import "Global.h"
#import "FeedService.h"

@interface ConnectFacebookViewController ()

@end

@implementation ConnectFacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"signup_or_login_dialog_title_connect_facebook", nil);
    bLogin = true;
    
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

    [self.m_btnConnectFB setTitle:NSLocalizedString(@"facebook_connect", nil) forState:UIControlStateNormal];

    if ([[UserDefaultHelper sharedObject] facebookUserDetail])
    {
        bLogin = false;
        [self.m_btnConnectFB setTitle:NSLocalizedString(@"settings_logout", nil) forState:UIControlStateNormal];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionConnectFacebook:(id)sender {
    if (bLogin)
    {
        if ([[FacebookUtility sharedObject]isLogin])
        {
            [self getFacebookUserDetails];
        }
        else
        {
            [self showLoadingView];
            
            [[FacebookUtility sharedObject].m_fbLoginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                [self hideLoadingView];
                if (error)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_FULL_NAME message:NSLocalizedString(@"signup_or_login_toast_error_connect", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                    alert.tag = 202;
                    [alert show];
                }
                else
                {
                    if(result.token)
                    {
                        [self performSelector:@selector(getFacebookUserDetails) withObject:nil afterDelay:0.3f];
                    }
                }
            }];
            
        }
    }
    else
    {
        [[FacebookUtility sharedObject]logoutFromFacebook];
        [[UserDefaultHelper sharedObject] setFacebookUserDetail:nil];

        bLogin = true;
        [self.m_btnConnectFB setTitle:NSLocalizedString(@"facebook_connect", nil) forState:UIControlStateNormal];
    }
}

-(void)getFacebookUserDetails
{
    //me?fields=id,birthday,gender,first_name,age_range,last_name,name,picture.type(normal)
    [self showLoadingView];
    
    if ([[FacebookUtility sharedObject]isLogin]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:@{@"fields": @"id,birthday,gender,email,first_name,age_range,last_name,name,picture.type(normal)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 [[UserDefaultHelper sharedObject] setFacebookUserDetail:[NSMutableDictionary dictionaryWithDictionary:result]];
                 [self parseLogin:result];
             }
             else{
                 [self hideLoadingView];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 alert.tag = 202;
                 [alert show];
             }
         }];
    }
    else{
        [self hideLoadingView];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)parseLogin :(NSDictionary*)FBUserDetailDict
{
    NSString *strAccessToken = [[FacebookUtility sharedObject] getFBToken];
    
    NSMutableDictionary* dictFBUserInfo = [[NSMutableDictionary alloc] init];

    NSDate* dateFBUserBirth = [[Utils sharedObject] StringToDate:[FBUserDetailDict valueForKey:@"birthday"] withFormat:@"MM/dd/yyyy"];
    NSString* strBirth = [[Utils sharedObject] DateToString:dateFBUserBirth withFormat:NSLocalizedString(@"time_format", nil)];
    strFBUserBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:[FBUserDetailDict valueForKey:@"birthday"] withFormat:@"MM/dd/yyyy"]];
    
    NSString* strProfileLink = [[[FBUserDetailDict valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
    [dictFBUserInfo setValue:[FBUserDetailDict valueForKey:@"id"] forKey:@"facebookId"];
    [dictFBUserInfo setValue:strAccessToken forKey:@"accessToken"];
    [dictFBUserInfo setValue:[FBUserDetailDict valueForKey:@"first_name"] forKey:@"firstName"];
    [dictFBUserInfo setValue:[FBUserDetailDict valueForKey:@"last_name"] forKey:@"lastName"];
    [dictFBUserInfo setValue:[FBUserDetailDict valueForKey:@"gender"] forKey:@"gender"];
    [dictFBUserInfo setValue:strBirth forKey:@"birth"];
    [dictFBUserInfo setValue:[FBUserDetailDict valueForKey:@"email"] forKey:@"email"];
    [dictFBUserInfo setValue:strProfileLink forKey:@"picture"];

    [[UserDefaultHelper sharedObject] setFacebookUserDetail:dictFBUserInfo];

    NSString* strReconnecting = @"false";
    NSString* strPassword = @"";
    NSDictionary* dictLoginInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
    
    strPassword = [dictLoginInfo valueForKey:@"password"];

    if ([[dictLoginInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
        strReconnecting = @"true";

    [FeedService connectFacebook:[FBUserDetailDict valueForKey:@"email"] withFacebookId:[FBUserDetailDict valueForKey:@"id"] withAccessToken:strAccessToken withPassword:strPassword withReconnecting:strReconnecting withDelegate:self];
    
    /*
    bLogin = false;
    [self.m_btnConnectFB setTitle:NSLocalizedString(@"settings_logout", nil) forState:UIControlStateNormal];
    
    [self.navigationController popViewControllerAnimated:YES];
     */
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
    
    g_Delegate.m_currentUser = [[UserEntity alloc] initWithDictInfo:dictResponse];

    bLogin = false;
    [self.m_btnConnectFB setTitle:NSLocalizedString(@"settings_logout", nil) forState:UIControlStateNormal];
    
    [self.navigationController popViewControllerAnimated:YES];

    NSLog(@"...");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
}


@end
