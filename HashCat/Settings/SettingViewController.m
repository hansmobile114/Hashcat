//
//  SettingViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "SettingViewController.h"
#import "Global.h"
#import "UserProfileViewController.h"
#import "CatProfileManageViewController.h"
#import "SuggestionsViewController.h"
#import "BadgeListViewController.h"
#import "ConnectFacebookViewController.h"
#import "MenuTabViewController.h"
#import "FeedService.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"settings_action_settings", nil);
    
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
    
    self.m_txtOldPassword.delegate = self;
    self.m_txtNewPassword.delegate = self;
    self.m_txtNewPassConfirmation.delegate = self;

    self.m_txtOldPassword.returnKeyType = UIReturnKeyNext;
    self.m_txtNewPassword.returnKeyType = UIReturnKeyNext;
    self.m_txtNewPassConfirmation.returnKeyType = UIReturnKeyDone;
    
    self.m_viewSubView.layer.cornerRadius = 5.f;
    self.m_viewSubView.clipsToBounds = YES;

    self.m_tableView.dataSource = self;
    self.m_tableView.delegate = self;
    
    NSArray* arrayTitle1 = [NSArray arrayWithObjects:NSLocalizedString(@"settings_find_friends", nil), NSLocalizedString(@"settings_invite_friends", nil), nil];
    NSArray* arrayTitle2 = [NSArray arrayWithObjects:NSLocalizedString(@"settings_badges", nil), NSLocalizedString(@"settings_my_profile", nil), NSLocalizedString(@"settings_my_cats_profiles", nil), NSLocalizedString(@"settings_change_password", nil), NSLocalizedString(@"settings_link_facebook", nil), NSLocalizedString(@"settings_logout", nil), nil];
    NSArray* arrayTitle3 = [NSArray arrayWithObjects:NSLocalizedString(@"settings_notifications", nil), NSLocalizedString(@"settings_notifications_sound", nil), NSLocalizedString(@"settings_save_to_gallery", nil), nil];
    NSArray* arrayTitle4 = [NSArray arrayWithObjects:NSLocalizedString(@"settings_feedback", nil), NSLocalizedString(@"settings_about_us", nil), NSLocalizedString(@"settings_verde_apps", nil), NSLocalizedString(@"settings_thanks", nil), NSLocalizedString(@"settings_licenses", nil), NSLocalizedString(@"settings_version", nil), nil];
    
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSArray* arrayDetail1 = [NSArray arrayWithObjects:@"", @"", nil];
    NSArray* arrayDetail2 = [NSArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", nil];
    NSArray* arrayDetail3 = [NSArray arrayWithObjects:NSLocalizedString(@"settings_receive_notifications_action", nil), NSLocalizedString(@"settings_notifications_sound_summary", nil), NSLocalizedString(@"settings_save_photos_taken", nil), nil];
    NSArray* arrayDetail4 = [NSArray arrayWithObjects:NSLocalizedString(@"settings_feedback", nil), @"", @"", @"", @"", build, nil];
    
    NSDictionary* dict1 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"settings_friends", nil), arrayTitle1, arrayDetail1, nil] forKeys:[NSArray arrayWithObjects:@"section", @"titles", @"details", nil]];
    NSDictionary* dict2 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"settings_account", nil), arrayTitle2, arrayDetail2, nil] forKeys:[NSArray arrayWithObjects:@"section", @"titles", @"details", nil]];
    NSDictionary* dict3 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"settings_settings", nil), arrayTitle3, arrayDetail3, nil] forKeys:[NSArray arrayWithObjects:@"section", @"titles", @"details", nil]];
    NSDictionary* dict4 = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSLocalizedString(@"settings_about", nil), arrayTitle4, arrayDetail4, nil] forKeys:[NSArray arrayWithObjects:@"section", @"titles", @"details", nil]];
    
    //[[UITableViewHeaderFooterView appearance] setTintColor:[UIColor grayColor]];
    if (!g_Delegate.m_bHasBottomBar)
        self.m_tableView.frame = CGRectMake(self.m_tableView.frame.origin.x, self.m_tableView.frame.origin.y, self.m_tableView.frame.size.width, self.m_tableView.frame.size.height + MENU_TAB_HEIGHT);

    arrayDict = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4, nil];
    
    [self.m_tableView reloadData];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.m_txtOldPassword == textField)
    {
        [self.m_txtNewPassword becomeFirstResponder];
        return YES;
    }
    else if (textField == self.m_txtNewPassword)
    {
        [self.m_txtNewPassConfirmation becomeFirstResponder];
        return YES;
    }
    else
    {
        [self changePasswordProcess];
        
        return NO;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = NAVI_COLOR;
    self.navigationController.navigationBar.translucent = NO;
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
    [self.m_txtOldPassword resignFirstResponder];
    [self.m_txtNewPassword resignFirstResponder];
    [self.m_txtNewPassConfirmation resignFirstResponder];
    
    [self activeTextField:0];
}

-(void)keyboardWillShow {
}

- (void) activeTextField:(int) nIdx
{
    self.m_viewIndicatorOldPassword.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorNewPassword.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorNewPassConfirm.backgroundColor = [UIColor darkGrayColor];
    
    switch (nIdx) {
        case 1:
            self.m_viewIndicatorOldPassword.backgroundColor = MAIN_COLOR;
            break;
        case 2:
            self.m_viewIndicatorNewPassword.backgroundColor = MAIN_COLOR;
            break;
        case 3:
            self.m_viewIndicatorNewPassConfirm.backgroundColor = MAIN_COLOR;
            break;
        case 0:
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    if (textField == self.m_txtOldPassword) {
        [self activeTextField:1];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, 10, rectScreen.size.width, rectScreen.size.height - 64);
        }];
        self.animated = YES;
    }
    
    if (textField == self.m_txtNewPassword) {
        [self activeTextField:2];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -20, rectScreen.size.width, rectScreen.size.height - 64);
        }];
        self.animated = YES;
    }
    
    if (textField == self.m_txtNewPassConfirmation) {
        [self activeTextField:3];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -40, rectScreen.size.width, rectScreen.size.height - 64);
        }];
        self.animated = YES;
    }
    
    return YES;
}

-(void)keyboardWillHide {
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    // Animate the current view back to its original position
    if (self.animated) {
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, 64, rectScreen.size.width, rectScreen.size.height - 64);
        }];
        self.animated = NO;
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

- (void) switchValueChanged:(id) sender
{
    UISwitch* switchSetting = (UISwitch *)sender;

    if ([switchSetting.accessibilityLabel isEqualToString:NOTIFICATION_SETTING])
        [[Utils sharedObject] saveSettings:NOTIFICATION_SETTING value:switchSetting.on];

    if ([switchSetting.accessibilityLabel isEqualToString:NOTIFICATION_MENOW])
        [[Utils sharedObject] saveSettings:NOTIFICATION_MENOW value:switchSetting.on];

    if ([switchSetting.accessibilityLabel isEqualToString:SAVE_PHOTOS_SETTING])
        [[Utils sharedObject] saveSettings:SAVE_PHOTOS_SETTING value:switchSetting.on];

}

-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        UIView* content = castView.contentView;
        UIColor* color = [UIColor whiteColor]; // substitute your color here
        content.backgroundColor = color;
        
        NSString* strTitle = [[arrayDict objectAtIndex:(int)section] valueForKey:@"section"];
        [castView.textLabel setTextColor:MAIN_COLOR];
        castView.textLabel.font = [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:14.f];//[UIFont boldSystemFontOfSize:12.0];
        
        castView.textLabel.text = strTitle;
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nRowCnt = (int)((NSArray *)[[arrayDict objectAtIndex:(int)section] valueForKey:@"titles"]).count;
    return nRowCnt;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayDict.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 NSString* strTitle = [[arrayDict objectAtIndex:(int)section] valueForKey:@"section"];
 return  strTitle;
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingcell";

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    UILabel* lblName = (UILabel *)[cell viewWithTag:10];
    UILabel* lblDescription = (UILabel *)[cell viewWithTag:11];
    UISwitch* switchSetting = (UISwitch *)[cell viewWithTag:12];
    
    switchSetting.center = CGPointMake(self.view.frame.size.width - 10.f - switchSetting.frame.size.width / 2, 40.f);
    
    lblDescription.hidden = YES;
    
    switchSetting.hidden = YES;
    if (indexPath.section == 2)
    {
        switchSetting.hidden = NO;

        if (indexPath.row == 0)
        {
            [switchSetting setOn:[[Utils sharedObject] loadSettings:NOTIFICATION_SETTING]];
            switchSetting.accessibilityLabel = NOTIFICATION_SETTING;
            [switchSetting addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        }

        if (indexPath.row == 1)
        {
            [switchSetting setOn:[[Utils sharedObject] loadSettings:NOTIFICATION_MENOW]];
            switchSetting.accessibilityLabel = NOTIFICATION_MENOW;
            [switchSetting addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        }

        if (indexPath.row == 2)
        {
            [switchSetting setOn:[[Utils sharedObject] loadSettings:SAVE_PHOTOS_SETTING]];
            switchSetting.accessibilityLabel = SAVE_PHOTOS_SETTING;
            [switchSetting addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        }

    }
    
    lblName.text = [[[arrayDict objectAtIndex:indexPath.section] valueForKey:@"titles"] objectAtIndex:indexPath.row];
    [lblName sizeToFit];
    lblName.center = CGPointMake(lblName.center.x, 30.f);
    
    NSString* strDetailText = [[[arrayDict objectAtIndex:indexPath.section] valueForKey:@"details"] objectAtIndex:indexPath.row];
    if (strDetailText.length > 0)
    {
        lblDescription.hidden = NO;

        lblDescription.text = [[[arrayDict objectAtIndex:indexPath.section] valueForKey:@"details"] objectAtIndex:indexPath.row];
        
        [lblDescription sizeToFit];
        lblDescription.center = CGPointMake(lblDescription.center.x, 60.f);
    }
    else
        lblName.center = CGPointMake(lblName.center.x, 40.f);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                [self findFriends];
                break;
            case 1:
                [self inviteFriends];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                [self showBadges];
                break;
            case 1:
                [self showMyProfile];
                break;
            case 2:
                [self showMyCatsProfile];
                break;
            case 3:
                [self showChangePassword];
                break;
            case 4:
                [self facebookAccount];
                break;
            case 5:
                [self logOut];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
                [self setNotifications];
                break;
            case 1:
                [self setNotificationMeow];
                break;
            case 2:
                [self saveMyPhotosToGallery];
                break;
            default:
                break;
                
        }
    }

    else if (indexPath.section == 3)
    {
        switch (indexPath.row) {
            case 0:
                [self sendEMail];
                break;
            case 1:
                [self aboutUs];
                break;
            case 2:
                [self verdeApps];
                break;
            case 3:
                [self thanks];
                break;
            case 4:
                [self openSourceLicenses];
                break;
            case 5:
                [self version];
                break;
            default:
                break;

        }
    }
}

- (void) findFriends
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];

    SuggestionsViewController*viewCon = [storyboard instantiateViewControllerWithIdentifier:@"suggestionsview"];
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) inviteFriends
{
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[NSLocalizedString(@"share_message", nil), [UIImage imageNamed:@"hashcat_logo.png"]]
     applicationActivities:nil];

    [self presentViewController:activityController animated:YES completion:nil];
}

- (void) showBadges
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];

    BadgeListViewController*viewCon = [storyboard instantiateViewControllerWithIdentifier:@"badgelistview"];
    [self.navigationController pushViewController:viewCon animated:YES];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) showMyProfile
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    UserProfileViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
    
    viewCon.m_bMyProfile = true;
    
    viewCon.m_nUserId = g_Delegate.m_currentUser.m_nID;
    
    [self.navigationController pushViewController:viewCon animated:YES];

}


- (void) showMyCatsProfile
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    CatProfileManageViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"catmanageview"];

    [self.navigationController pushViewController:viewCon animated:YES];

}

- (void) showChangePassword
{
    self.m_viewChangePassword.hidden = NO;
    self.m_txtNewPassConfirmation.text = @"";
    self.m_txtNewPassword.text = @"";
    self.m_txtOldPassword.text = @"";

}

- (void) facebookAccount
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    ConnectFacebookViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"facebookview"];
    
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void) logOut
{
    [[FacebookUtility sharedObject]logoutFromFacebook];
    [[UserDefaultHelper sharedObject] setFacebookLoginRequest:nil];
    
    [g_Delegate.m_curMenuTabViewCon.navigationController popToRootViewControllerAnimated:YES];
}

- (void) setNotifications
{
    
}

- (void) setNotificationMeow
{
    
}

- (void) saveMyPhotosToGallery
{
    
}

-  (void) sendEMail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [[picker navigationBar] setBarTintColor:NAVI_COLOR];
    [picker navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:20.f], UITextAttributeFont,
                                                  [UIColor whiteColor], UITextAttributeTextColor,
                                                  [UIColor grayColor], UITextAttributeTextShadowColor,
                                                  [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                  nil];

    // Set the subject of email
    [picker setSubject:NSLocalizedString(@"email_activity_title", nil)];
    
    [picker setToRecipients:[NSArray arrayWithObjects:@"contato@verdesource.som.br", nil]];
    //    [picker setCcRecipients:[NSArray arrayWithObject:@"emailaddress3@domainName.com"]];
    //    [picker setBccRecipients:[NSArray arrayWithObject:@"emailaddress4@domainName.com"]];
    [picker setMessageBody:[NSString stringWithFormat:@"iOS Version : %@\r\nDevice Model : %@\r\n", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model]] isHTML:NO];
    
    // Show email view
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:picker animated:YES completion:nil];
    });
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Called once the email is sent
    // Remove the email view controller
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void) aboutUs
{
    
}

- (void) verdeApps
{
    
}

- (void) openSourceLicenses
{
    
}

- (void) version
{
    
}

- (void) thanks
{
    
}

- (IBAction)actionChange:(id)sender {
    [self changePasswordProcess];
}

- (void) changePasswordProcess
{
    [self.m_txtOldPassword resignFirstResponder];
    [self.m_txtNewPassword resignFirstResponder];
    [self.m_txtNewPassConfirmation resignFirstResponder];
    
    [self activeTextField:0];
    
    NSDictionary * dictSessionInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
    
    if (self.m_txtOldPassword.text.length == 0 || [self.m_txtOldPassword.text isEqualToString:@""])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_old_password_alert_title", nil)];
        self.m_txtOldPassword.text = @"";
        return;
    }
    
    NSString* strOldPassword = @"";
    if ([[dictSessionInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
        strOldPassword = [dictSessionInfo valueForKey:@"userpassword"];
    else
        strOldPassword = [dictSessionInfo valueForKey:@"password"];
    
    if (![strOldPassword isEqualToString:self.m_txtOldPassword.text])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_correct_old_password_alert_title", nil)];
        self.m_txtOldPassword.text = @"";
        return;
    }
    
    if (self.m_txtNewPassword.text.length == 0 || [self.m_txtNewPassword.text isEqualToString:@""])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_new_password_alert_title", nil)];
        return;
    }
    
    if (self.m_txtNewPassConfirmation.text.length == 0 || [self.m_txtNewPassConfirmation.text isEqualToString:@""])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_confirm_new_password_alert_title", nil)];
        return;
    }
    
    if (![self.m_txtNewPassConfirmation.text isEqualToString:self.m_txtNewPassword.text])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_check_new_password_again_alert_title", nil)];
        self.m_txtNewPassConfirmation.text = @"";
        return;
    }
    
    [self showLoadingView];
    [FeedService changePasswordWithEmail:g_Delegate.m_currentUser.m_strEmail withOldPass:self.m_txtOldPassword.text withNewPass:self.m_txtNewPassword.text withDelegate:self];
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

- (IBAction)actionCancel:(id)sender {
    [self.m_txtOldPassword resignFirstResponder];
    [self.m_txtNewPassword resignFirstResponder];
    [self.m_txtNewPassConfirmation resignFirstResponder];
    
    [self activeTextField:0];

    self.m_viewChangePassword.hidden = YES;
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
    
    [g_Delegate AlertSuccess:NSLocalizedString(@"change_password_toast_changed", nil)];
    
    NSMutableDictionary * dictSessionInfo = [[[UserDefaultHelper sharedObject] facebookLoginRequest] mutableCopy];
    [dictSessionInfo setValue:self.m_txtNewPassword.text forKey:@"password"];
    [[UserDefaultHelper sharedObject] setFacebookLoginRequest:dictSessionInfo];

    self.m_viewChangePassword.hidden = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

@end
