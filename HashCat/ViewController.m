//
//  ViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "ViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "HomeViewController.h"
#import "SignupViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dictFBUserInfo = [[NSMutableDictionary alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) loginWithoutInput
{
    NSDictionary * dictSessionInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];

    nRequestMode = 4;
    
    [self showLoadingView];
    
    [FeedService logInWithUsername:[dictSessionInfo valueForKey:@"username"] withPass:[dictSessionInfo valueForKey:@"password"] withPushID:[dictSessionInfo valueForKey:@"pusId"] withModel:DEVICE_MODEL withDelegate:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) viewDidAppear:(BOOL)animated
{
    if (g_Delegate.m_bRegisterSuccess)
    {
        g_Delegate.m_bRegisterSuccess = false;
        [self loginWithoutInput];
        
        return;
    }
    
    if ([[UserDefaultHelper sharedObject] facebookLoginRequest])
    {
        if ([[[[UserDefaultHelper sharedObject] facebookLoginRequest] valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
            [self.m_btnFacebook setTitle:NSLocalizedString(@"settings_logout", nil) forState:UIControlStateNormal];
        
        [self loginWithoutInput];
    }
    else
    {
        [self.m_btnFacebook setTitle:[NSString stringWithFormat:@"   %@", NSLocalizedString(@"facebook_login_or_signup", nil)] forState:UIControlStateNormal];
    }

}

- (void) gotoHomeView
{
    [g_Delegate loadAllCountryBreedInfo];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    HomeViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"homeview"];
    
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
    NSString *receivedData = [request responseString];
    NSDictionary *dictResponse = [receivedData JSONValue];

    if (nRequestMode == 1) //userByFacebookId
    {
        if ([receivedData isEqualToString:@"0"])
        {
            [self hideLoadingView];
            [self signUpFBUser];
        }
        else
            [self loginFBUser];
        
        return;
    }

    if (dictResponse == nil)
    {
        [self hideLoadingView];
        [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
        
        if (nRequestMode == 2)
            [self.m_btnFacebook setTitle:[NSString stringWithFormat:@"   %@", NSLocalizedString(@"facebook_login_or_signup", nil)] forState:UIControlStateNormal];

        return;
    }

    if (nRequestMode == 2) //loginFBUser
    {
        [self hideLoadingView];
        
        g_Delegate.m_currentUser = [[UserEntity alloc] initWithDictInfo:dictResponse];

        [self gotoHomeView];

        return;
    }

    if (nRequestMode == 4) //loginWithoutAnyInput
    {
        [self hideLoadingView];

        g_Delegate.m_currentUser = [[UserEntity alloc] initWithDictInfo:dictResponse];

        [self gotoHomeView];
        
        return;
    }
    
    [self hideLoadingView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionFacebook:(id)sender {
    [self showLoadingView];

    if ([[FacebookUtility sharedObject]isLogin])
    {
        [self getFacebookUserDetails];
    }
    else
    {
        [self showLoadingView];
        
        [[FacebookUtility sharedObject].m_fbLoginManager logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                [self hideLoadingView];
                
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

-(void)getFacebookUserDetails
{
    //me?fields=id,birthday,gender,first_name,age_range,last_name,name,picture.type(normal)
    
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
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_FULL_NAME message:NSLocalizedString(@"signup_or_login_toast_error_connect", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                 alert.tag = 202;
                 [alert show];
             }
         }];
    }
    else{
        [self hideLoadingView];
    }
}

-(void)parseLogin :(NSDictionary*)FBUserDetailDict
{
    NSString *strAccessToken = [[FacebookUtility sharedObject] getFBToken];

    strUsername = [FBUserDetailDict valueForKey:@"id"];
    strPassword = strAccessToken;
    
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
    
    nRequestMode = 1;
    
    [FeedService userIdByFacebookId:[FBUserDetailDict valueForKey:@"id"] withDelegate:self];
}

- (void) signUpFBUser
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    SignupViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"signupview"];
    viewCon.m_dictFBInfo = dictFBUserInfo;
    viewCon.m_bCreateFBUser = true;
    viewCon.m_bViewMode = true;
    viewCon.m_strBirthTime = strFBUserBirthTime;
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void) loginFBUser
{
    nRequestMode = 2;
    
    [self.m_btnFacebook setTitle:@"Logout" forState:UIControlStateNormal];

    NSMutableDictionary *dictSesstionInfo = [[NSMutableDictionary alloc] init];
    [dictSesstionInfo setValue:strUsername forKey:@"username"];
    [dictSesstionInfo setValue:strPassword forKey:@"password"];
    [dictSesstionInfo setValue:g_Delegate.m_strDeviceToken forKey:@"pushId"];
    [dictSesstionInfo setValue:@"userByFB" forKey:@"loginmode"];
    
    [[UserDefaultHelper sharedObject] setFacebookLoginRequest:dictSesstionInfo];

    [FeedService logInWithUsername:strUsername withPass:strPassword withPushID:g_Delegate.m_strDeviceToken withModel:DEVICE_MODEL withDelegate:self];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSLog(@"%@", segue.identifier);
     
     if ([segue.identifier isEqualToString:@"signupview"])
     {
         SignupViewController* viewCon = (SignupViewController *)segue.destinationViewController;
         viewCon.m_bViewMode = true;
     }
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

@end
