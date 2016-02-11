//
//  SignupViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "SignupViewController.h"
#import "Global.h"
#import "FeedService.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void) repositionViews
{
    self.m_lblWarning.hidden = YES;
    float fDiff = self.m_viewInout.frame.origin.y - self.m_lblWarning.frame.origin.y;
    
    self.m_viewInout.frame = CGRectMake(self.m_viewInout.frame.origin.x, self.m_lblWarning.frame.origin.y, self.m_viewInout.frame.size.width, self.m_viewInout.frame.size.height);
    self.m_btnSignUp.frame = CGRectMake(self.m_btnSignUp.frame.origin.x, self.m_btnSignUp.frame.origin.y - fDiff, self.m_btnSignUp.frame.size.width, self.m_btnSignUp.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self.m_lblWarning setAdjustsFontSizeToFitWidth:YES];

    self.m_lblWarning.layer.cornerRadius = self.m_lblWarning.frame.size.height / 2.f;
    self.m_lblWarning.clipsToBounds = YES;
    
    self.m_lblWarning.textColor = NAVI_COLOR;
    self.m_lblWarning.text = NSLocalizedString(@"signup_reminder", nil);
    
    self.m_lblWarning.alpha = 1.f;
    //warning animation
    [UIView animateWithDuration:2.f
                          delay:0.2f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_lblWarning.alpha = 0.f;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1.f
                               delay:0.2f
                             options: UIViewAnimationOptionCurveEaseInOut
                          animations:^
          {
              self.m_lblWarning.alpha = 1.f;
          }
                          completion:^(BOOL finished)
          {
              [self performSelector:@selector(repositionViews) withObject:nil afterDelay:4.f];
          }];

     }];

    if (self.m_bViewMode)
    {
        [self.m_btnSignUp setTitle:NSLocalizedString(@"button_signup", nil) forState:UIControlStateNormal];
        
        FAKFontAwesome *naviBackIcon = [FAKFontAwesome arrowLeftIconWithSize:NAVI_ICON_SIZE];
        [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        UIImage *imgButton = [naviBackIcon imageWithSize:CGSizeMake(NAVI_ICON_SIZE, NAVI_ICON_SIZE)];
        [self.m_btnBack setImage:[UIImage imageNamed:@"navi_back_icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.m_btnBack.hidden = YES;
        
        [self.m_btnSignUp setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateNormal];
        self.navigationItem.backBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:YES];
        
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

        [[Utils sharedObject] loadImageFromServerAndLocal:self.m_userEntity.m_strAvatarUrl imageView:self.m_userImage];
        self.m_txtEmail.text = self.m_userEntity.m_strEmail;
        self.m_txtDOB.text = [[Utils sharedObject] DateToString:[[Utils sharedObject] getDateFromMilliSec:self.m_userEntity.m_nBirth] withFormat:NSLocalizedString(@"time_format", nil)];
        self.m_strBirthTime = [NSString stringWithFormat:@"%lld", self.m_userEntity.m_nBirth];
        
        if ([self.m_userEntity.m_strGender isKindOfClass:[NSNull class]])
           self.m_txtGender.text = @"";
        else
            self.m_txtGender.text = self.m_userEntity.m_strGender;
        
        self.m_txtPass.text = @"";
        NSDictionary* dictLoginInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
        NSString* strPass = @"";
        if ([[dictLoginInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
            strPass = [dictLoginInfo valueForKey:@"password"];
        else
            strPass = [dictLoginInfo valueForKey:@"password"];
        self.m_txtPass.text = strPass;
        self.m_txtPass.enabled = NO;
        
        self.m_txtUsername.text = [NSString stringWithFormat:@"@%@", self.m_userEntity.m_strUsername];
    }
    
    self.m_viewInout.layer.cornerRadius = 5.f;
    self.m_viewInout.clipsToBounds = YES;
    
    self.m_viewChoose.hidden = YES;
    [self activeTextField:0];
    
    bCurrentChooseField = false;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    arrayGender = [NSArray arrayWithObjects:NSLocalizedString(@"gender_male", nil), NSLocalizedString(@"gender_female", nil), NSLocalizedString(@"gender_other", nil), NSLocalizedString(@"gender_prefer_not", nil), nil];
    
    self.m_pickerData.delegate = self;
    [self.m_pickerDOB addTarget:self action:@selector(updateDOB:) forControlEvents:UIControlEventValueChanged];
    
    self.m_txtEmail.delegate = self;
    self.m_txtUsername.delegate = self;
    self.m_txtPass.delegate = self;
    
    self.m_txtEmail.returnKeyType = UIReturnKeyNext;
    self.m_txtUsername.returnKeyType = UIReturnKeyNext;
    self.m_txtPass.returnKeyType = UIReturnKeyDone;
    
    [self.m_txtUsername addTarget:self action:@selector(changedTextUserName:) forControlEvents:UIControlEventEditingChanged];
    
    avatarImage = nil;
    
    if(self.m_bCreateFBUser)
    {
        [[Utils sharedObject] loadImageFromServerAndLocal:[self.m_dictFBInfo valueForKey:@"picture"] imageView:self.m_userImage];
        
        self.m_txtDOB.text = [self.m_dictFBInfo valueForKey:@"birth"];
        self.m_txtEmail.text = [self.m_dictFBInfo valueForKey:@"email"];
        self.m_txtGender.text = [self.m_dictFBInfo valueForKey:@"gender"];
    }
    else
    {
        self.m_userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture setDelegate:self];
        [self.m_userImage addGestureRecognizer:tapGesture];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.m_txtEmail)
    {
        [self.m_txtUsername becomeFirstResponder];
        return YES;
    }
    else if (textField == self.m_txtUsername)
    {
        [self.m_txtPass becomeFirstResponder];
        return YES;
    }
    else
    {
        [self.m_txtUsername resignFirstResponder];
        [self.m_txtEmail resignFirstResponder];
        [self.m_txtPass resignFirstResponder];
        
        return NO;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void) backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) changedTextUserName:(UITextField *) txtField
{
    if (txtField.text.length == 0)
        txtField.text = @"@";
}

- (void) updateDOB:(UIDatePicker *)datePicker
{
//    self.m_txtDOB.text = [[Utils sharedObject] DateToString:datePicker.date withFormat:@"yyyy-MM-dd"];
}

- (void) tapGesture
{
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"input_photo_alert_title", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"camera_label_capture_image", nil),NSLocalizedString(@"camera_label_select_image", nil), nil];
    [as showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self chooseFromLibaray];
            break;
        case 2:
            break;
    }
}

- (void) openCamera {
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type])
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            type = UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [[picker navigationBar] setBarTintColor:NAVI_COLOR];
        [[picker navigationBar] setTintColor:[UIColor whiteColor]];
        [picker navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                      [UIColor whiteColor], UITextAttributeTextColor,
                                                      [UIColor grayColor], UITextAttributeTextShadowColor,
                                                      [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                      nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:picker animated:YES completion:nil];
        });
    }
}

- (void) chooseFromLibaray {
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:type])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [[picker navigationBar] setBarTintColor:NAVI_COLOR];
        [[picker navigationBar] setTintColor:[UIColor whiteColor]];
        [picker navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                      [UIColor whiteColor], UITextAttributeTextColor,
                                                      [UIColor grayColor], UITextAttributeTextShadowColor,
                                                      [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                      nil];

        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:picker animated:YES completion:nil];
        });

        /*
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover setPopoverContentSize:CGSizeMake(320, 320)];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [popover presentPopoverFromRect:self.m_userImage.bounds inView:self.m_userImage permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                self.popOver = popover;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:picker animated:YES completion:nil];
            });
        }
         */
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* selectedImage = [[info valueForKey:UIImagePickerControllerEditedImage] fixOrientation];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        selectedImage = [[Utils sharedObject] scaleAndCropImage:selectedImage toSize:CGSizeMake(320, 320)];
    else
        selectedImage = [[Utils sharedObject] scaleAndCropImage:selectedImage toSize:CGSizeMake(640, 640)];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    float fRadius = 0.f;
    if (self.m_userImage.frame.size.width > self.m_userImage.frame.size.height)
        fRadius = self.m_userImage.frame.size.height / 2.f;
    else
        fRadius = self.m_userImage.frame.size.width / 2.f;
    
    avatarImage = selectedImage;
    self.m_userImage.image = [[Utils sharedObject] makeRoundedImage:selectedImage radius:fRadius];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtPass resignFirstResponder];
    
    bCurrentChooseField = false;
    
    self.m_viewChoose.hidden = YES;
    
    [self activeTextField:0];
}

-(void)keyboardWillShow {
}

- (void) activeTextField:(int) nIdx
{
    self.m_viewIndicatorEmail.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorUsername.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorPass.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorGender.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorDOB.backgroundColor = [UIColor darkGrayColor];

    switch (nIdx) {
        case 1:
            self.m_viewIndicatorEmail.backgroundColor = MAIN_COLOR;
            break;
        case 2:
            self.m_viewIndicatorUsername.backgroundColor = MAIN_COLOR;
            break;
        case 3:
            self.m_viewIndicatorPass.backgroundColor = MAIN_COLOR;
            break;
        case 4:
            self.m_viewIndicatorGender.backgroundColor = MAIN_COLOR;
            break;
        case 5:
            self.m_viewIndicatorDOB.backgroundColor = MAIN_COLOR;
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
    
    bCurrentChooseField = false;
    
    if (textField == self.m_txtEmail) {
        [self activeTextField:1];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -60, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = YES;
    }

    if (textField == self.m_txtUsername) {
        if (textField.text.length == 0)
            textField.text = @"@";
        
        [self activeTextField:2];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -90, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = YES;
    }

    if (textField == self.m_txtPass) {
        [self activeTextField:3];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -120, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = YES;
    }
    
    return YES;
}

-(void)keyboardWillHide {
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    // Animate the current view back to its original position
    if (self.animated) {
        if (!bCurrentChooseField)
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
    [[UserDefaultHelper sharedObject] setFacebookLoginRequest:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    self.m_viewChoose.hidden = YES;
    
    if (self.m_pickerData.hidden == NO)
    {
        int row = (int)[self.m_pickerData selectedRowInComponent:0];
        self.m_txtGender.text = [arrayGender objectAtIndex:row];
    }
    else
    {
        self.m_txtDOB.text = [[Utils sharedObject] DateToString:self.m_pickerDOB.date withFormat:NSLocalizedString(@"time_format", nil)];
        self.m_strBirthTime = [[Utils sharedObject] timeInMiliSeconds:self.m_pickerDOB.date];
    }
}

- (IBAction)actionSignup:(id)sender {
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

    if (self.m_txtUsername.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_username_alert_title", nil)];
        return;
    }

    if (!self.m_bViewMode)
    {
        NSDictionary* dictLoginInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
        NSString* strPass = @"";
        if ([[dictLoginInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
            strPass = [dictLoginInfo valueForKey:@"userpassword"];
        else
        {
            strPass = [dictLoginInfo valueForKey:@"password"];
            
            if (![strPass isEqualToString:self.m_txtPass.text])
            {
                [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_correct_password_alert_title", nil)];
                return;
            }
        }
    }
    else
    {
        if (self.m_txtPass.text.length == 0)
        {
            [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_password_alert_title", nil)];
            return;
        }
    }
    
    /*
    if (self.m_txtGender.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_gender_alert_title", nil)];
        return;
    }
    
    if (self.m_txtDOB.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_dob_alert_title", nil)];
        return;
    }
    */
    
    [self showLoadingView];
    
    if (self.m_bCreateFBUser)
    {
        nRequestMode = 3;
        
        NSString* strBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:self.m_txtDOB.text withFormat:@"yyyy-MM-dd"]];
        
        NSRange range;
        range.location = 1; range.length = self.m_txtUsername.text.length - 1;
        NSString* strUserName = [self.m_txtUsername.text substringWithRange:range];

        NSMutableDictionary* dictRequest = [[NSMutableDictionary alloc] init];
        [dictRequest setValue:[self.m_dictFBInfo valueForKey:@"facebookId"] forKey:@"facebookId"];
        [dictRequest setValue:[self.m_dictFBInfo valueForKey:@"accessToken"] forKey:@"accessToken"];
        [dictRequest setValue:[self.m_dictFBInfo valueForKey:@"firstName"] forKey:@"firstName"];
        [dictRequest setValue:[self.m_dictFBInfo valueForKey:@"lastName"] forKey:@"lastName"];
        [dictRequest setValue:self.m_txtGender.text forKey:@"gender"];
        [dictRequest setValue:self.m_strBirthTime forKey:@"birth"];
        [dictRequest setValue:self.m_txtEmail.text forKey:@"email"];
        [dictRequest setValue:strUserName forKey:@"username"];
        [dictRequest setValue:self.m_txtPass.text forKey:@"password"];
        
        [FeedService signUpWithFB:dictRequest editing:@"false" withDelegate:self];
    }
    else
    {
        if (self.m_bViewMode)
        {
            nRequestMode = 1;
            [FeedService userIdByEmail:self.m_txtEmail.text withDelegate:self];
        }
        else
        {
            nRequestMode = 4;
            
            NSString* strBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:self.m_txtDOB.text withFormat:@"yyyy-MM-dd"]];
            
            NSRange range;
            range.location = 1; range.length = self.m_txtUsername.text.length - 1;
            NSString* strUserName = [self.m_txtUsername.text substringWithRange:range];
            
            NSMutableDictionary* dictUserInfo = [[NSMutableDictionary alloc] init];
            [dictUserInfo setValue:self.m_txtEmail.text forKey:@"email"];
            [dictUserInfo setValue:strUserName forKey:@"username"];
            
            NSDictionary* dictLoginInfo = [[UserDefaultHelper sharedObject] facebookLoginRequest];
            NSString* strPass = @"";
            if ([[dictLoginInfo valueForKey:@"loginmode"] isEqualToString:@"userByFB"])
            {
                strPass = [dictLoginInfo valueForKey:@"password"];
                [dictUserInfo setValue:[dictLoginInfo valueForKey:@"username"] forKey:@"facebookId"];
                [dictUserInfo setValue:strPass forKey:@"accessToken"];
                [dictUserInfo setValue:strPass forKey:@"password"];
                [dictUserInfo setValue:g_Delegate.m_currentUser.m_strFirstName forKey:@"firstName"];
                [dictUserInfo setValue:g_Delegate.m_currentUser.m_strLastName forKey:@"lastName"];
                [dictUserInfo setValue:self.m_txtGender.text forKey:@"gender"];
                [dictUserInfo setValue:self.m_strBirthTime forKey:@"birth"];
                [dictUserInfo setValue:self.m_userImage.image forKey:@"thumbnailProfile"];
                
                [FeedService signUpWithFB:dictUserInfo editing:@"true" withDelegate:self];

            }
            else
            {
                strPass = [dictLoginInfo valueForKey:@"password"];
                [dictUserInfo setValue:strPass forKey:@"password"];
                [dictUserInfo setValue:self.m_txtGender.text forKey:@"gender"];
                [dictUserInfo setValue:self.m_strBirthTime forKey:@"birth"];
                [dictUserInfo setValue:self.m_userImage.image forKey:@"thumbnailProfile"];
                
                [FeedService signUpWithEmail:dictUserInfo editing:@"true" withDelegate:self];
            }
        }
    }
}

- (void) signUpNormalUser
{
    if (!avatarImage)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"signup_dialog_title_no_photo", nil) message:NSLocalizedString(@"signup_add_dialog_content_no_photo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"profile_add_dialog_im_sure", nil) otherButtonTitles:NSLocalizedString(@"profile_add_dialog_choose_one", nil), nil];
        alertView.tag = 200;
        [alertView show];
        
        return;
    }
    
    nRequestMode = 2;
    
    NSString* strBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:self.m_txtDOB.text withFormat:@"yyyy-MM-dd"]];
    
    NSRange range;
    range.location = 1; range.length = self.m_txtUsername.text.length - 1;
    NSString* strUserName = [self.m_txtUsername.text substringWithRange:range];
    
    NSMutableDictionary* dictUserInfo = [[NSMutableDictionary alloc] init];
    [dictUserInfo setValue:self.m_txtEmail.text forKey:@"email"];
    [dictUserInfo setValue:strUserName forKey:@"username"];
    [dictUserInfo setValue:self.m_txtPass.text forKey:@"password"];
    if (self.m_txtGender.text.length != 0)
        [dictUserInfo setValue:self.m_txtGender.text forKey:@"gender"];
    
    if (![self.m_strBirthTime isEqualToString:@"0"])
        [dictUserInfo setValue:self.m_strBirthTime forKey:@"birth"];
    [dictUserInfo setValue:avatarImage forKey:@"thumbnailProfile"];
    
    [FeedService signUpWithEmail:dictUserInfo editing:@"false" withDelegate:self];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32.f;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayGender count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayGender objectAtIndex:row];
}

// Picker Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    self.m_txtGender.text = [arrayGender objectAtIndex:row];
}

- (IBAction)actionChooseGender:(id)sender {
    bCurrentChooseField = true;
    
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtPass resignFirstResponder];
    
    self.m_viewChoose.hidden = NO;
    self.m_lblChoose.title = NSLocalizedString(@"input_gender_alert_title", nil);
    self.m_pickerData.hidden = NO;
    self.m_pickerDOB.hidden = YES;
    
    [self activeTextField:4];
}

- (IBAction)actionChooseDOB:(id)sender {
    bCurrentChooseField = true;

    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtPass resignFirstResponder];
    
    self.m_viewChoose.hidden = NO;
    self.m_lblChoose.title = NSLocalizedString(@"input_dob_alert_title", nil);
    self.m_pickerData.hidden = YES;
    self.m_pickerDOB.hidden = NO;
    
    [self activeTextField:5];

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
    if (nRequestMode == 1)
    {
        if ([receivedData integerValue] == 0)
        {
            [self signUpNormalUser];
        }
        else
        {
            [self hideLoadingView];
            
            [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"email_already_exist_alert_title", nil)];
        }
        
        return;
    }
    
    if (nRequestMode == 4)
    {
        [self hideLoadingView];
        NSDictionary* dictResponse = [receivedData JSONValue];
        if (dictResponse == nil)
        {
            [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
            return;
        }
        
        UserEntity* updatedUserInfo = [[UserEntity alloc] initWithDictInfo:dictResponse];
        g_Delegate.m_currentUser.m_strEmail = updatedUserInfo.m_strEmail;
        g_Delegate.m_currentUser.m_strUsername = updatedUserInfo.m_strUsername;
        g_Delegate.m_currentUser.m_strGender = updatedUserInfo.m_strGender;
        g_Delegate.m_currentUser.m_nBirth = updatedUserInfo.m_nBirth;
        g_Delegate.m_currentUser.m_strAvatarUrl = updatedUserInfo.m_strAvatarUrl;
        g_Delegate.m_currentUser.m_strToken = updatedUserInfo.m_strToken;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (nRequestMode == 2 || nRequestMode == 3)
    {
        [self hideLoadingView];
        NSDictionary* dictResponse = [receivedData JSONValue];
        if (dictResponse == nil)
        {
            [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
            return;
        }

        if ( ([dictResponse allKeys].count == 1) && ([[dictResponse valueForKey:@"followingCount"] integerValue] == 0) )
        {
            [g_Delegate AlertFailure:NSLocalizedString(@"username_already_exist_alert_title", nil)];
        }
        else
        {
            NSMutableDictionary *dictSessionInfo = [[NSMutableDictionary alloc] init];

            if (self.m_bCreateFBUser)
            {
                [dictSessionInfo setValue:[self.m_dictFBInfo valueForKey:@"facebookId"] forKey:@"username"];
                [dictSessionInfo setValue:[self.m_dictFBInfo valueForKey:@"accessToken"] forKey:@"password"];
                [dictSessionInfo setValue:self.m_txtPass.text forKey:@"userpassword"];
                [dictSessionInfo setValue:g_Delegate.m_strDeviceToken forKey:@"pushId"];
                [dictSessionInfo setValue:@"userByFB" forKey:@"loginmode"];
            }
            else
            {
                [dictSessionInfo setValue:self.m_txtEmail.text forKey:@"username"];
                [dictSessionInfo setValue:self.m_txtPass.text forKey:@"password"];
                [dictSessionInfo setValue:g_Delegate.m_strDeviceToken forKey:@"pushId"];
                [dictSessionInfo setValue:@"userByEmail" forKey:@"loginmode"];
            }
            
            [[UserDefaultHelper sharedObject] setFacebookLoginRequest:dictSessionInfo];

            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:SUCCESS_STRING message:NSLocalizedString(@"wizard_welcome_to_hashcat", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            alertView.tag = 300;
            [alertView show];
        }
        
        return;
    }
    
    [self hideLoadingView];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 300)
    {
        g_Delegate.m_bRegisterSuccess = true;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 200)
    {
        if (buttonIndex == 0)
        {
            nRequestMode = 2;
            
            NSString* strBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:self.m_txtDOB.text withFormat:@"yyyy-MM-dd"]];
            
            NSRange range;
            range.location = 1; range.length = self.m_txtUsername.text.length - 1;
            NSString* strUserName = [self.m_txtUsername.text substringWithRange:range];
            
            NSMutableDictionary* dictUserInfo = [[NSMutableDictionary alloc] init];
            [dictUserInfo setValue:self.m_txtEmail.text forKey:@"email"];
            [dictUserInfo setValue:strUserName forKey:@"username"];
            [dictUserInfo setValue:self.m_txtPass.text forKey:@"password"];
            if (self.m_txtGender.text.length != 0)
                [dictUserInfo setValue:self.m_txtGender.text forKey:@"gender"];
            
            if (![strBirthTime isEqualToString:@"0"])
                [dictUserInfo setValue:strBirthTime forKey:@"birth"];
            [dictUserInfo setValue:avatarImage forKey:@"thumbnailProfile"];
            
            [FeedService signUpWithEmail:dictUserInfo editing:@"false" withDelegate:self];

        }
        else
        {
            [self hideLoadingView];
            
            [self tapGesture];
        }
    }
    
}

@end
