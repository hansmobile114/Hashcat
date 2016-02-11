//
//  CreateCatViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CreateCatViewController.h"
#import "Global.h"
#import "FeedService.h"
#import "MenuTabViewController.h"

@interface CreateCatViewController ()

@end

@implementation CreateCatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.m_bViewMode)
    {
        self.navigationItem.title = NSLocalizedString(@"profile_add_title_create", nil);
        [self.m_btnCreate setTitle:NSLocalizedString(@"profile_add_label_new", nil) forState:UIControlStateNormal];
        
        nSelectedCountryId = -1;
        for (int nIdx = 0; nIdx < g_Delegate.m_arrCountries.count; nIdx++)
        {
            CountryEntity* countryEntity = [g_Delegate.m_arrCountries objectAtIndex:nIdx];
            if ([countryEntity.m_strName isEqualToString:g_Delegate.m_strCurCountryName])
            {
                nSelectedCountryId = countryEntity.m_nID;
                self.m_txtCountry.text = countryEntity.m_strName;
            }
        }
    }
    else
    {
        self.navigationItem.title = NSLocalizedString(@"profile_add_title_edit", nil);
        [self.m_btnCreate setTitle:NSLocalizedString(@"profile_add_button_edit", nil) forState:UIControlStateNormal];
        
        if (self.m_bReloadProfile)
        {
            nRequestMode = GET_PROFILE_REQUEST;
            [self showLoadingView];
            
            [FeedService getProfile:self.m_profileEntity.m_nId withUsername:self.m_profileEntity.m_strUsername withDelegate:self];

        }
        else
        {
            [self showCurrentInfo];
        }
    }
    
    UserEntity* entity = g_Delegate.m_currentUser;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.m_viewInout.layer.cornerRadius = 2.f;
    self.m_viewInout.clipsToBounds = YES;
    
    self.m_viewPicker.hidden = YES;
    [self activeTextField:0];
    
    bCurrentChooseField = false;
    
    arrayData = [[NSMutableArray alloc] init];
    self.m_pickerData.delegate = self;
    [self.m_pickerDate addTarget:self action:@selector(updateDOB:) forControlEvents:UIControlEventValueChanged];
    
    self.m_txtEmail.delegate = self;
    self.m_txtUsername.delegate = self;
    self.m_txtDescirption.delegate = self;
    
    self.m_txtEmail.returnKeyType = UIReturnKeyNext;
    self.m_txtUsername.returnKeyType = UIReturnKeyNext;
    self.m_txtDescirption.returnKeyType = UIReturnKeyDone;
    
    [self.m_txtUsername addTarget:self action:@selector(changedTextUserName:) forControlEvents:UIControlEventEditingChanged];

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
    
    avatarImage = nil;
    
    self.m_userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_userImage addGestureRecognizer:tapGesture];

}

- (void) showCurrentInfo
{
    [[Utils sharedObject] loadImageFromServerAndLocal:self.m_profileEntity.m_strCaminhoThumbnailLink imageView:self.m_userImage];
    
    avatarImage = nil;
    if (![self.m_profileEntity.m_strCaminhoThumbnailLink isKindOfClass:[NSNull class]])
        avatarImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString:self.m_profileEntity.m_strCaminhoThumbnailLink]]];

    self.m_txtEmail.text = self.m_profileEntity.m_strName;
    self.m_txtBirth.text = [[Utils sharedObject] DateToString:[[Utils sharedObject] getDateFromMilliSec:self.m_profileEntity.m_nBirthDate] withFormat:NSLocalizedString(@"time_format", nil)];
    self.m_strBirthTime = [NSString stringWithFormat:@"%lld", self.m_profileEntity.m_nBirthDate];
    
    self.m_txtUsername.text = [NSString stringWithFormat:@"@%@", self.m_profileEntity.m_strUsername];
    self.m_txtDescirption.text = self.m_profileEntity.m_strDescription;
    self.m_txtCountry.text = self.m_profileEntity.m_country.m_strName;
    self.m_txtBreed.text = self.m_profileEntity.m_breed.m_strName;
    
    nSelectedBreedId = self.m_profileEntity.m_breed.m_nID;
    nSelectedCountryId = self.m_profileEntity.m_country.m_nID;
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
        [self.m_txtDescirption becomeFirstResponder];
        return YES;
    }
    else
    {
        [self.m_txtDescirption resignFirstResponder];
        [self.m_txtUsername resignFirstResponder];
        [self.m_txtEmail resignFirstResponder];
        
        return NO;
    }
}

- (void) changedTextUserName:(UITextField *) txtField
{
    if (txtField.text.length == 0)
        txtField.text = @"@";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) updateDOB:(UIDatePicker *)datePicker
{
//    self.m_txtBirth.text = [[Utils sharedObject] DateToString:datePicker.date withFormat:@"yyyy-MM-dd"];
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

    float fRadius = 0.f;
    if (self.m_userImage.frame.size.width > self.m_userImage.frame.size.height)
        fRadius = self.m_userImage.frame.size.height / 2.f;
    else
        fRadius = self.m_userImage.frame.size.width / 2.f;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

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

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtDescirption resignFirstResponder];
    
    bCurrentChooseField = false;
    
    self.m_viewPicker.hidden = YES;
    
    [self activeTextField:0];
}

-(void)keyboardWillShow {
}

- (void) activeTextField:(int) nIdx
{
    self.m_viewIndicatorEmail.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorUsername.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorBreed.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorDescription.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorBirth.backgroundColor = [UIColor darkGrayColor];
    self.m_viewIndicatorCountry.backgroundColor = [UIColor darkGrayColor];
    
    switch (nIdx) {
        case 1:
            self.m_viewIndicatorEmail.backgroundColor = MAIN_COLOR;
            break;
        case 2:
            self.m_viewIndicatorUsername.backgroundColor = MAIN_COLOR;
            break;
        case 3:
            self.m_viewIndicatorBreed.backgroundColor = MAIN_COLOR;
            break;
        case 4:
            self.m_viewIndicatorDescription.backgroundColor = MAIN_COLOR;
            break;
        case 5:
            self.m_viewIndicatorBirth.backgroundColor = MAIN_COLOR;
            break;
        case 6:
            self.m_viewIndicatorCountry.backgroundColor = MAIN_COLOR;
            break;
        case 0:
            break;
        default:
            break;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    self.m_viewPicker.hidden = YES;
    
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
    
    if (textField == self.m_txtDescirption) {
        [self activeTextField:4];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -150, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = YES;
    }
    
    return YES;
}

-(void)keyboardWillHide {
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    self.m_viewPicker.hidden = YES;
    
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
    return [arrayData count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (nCurrentChooseField == CHOOSE_BREED)
    {
        BreedEntity* breedEntity = [arrayData objectAtIndex:row];
        return breedEntity.m_strName;
    }
    else
    {
        CountryEntity* countryEntity = [arrayData objectAtIndex:row];
        return countryEntity.m_strName;
    }

}

// Picker Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionChooseBreed:(id)sender {
    bCurrentChooseField = true;
    
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtDescirption resignFirstResponder];
    
    nCurrentChooseField = CHOOSE_BREED;
    arrayData = [g_Delegate.m_arrBreeds mutableCopy];
    self.m_pickerData.delegate = self;
    [self.m_pickerData reloadAllComponents];
    [self.m_pickerData selectRow:0 inComponent:0 animated:NO];
    
    self.m_viewPicker.hidden = NO;
    self.m_lblPickerTitle.title = NSLocalizedString(@"input_breed_alert_title", nil);
    self.m_pickerData.hidden = NO;
    self.m_pickerDate.hidden = YES;
    
    [self activeTextField:3];

}

- (IBAction)actionChooseBirth:(id)sender {
    bCurrentChooseField = true;
    
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtDescirption resignFirstResponder];
    
    nCurrentChooseField = CHOOSE_BIRTH;

    self.m_viewPicker.hidden = NO;
    self.m_lblPickerTitle.title = NSLocalizedString(@"input_dob_alert_title", nil);
    self.m_pickerDate.hidden = NO;
    self.m_pickerData.hidden = YES;
    
    [self.m_pickerDate setDate:[NSDate date]];
    
    [self activeTextField:5];

}

- (IBAction)actionChooseCountry:(id)sender {
    bCurrentChooseField = true;
    
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtUsername resignFirstResponder];
    [self.m_txtDescirption resignFirstResponder];
    
    nCurrentChooseField = CHOOSE_COUNTRY;
    arrayData = [g_Delegate.m_arrCountries mutableCopy];
    self.m_pickerData.delegate = self;
    [self.m_pickerData reloadAllComponents];

    [self.m_pickerData selectRow:0 inComponent:0 animated:NO];

    self.m_viewPicker.hidden = NO;
    self.m_lblPickerTitle.title = NSLocalizedString(@"input_country_alert_title", nil);
    self.m_pickerData.hidden = NO;
    self.m_pickerDate.hidden = YES;
    
    [self activeTextField:6];

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString* strBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:self.m_txtBirth.text withFormat:@"yyyy-MM-dd"]];
        
        NSRange range;
        range.location = 1; range.length = self.m_txtUsername.text.length - 1;
        NSString* strUserName = [self.m_txtUsername.text substringWithRange:range];
        
        NSMutableDictionary* dictRequest = [[NSMutableDictionary alloc] init];
        [dictRequest setValue:strUserName forKey:@"username"];
        [dictRequest setValue:self.m_txtEmail.text forKey:@"name"];
        [dictRequest setValue:self.m_txtDescirption.text forKey:@"description"];
        [dictRequest setValue:[NSString stringWithFormat:@"%d", nSelectedBreedId] forKey:@"breedId"];
        [dictRequest setValue:[NSString stringWithFormat:@"%d", nSelectedCountryId] forKey:@"countryId"];
        [dictRequest setValue:strBirthTime forKey:@"birth"];
        [dictRequest setValue:avatarImage forKey:@"thumbnailProfile"];
        
        [self showLoadingView];
        
        if (self.m_bViewMode)
        {
            nRequestMode = CREATE_PROFILE_REQUEST;
            [FeedService addProfile:dictRequest editing:@"false" profileId:-1 withDelegate:self];
        }
        else
        {
            nRequestMode = UPDAET_PROFILE_REQUEST;
            [FeedService addProfile:dictRequest editing:@"true" profileId:self.m_profileEntity.m_nId withDelegate:self];
        }

    }
    else if (buttonIndex == 1)
    {
        [self tapGesture];
    }
}

- (IBAction)actionCreate:(id)sender {
    if (self.m_txtEmail.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_name_alert_title", nil)];
        return;
    }
    
    if (self.m_txtUsername.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_username_alert_title", nil)];
        return;
    }
    
    if (self.m_txtDescirption.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_description_alert_title", nil)];
        return;
    }
    
    if (self.m_txtBreed.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_breed_alert_title", nil)];
        return;
    }
    
    if (self.m_txtBirth.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_dob_alert_title", nil)];
        return;
    }

    if (self.m_txtCountry.text.length == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_country_alert_title", nil)];
        return;
    }

    if (self.m_bViewMode)
    {
        if (!avatarImage)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"profile_add_dialog_title_no_photo", nil) message:NSLocalizedString(@"profile_add_dialog_content_no_photo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"profile_add_dialog_im_sure", nil) otherButtonTitles:NSLocalizedString(@"profile_add_dialog_choose_one", nil), nil];
            alertView.tag = 100;
            [alertView show];
            
            return;
        }
    }
    
    NSString* strBirthTime = [[Utils sharedObject] timeInMiliSeconds:[[Utils sharedObject] StringToDate:self.m_txtBirth.text withFormat:@"yyyy-MM-dd"]];

    NSRange range;
    range.location = 1; range.length = self.m_txtUsername.text.length - 1;
    NSString* strUserName = [self.m_txtUsername.text substringWithRange:range];
    
    NSMutableDictionary* dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:strUserName forKey:@"username"];
    [dictRequest setValue:self.m_txtEmail.text forKey:@"name"];
    [dictRequest setValue:self.m_txtDescirption.text forKey:@"description"];
    [dictRequest setValue:[NSString stringWithFormat:@"%d", nSelectedBreedId] forKey:@"breedId"];
    [dictRequest setValue:[NSString stringWithFormat:@"%d", nSelectedCountryId] forKey:@"countryId"];
    [dictRequest setValue:self.m_strBirthTime forKey:@"birth"];
    if (avatarImage)
        [dictRequest setValue:avatarImage forKey:@"thumbnailProfile"];

    [self showLoadingView];

    if (self.m_bViewMode)
    {
        nRequestMode = CREATE_PROFILE_REQUEST;
        [FeedService addProfile:dictRequest editing:@"false" profileId:-1 withDelegate:self];
    }
    else
    {
        nRequestMode = UPDAET_PROFILE_REQUEST;
        [FeedService addProfile:dictRequest editing:@"true" profileId:self.m_profileEntity.m_nId withDelegate:self];
    }
    
}

- (IBAction)actionChooseDone:(id)sender {
    self.m_viewPicker.hidden = YES;
    
    if (nCurrentChooseField == CHOOSE_BREED)
    {
        int row = (int)[self.m_pickerData selectedRowInComponent:0];
        BreedEntity* breedEntity = [arrayData objectAtIndex:row];
        self.m_txtBreed.text = breedEntity.m_strName;
        nSelectedBreedId = breedEntity.m_nID;
    }
    else if (nCurrentChooseField == CHOOSE_COUNTRY)
    {
        int row = (int)[self.m_pickerData selectedRowInComponent:0];
        CountryEntity* countryEntity = [arrayData objectAtIndex:row];
        self.m_txtCountry.text = countryEntity.m_strName;
        nSelectedCountryId = countryEntity.m_nID;
    }
    else
    {
        self.m_txtBirth.text = [[Utils sharedObject] DateToString:self.m_pickerDate.date withFormat:NSLocalizedString(@"time_format", nil)];
        self.m_strBirthTime = [[Utils sharedObject] timeInMiliSeconds:self.m_pickerDate.date];
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
    NSDictionary* dictResponse = [receivedData JSONValue];
    
    AppDelegate* del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ProfileEntity* newProfile = [[ProfileEntity alloc] initWithDictInfo:dictResponse];
    
    if (nRequestMode == CREATE_PROFILE_REQUEST)
        [g_Delegate.m_currentUser.m_arrProfiles addObject:newProfile];
    else if (nRequestMode == GET_PROFILE_REQUEST)
    {
        self.m_profileEntity = newProfile;
        [self showCurrentInfo];
        
        return;
    }
    else
        [g_Delegate.m_currentUser.m_arrProfiles replaceObjectAtIndex:self.m_nProfileIndexInUser withObject:newProfile];

    NSLog(@"%@", dictResponse);

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

@end
