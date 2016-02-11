//
//  CreateCatViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHOOSE_BREED            40
#define CHOOSE_BIRTH            41
#define CHOOSE_COUNTRY          42

#define CREATE_PROFILE_REQUEST  44
#define UPDAET_PROFILE_REQUEST  45
#define GET_PROFILE_REQUEST     46

@class ProfileEntity;

@interface CreateCatViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    int nRequestMode;
    
    bool bCurrentChooseField;
    NSMutableArray* arrayData;
    
    int nCurrentChooseField;
    
    int nSelectedCountryId;
    int nSelectedBreedId;
    
    UIImage* avatarImage;
    
}

@property (nonatomic, strong) NSString* m_strBirthTime;

@property (nonatomic, assign) bool m_bViewMode;
@property (nonatomic, assign) bool m_bReloadProfile;

@property (nonatomic, assign) int m_nProfileIndexInUser;

@property (nonatomic, strong) ProfileEntity* m_profileEntity;

@property (nonatomic, assign) BOOL animated;

@property (weak, nonatomic) IBOutlet UIImageView *m_userImage;

@property (weak, nonatomic) IBOutlet UIView *m_viewInout;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorUsername;
@property (weak, nonatomic) IBOutlet UITextField *m_txtUsername;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorBreed;
@property (weak, nonatomic) IBOutlet UITextField *m_txtBreed;
- (IBAction)actionChooseBreed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorDescription;
@property (weak, nonatomic) IBOutlet UITextField *m_txtDescirption;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorBirth;
@property (weak, nonatomic) IBOutlet UITextField *m_txtBirth;
- (IBAction)actionChooseBirth:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorCountry;
@property (weak, nonatomic) IBOutlet UITextField *m_txtCountry;
- (IBAction)actionChooseCountry:(id)sender;

- (IBAction)actionCreate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCreate;

@property (weak, nonatomic) IBOutlet UIView *m_viewPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_lblPickerTitle;
- (IBAction)actionChooseDone:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *m_pickerDate;
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerData;
@end
