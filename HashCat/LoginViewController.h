//
//  LoginViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, assign) BOOL animated;

@property (weak, nonatomic) IBOutlet UIButton *m_btnBack;
- (IBAction)actionBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *m_viewInout;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UIView *m_viewIndicatorPass;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPass;
- (IBAction)actionLogin:(id)sender;
@end
