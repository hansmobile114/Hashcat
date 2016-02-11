//
//  LoginViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "LoginViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_viewInout.layer.cornerRadius = 5.f;
    self.m_viewInout.clipsToBounds = YES;
    
    self.m_txtEmail.delegate = self;
    self.m_txtPass.delegate = self;
    
    self.m_txtEmail.returnKeyType = UIReturnKeyNext;
    self.m_txtPass.returnKeyType = UIReturnKeyGo;
    
    [self activeTextField:0];
    
    FAKFontAwesome *naviBackIcon = [FAKFontAwesome arrowLeftIconWithSize:NAVI_ICON_SIZE];
    [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imgButton = [naviBackIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
    [self.m_btnBack setImage:[UIImage imageNamed:@"navi_back_icon.png"] forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.m_txtEmail)
    {
        [self.m_txtPass becomeFirstResponder];
        return YES;
    }
    else
    {
        [self doLoginProcess];
        return NO;
    }
}

- (void) activeTextField:(int) nIdx
{
    self.m_viewIndicatorEmail.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorPass.backgroundColor = [UIColor darkGrayColor];
    
    switch (nIdx) {
        case 1:
            self.m_viewIndicatorEmail.backgroundColor = MAIN_COLOR;
            break;
        case 2:
            self.m_viewIndicatorPass.backgroundColor = MAIN_COLOR;
            break;
        case 0:
            break;
        default:
            break;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtPass resignFirstResponder];
}

-(void)keyboardWillShow {
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    if (textField == self.m_txtEmail) {
        [self activeTextField:1];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -60, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = YES;
    }
    
    if (textField == self.m_txtPass) {
        [self activeTextField:2];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -90, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = YES;
    }
    
    return YES;
}

-(void)keyboardWillHide {
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    // Animate the current view back to its original position
    if (self.animated) {
        
        [self activeTextField:0];

        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, 0, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = NO;
    }
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

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionLogin:(id)sender {
    [self doLoginProcess];
}

- (void) doLoginProcess
{
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtPass resignFirstResponder];
    
    if (self.m_txtEmail.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_email_alert_title", nil)];
        return;
    }
    
    if (![[Utils sharedObject] validateEmail:self.m_txtEmail.text])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_valid_email_alert_title", nil)];
        return;
    }
    
    if (self.m_txtPass.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_password_alert_title", nil)];
        return;
    }
    
    [self showLoadingView];
    [FeedService logInWithUsername:self.m_txtEmail.text withPass:self.m_txtPass.text withPushID:g_Delegate.m_strDeviceToken withModel:DEVICE_MODEL withDelegate:self];
}

- (void) gotoHomeView
{
    NSMutableDictionary *dictSessionInfo = [[NSMutableDictionary alloc] init];
    [dictSessionInfo setValue:self.m_txtEmail.text forKey:@"username"];
    [dictSessionInfo setValue:self.m_txtPass.text forKey:@"password"];
    [dictSessionInfo setValue:g_Delegate.m_strDeviceToken forKey:@"pushId"];
    [dictSessionInfo setValue:@"userByEmail" forKey:@"loginmode"];
    
    [[UserDefaultHelper sharedObject] setFacebookLoginRequest:dictSessionInfo];
    
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
    [self hideLoadingView];

    NSString *receivedData = [request responseString];
    NSDictionary* dictResponse = [receivedData JSONValue];
    if (dictResponse == nil)
    {
        [g_Delegate AlertFailure:NSLocalizedString(@"signup_or_login_toast_error_login", nil)];
        return;
    }
    
    g_Delegate.m_currentUser = [[UserEntity alloc] initWithDictInfo:dictResponse];
    [self gotoHomeView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

@end
