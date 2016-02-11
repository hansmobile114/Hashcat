//
//  SettingViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray* arrayDict;
}

@property (nonatomic, assign) BOOL animated;

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@property (weak, nonatomic) IBOutlet UIView *m_viewChangePassword;
@property (weak, nonatomic) IBOutlet UIView *m_viewSubView;

@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_txtOldPassword;

@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_txtNewPassword;

@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorNewPassConfirm;
@property (weak, nonatomic) IBOutlet UITextField *m_txtNewPassConfirmation;

- (IBAction)actionChange:(id)sender;
- (IBAction)actionCancel:(id)sender;




@end
