//
//  FeedPostViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "FeedPostViewController.h"
#import "Global.h"
#import "MenuTabViewController.h"
#import "FeedService.h"
#import "MenuTabViewController.h"

@interface FeedPostViewController ()

@end

@implementation FeedPostViewController
#pragma mark - This is what you are looking for:
-(AKTagsInputView*)createTagsInputView
{
    _tagsInputView = [[AKTagsInputView alloc] initWithFrame:CGRectMake(0, 0, self.m_viewTag.frame.size.width, 44.0f)];
    _tagsInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tagsInputView.lookupTags = @[@"#lazy", @"#cute", @"#likeABoss", @"#scary", @"#funny", @"#kitten", @"#crossedEyed", @"#fatty", @"#grumpy", @"#wet", @"#fancy", @"#messy", @"#selfie", @"#photobomber"];
    
    NSMutableArray* arrayTags = [[NSMutableArray alloc] init];
    _tagsInputView.selectedTags = arrayTags;
    _tagsInputView.enableTagsLookup = YES;
    return _tagsInputView;
}

-(void)tagsInputViewDidAddTag:(AKTagsInputView*)inputView
{
    NSString* strTags = [_tagsInputView.selectedTags componentsJoinedByString:@","];
    NSLog(@"%@", strTags);
}

-(void)tagsInputViewDidRemoveTag:(AKTagsInputView*)inputView
{
    NSString* strTags = [_tagsInputView.selectedTags componentsJoinedByString:@","];
    NSLog(@"%@", strTags);
}

- (void) alertExceedLimitedTags:(AKTagsInputView *)inputView
{
    [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"take_photo_toast_max_categories", nil)];
}

-(void)tagsInputViewDidBeginEditing:(AKTagsInputView*)inputView
{
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    [UIView animateWithDuration:0.3f animations:^ {
        self.view.frame = CGRectMake(0, -60, rectScreen.size.width, rectScreen.size.height);
    }];
    self.animated = YES;
}

-(void)tagsInputViewDidEndEditing:(AKTagsInputView*)inputView
{
    [self keyboardWillHide];
}

- (void) limitSelectCell:(JCTagListView *)tagListView
{
    [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"take_photo_toast_max_categories", nil)];
}

- (void) repositionViews
{
    self.m_lblWarning.hidden = YES;
    
    self.m_viewPostInfo.frame = CGRectMake(self.m_viewPostInfo.frame.origin.x, self.m_lblWarning.frame.origin.y, self.m_viewPostInfo.frame.size.width, self.m_viewPostInfo.frame.size.height);
}

- (void) showWarningAnimations:(NSString *) strCatName
{
    self.m_lblWarning.textColor = [UIColor whiteColor];
    self.m_lblWarning.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"take_photo_label_posting_as", nil), strCatName, NSLocalizedString(@"take_photo_label_change", nil)];
    
    self.m_lblWarning.alpha = 1.f;
    
    self.m_lblWarning.hidden = NO;
    
    self.m_viewPostInfo.frame = CGRectMake(self.m_viewPostInfo.frame.origin.x, self.m_lblWarning.frame.origin.y + self.m_lblWarning.frame.size.height, self.m_viewPostInfo.frame.size.width, self.m_viewPostInfo.frame.size.height);

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
              [UIView animateWithDuration:2.f
                                    delay:0.2f
                                  options: UIViewAnimationOptionCurveEaseInOut
                               animations:^
               {
                   self.m_lblWarning.alpha = 0.f;
               }
                               completion:^(BOOL finished)
               {
                   [UIView animateWithDuration:2.f
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
          }];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"take_photo_button_post", nil);
//    [self makeCustomNavigationBar];
    
    arrCategoryList = [[NSMutableArray alloc] init];
    for (int nIdx = 0; nIdx < g_Delegate.m_arrGameCategories.count; nIdx++)
    {
        GameCategoryEntity* entity = [g_Delegate.m_arrGameCategories objectAtIndex:nIdx];
        if (entity.m_bSelectable)
            [arrCategoryList addObject:entity];
    }
    
    [self repositionViews];
    
    self.m_viewTag.canRemoveTags = YES;
    self.m_viewTag.delegate = self;
    [self.m_viewTag.tags addObjectsFromArray:arrCategoryList];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    self.m_txtPost.delegate = self;
    self.m_txtPost.text = POST_TEXT_PLACEHOLDER;
    self.m_txtPost.textColor = [UIColor lightGrayColor];
    
    self.m_postImageView.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_postImageView.layer.borderWidth = 2.f;
    self.m_postImageView.clipsToBounds = YES;

    CGPoint fOriginCenter = CGPointZero;
    fOriginCenter = self.m_profileImageView.center;
    if (self.m_profileImageView.frame.size.width > self.m_profileImageView.frame.size.height)
        self.m_profileImageView.frame = CGRectMake(0, 0, self.m_profileImageView.frame.size.height, self.m_profileImageView.frame.size.height);
    else
        self.m_profileImageView.frame = CGRectMake(0, 0, self.m_profileImageView.frame.size.width, self.m_profileImageView.frame.size.width);
    self.m_profileImageView.center = fOriginCenter;

    fOriginCenter = self.m_bgProfileImageView.center;
    if (self.m_bgProfileImageView.frame.size.width > self.m_bgProfileImageView.frame.size.height)
        self.m_bgProfileImageView.frame = CGRectMake(0, 0, self.m_bgProfileImageView.frame.size.height, self.m_bgProfileImageView.frame.size.height);
    else
        self.m_bgProfileImageView.frame = CGRectMake(0, 0, self.m_bgProfileImageView.frame.size.width, self.m_bgProfileImageView.frame.size.width);
    self.m_bgProfileImageView.center = fOriginCenter;

    self.m_bgProfileImageView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f].CGColor;
    self.m_bgProfileImageView.layer.borderWidth = 40.f;
    self.m_bgProfileImageView.layer.cornerRadius = self.m_bgProfileImageView.frame.size.height / 2.f;
    self.m_bgProfileImageView.clipsToBounds = YES;

    self.m_profileImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.m_profileImageView.layer.borderWidth = 0.f;
    self.m_profileImageView.layer.cornerRadius = self.m_profileImageView.frame.size.height / 2.f;
    self.m_profileImageView.clipsToBounds = YES;
    
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

    self.m_viewPicker.hidden = YES;
    self.m_pickerProfile.delegate = self;
    postImage = nil;
    
    ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles firstObject];
    nSelProfileId = profileEntity.m_nId;
    self.navigationItem.title = profileEntity.m_strUsername;
    
    if ([profileEntity.m_strCaminhoThumbnailLink isKindOfClass:[NSNull class]])
        self.m_profileImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    else
        [[Utils sharedObject] loadImageFromServerAndLocalWithoutRound:profileEntity.m_strCaminhoThumbnailLink imageView:self.m_profileImageView];

    self.m_profileImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_profileImageView addGestureRecognizer:tapGesture];

    self.m_postImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureForPost = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(choosePostImage)];
    tapGestureForPost.numberOfTapsRequired = 1;
    [tapGestureForPost setDelegate:self];
    [self.m_postImageView addGestureRecognizer:tapGestureForPost];

    self.m_postImageView.frame = CGRectMake(0, 0, self.m_viewCaption.frame.size.height, self.m_viewCaption.frame.size.height);
    self.m_txtPost.frame = CGRectMake(self.m_viewCaption.frame.size.height + 2, 0, self.m_viewCaption.frame.size.width - 2 - self.m_viewCaption.frame.size.height, self.m_viewCaption.frame.size.height);
    
    [self choosePostImage];
    
}

- (void) tapGesture
{
    self.m_viewPicker.hidden = NO;
    
}

- (void) choosePostImage
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"input_photo_alert_title", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"camera_label_capture_image", nil),NSLocalizedString(@"camera_label_select_image", nil), nil];
    [actionSheet performSelector:@selector(showInView:) withObject:self.view afterDelay:0.6];
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
                                                      [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
                                                      nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:picker animated:YES completion:nil];
        });
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    postImage = [[info valueForKey:UIImagePickerControllerEditedImage] fixOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        postImage = [[Utils sharedObject] scaleAndCropImage:postImage toSize:CGSizeMake(320, 320)];
    else
        postImage = [[Utils sharedObject] scaleAndCropImage:postImage toSize:CGSizeMake(640, 640)];
    
    self.m_postImageView.image = postImage;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    if (g_Delegate.m_currentUser.m_arrProfiles.count > 1)
        [self showWarningAnimations:self.navigationItem.title];
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:POST_TEXT_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = POST_TEXT_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_txtPost resignFirstResponder];

    [_tagsInputView resignFirstResponder];
}

-(void)keyboardWillShow {
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rectScreen = [[UIScreen mainScreen] bounds];
    
    if (textView == self.m_txtPost) {
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -60, rectScreen.size.width, rectScreen.size.height);
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
            self.view.frame = CGRectMake(0, 0, rectScreen.size.width, rectScreen.size.height);
        }];
        self.animated = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else
    {
        if (textView == self.m_txtPost)
        {
            if ([textView text].length >= MAX_DESCRITPION)
                return NO;
        }
    }
    
    return YES;
}

- (void) backToMainView
{
    [g_Delegate.m_curMenuTabViewCon.navigationController popViewControllerAnimated:YES];
}

- (void) makeCustomNavigationBar
{
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(60, 0, self.view.bounds.size.width - 120, 44)];
    UIImage *markImage = [UIImage imageNamed:@"logo.png"];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:markImage];
    myImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    float fTitleImageWidth = 180.f;//120.f
    myImageView.frame = CGRectMake(myView.frame.size.width / 2 - fTitleImageWidth / 2, 4, fTitleImageWidth, 36);
    myImageView.backgroundColor = [UIColor clearColor];
    
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [g_Delegate.m_currentUser.m_arrProfiles count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:row];
    return profileEntity.m_strUsername;
}

// Picker Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:row];

    self.navigationItem.title = profileEntity.m_strUsername;

    nSelProfileId = profileEntity.m_nId;
    if ([profileEntity.m_strCaminhoThumbnailLink isKindOfClass:[NSNull class]])
        self.m_profileImageView.image = [UIImage imageNamed:@"ic_hashcat_silhouete_200.png"];
    else
        [[Utils sharedObject] loadImageFromServerAndLocal:profileEntity.m_strCaminhoThumbnailLink imageView:self.m_profileImageView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionPost:(id)sender {
    if (!postImage)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"upload_image_alert_title", nil)];
        return;
    }
    
    if ([self.m_txtPost.text isEqualToString:POST_TEXT_PLACEHOLDER])
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_description_alert_title", nil)];
        return;
    }
    
    if (self.m_viewTag.seletedTags.count == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"input_category_alert_title", nil)];
        return;
    }
    
    [self showLoadingView];
    
    NSMutableArray* arrSelectedCategory = [[NSMutableArray alloc] init];
    for (int nIdx = 0; nIdx < self.m_viewTag.seletedTags.count; nIdx++)
    {
        GameCategoryEntity* entity = [self.m_viewTag.seletedTags objectAtIndex:nIdx];
        
        [arrSelectedCategory addObject:[NSString stringWithFormat:@"%d", entity.m_nID]];
    }
    
    [FeedService postWithDescription:self.m_txtPost.text withCategories:[arrSelectedCategory componentsJoinedByString:@","] withImage:postImage withProfileId:nSelProfileId withDelegate:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)actionChooseDone:(id)sender {
    self.m_viewPicker.hidden = YES;
    
    if (g_Delegate.m_currentUser.m_arrProfiles.count > 1)
        [self showWarningAnimations:self.navigationItem.title];
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
        [g_Delegate AlertWithCancel_btn:SOMETHING_WRONG];
        return;
    }
    
    MenuTabViewController* parentView = (MenuTabViewController *)self.navigationController.parentViewController;
    [parentView gotoHomeScreen];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    
    [g_Delegate AlertWithCancel_btn:NET_CONNECTION_ERROR];
}

@end
