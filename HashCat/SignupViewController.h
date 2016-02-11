//
//  SignupViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserEntity;

@interface SignupViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    int nRequestMode;
    
    bool bCurrentChooseField;
    NSArray* arrayGender;
    
    UIImage* avatarImage;
    
}

@property (nonatomic, strong) NSString* m_strBirthTime;

@property (nonatomic, strong) UIPopoverController *popOver;

@property (nonatomic, assign) bool m_bViewMode;
@property (nonatomic, strong) UserEntity* m_userEntity;

@property (nonatomic, assign) BOOL animated;

@property (nonatomic, assign) bool m_bCreateFBUser;
@property (nonatomic, strong) NSDictionary* m_dictFBInfo;

@property (weak, nonatomic) IBOutlet UIButton *m_btnBack;
- (IBAction)actionBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *m_userImage;

@property (weak, nonatomic) IBOutlet UIView *m_viewInout;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorUsername;
@property (weak, nonatomic) IBOutlet UITextField *m_txtUsername;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorPass;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPass;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorGender;
@property (weak, nonatomic) IBOutlet UITextField *m_txtGender;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorDOB;
@property (weak, nonatomic) IBOutlet UITextField *m_txtDOB;
- (IBAction)actionChooseGender:(id)sender;
- (IBAction)actionChooseDOB:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWarning;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_lblChoose;
@property (weak, nonatomic) IBOutlet UIView *m_viewChoose;
- (IBAction)actionDone:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *m_pickerDOB;
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerData;

- (IBAction)actionSignup:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSignUp;

@end
