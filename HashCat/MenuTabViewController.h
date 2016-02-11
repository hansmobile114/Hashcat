//
//  MenuTabViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTabViewController : UIViewController
{
    UINavigationController* curNavCon;
}
@property (weak, nonatomic) IBOutlet UIView *m_subView;

@property (weak, nonatomic) IBOutlet UIView *m_viewIndicator;
@property (weak, nonatomic) IBOutlet UIView *m_view1;
@property (weak, nonatomic) IBOutlet UIView *m_view2;
@property (weak, nonatomic) IBOutlet UIView *m_view3;
@property (weak, nonatomic) IBOutlet UIView *m_view4;
@property (weak, nonatomic) IBOutlet UIView *m_view5;

@property (weak, nonatomic) IBOutlet UIView *m_viewTab;

- (IBAction)actionChoose1:(id)sender;
- (IBAction)actionChoose2:(id)sender;
- (IBAction)actionChoose3:(id)sender;
- (IBAction)actionChoose4:(id)sender;
- (IBAction)actionChoose5:(id)sender;

- (void) gotoHomeScreen;

- (void) goIndicatorToSearch;
- (void) goIndicatorToHome;

- (void) hideMenuTabView;
- (void) showMenuTabView;

@end
