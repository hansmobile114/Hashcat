//
//  MenuTabViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "MenuTabViewController.h"
#import "FeedMainViewController.h"
#import "FeedNotificationsViewController.h"
#import "FeedPostViewController.h"
#import "FeedSearchViewController.h"
#import "CatProfileManageViewController.h"
#import "Global.h"

@interface MenuTabViewController ()

@end

@implementation MenuTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];

    FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
    feedMainView.m_lPhotoId = -1;
    feedMainView.m_bFirstView = true;
    UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
    [[navFeedMainViewCon navigationBar] setBarTintColor:NAVI_COLOR];
    [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
    [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                             [UIColor whiteColor], UITextAttributeTextColor,
                                                             [UIColor grayColor], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                             nil];
    navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];

    [self addChildViewController:navFeedMainViewCon];
    [self.m_subView addSubview:navFeedMainViewCon.view];
    [navFeedMainViewCon didMoveToParentViewController:self];
    
    curNavCon = navFeedMainViewCon;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    g_Delegate.m_curMenuTabViewCon = self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    g_Delegate.m_curMenuTabViewCon = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) hideMenuTabView
{
    if (self.m_viewTab.center.y >= self.view.frame.size.height + MENU_TAB_HEIGHT / 2.f)
        return;
    
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewTab.center = CGPointMake(self.m_viewTab.center.x, self.view.frame.size.height + MENU_TAB_HEIGHT / 2.f);
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (void) showMenuTabView
{
    if (self.m_viewTab.center.y <= self.view.frame.size.height - MENU_TAB_HEIGHT / 2.f)
        return;
    
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewTab.center = CGPointMake(self.m_viewTab.center.x, self.view.frame.size.height - MENU_TAB_HEIGHT / 2.f);
     }
                     completion:^(BOOL finished)
     {
     }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) gotoHomeScreen
{
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewIndicator.center = CGPointMake(self.m_view1.center.x, self.m_viewIndicator.center.y);
     }
                     completion:^(BOOL finished)
     {
         [curNavCon willMoveToParentViewController:nil];
         [curNavCon.view removeFromSuperview];
         curNavCon = nil;
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
         
         FeedMainViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"feedmainview"];
         feedMainView.m_lPhotoId = -1;
         feedMainView.m_bFirstView = true;
         UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
         [[navFeedMainViewCon navigationBar] setBarTintColor:NAVI_COLOR];
         [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
         [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                                   [UIColor grayColor], UITextAttributeTextShadowColor,
                                                                   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                                   nil];
         navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];
         navFeedMainViewCon.navigationBar.translucent = NO;
         [self addChildViewController:navFeedMainViewCon];
         [self.m_subView addSubview:navFeedMainViewCon.view];
         [navFeedMainViewCon didMoveToParentViewController:self];
         
         curNavCon = navFeedMainViewCon;
         
     }];
}

- (IBAction)actionChoose1:(id)sender {
    [self gotoHomeScreen];
}

- (IBAction)actionChoose2:(id)sender {
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewIndicator.center = CGPointMake(self.m_view2.center.x, self.m_viewIndicator.center.y);
     }
                     completion:^(BOOL finished)
     {
         [curNavCon willMoveToParentViewController:nil];
         [curNavCon.view removeFromSuperview];
         curNavCon = nil;

         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
         
         FeedSearchViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"searchview"];
         feedMainView.m_strSearchText = @"";
         feedMainView.m_bFirstView = true;
         UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
         [[navFeedMainViewCon navigationBar] setBarTintColor:NAVI_COLOR];
         [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
         [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                                   [UIColor grayColor], UITextAttributeTextShadowColor,
                                                                   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                                   nil];
         navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];
         navFeedMainViewCon.navigationBar.translucent = NO;
         
         [self addChildViewController:navFeedMainViewCon];
         [self.m_subView addSubview:navFeedMainViewCon.view];
         [navFeedMainViewCon didMoveToParentViewController:self];
         
         curNavCon = navFeedMainViewCon;
         
     }];

}

- (IBAction)actionChoose3:(id)sender {
    if (g_Delegate.m_currentUser.m_arrProfiles.count == 0)
    {
        [g_Delegate AlertWithCancel_btn:NSLocalizedString(@"take_photo_toast_no_cat", nil)];
        
        [UIView animateWithDuration:INDICATOR_ANIMATION
                              delay:0.f
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             self.m_viewIndicator.center = CGPointMake(self.m_view5.center.x, self.m_viewIndicator.center.y);
         }
                         completion:^(BOOL finished)
         {
             [curNavCon willMoveToParentViewController:nil];
             [curNavCon.view removeFromSuperview];
             curNavCon = nil;
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
             
             CatProfileManageViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"catmanageview"];
             UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
             [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
             [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                                       [UIColor grayColor], UITextAttributeTextShadowColor,
                                                                       [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                                       nil];
             navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];
             navFeedMainViewCon.navigationBar.translucent = YES;
             
             [self addChildViewController:navFeedMainViewCon];
             [self.m_subView addSubview:navFeedMainViewCon.view];
             [navFeedMainViewCon didMoveToParentViewController:self];
             
             curNavCon = navFeedMainViewCon;
             
         }];
    }
    else
    {
        [UIView animateWithDuration:INDICATOR_ANIMATION
                              delay:0.f
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             self.m_viewIndicator.center = CGPointMake(self.m_view3.center.x, self.m_viewIndicator.center.y);
         }
                         completion:^(BOOL finished)
         {
             [curNavCon willMoveToParentViewController:nil];
             [curNavCon.view removeFromSuperview];
             curNavCon = nil;
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
             
             FeedPostViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"postview"];
             UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
             [[navFeedMainViewCon navigationBar] setBarTintColor:NAVI_COLOR];
             [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
             [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                                       [UIColor grayColor], UITextAttributeTextShadowColor,
                                                                       [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                                       nil];
             navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];
             navFeedMainViewCon.navigationBar.translucent = YES;
             
             [self addChildViewController:navFeedMainViewCon];
             [self.m_subView addSubview:navFeedMainViewCon.view];
             [navFeedMainViewCon didMoveToParentViewController:self];
             
             curNavCon = navFeedMainViewCon;
             
         }];
    }
}

- (IBAction)actionChoose4:(id)sender {
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewIndicator.center = CGPointMake(self.m_view4.center.x, self.m_viewIndicator.center.y);
     }
                     completion:^(BOOL finished)
     {
         [curNavCon willMoveToParentViewController:nil];
         [curNavCon.view removeFromSuperview];
         curNavCon = nil;
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
         
         FeedNotificationsViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"notificationview"];
         UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
         [[navFeedMainViewCon navigationBar] setBarTintColor:NAVI_COLOR];
         [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
         [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                                   [UIColor grayColor], UITextAttributeTextShadowColor,
                                                                   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                                   nil];
         navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];
         navFeedMainViewCon.navigationBar.translucent = NO;

         [self addChildViewController:navFeedMainViewCon];
         [self.m_subView addSubview:navFeedMainViewCon.view];
         [navFeedMainViewCon didMoveToParentViewController:self];
         
         curNavCon = navFeedMainViewCon;
         
     }];

}

- (IBAction)actionChoose5:(id)sender {
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewIndicator.center = CGPointMake(self.m_view5.center.x, self.m_viewIndicator.center.y);
     }
                     completion:^(BOOL finished)
     {
         [curNavCon willMoveToParentViewController:nil];
         [curNavCon.view removeFromSuperview];
         curNavCon = nil;
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
         
         CatProfileManageViewController *feedMainView = [storyboard instantiateViewControllerWithIdentifier:@"catmanageview"];
         UINavigationController *navFeedMainViewCon = [[UINavigationController alloc] initWithRootViewController:feedMainView];
         [[navFeedMainViewCon navigationBar] setTintColor:[UIColor whiteColor]];
         [navFeedMainViewCon navigationBar].titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont fontWithName:MAIN_BOLD_FONT_NAME size:18.0f], UITextAttributeFont,
                                                                   [UIColor whiteColor], UITextAttributeTextColor,
                                                                   [UIColor grayColor], UITextAttributeTextShadowColor,
                                                                   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                                   nil];
         navFeedMainViewCon.navigationBar.tintColor = [UIColor whiteColor];
         navFeedMainViewCon.navigationBar.translucent = YES;

         [self addChildViewController:navFeedMainViewCon];
         [self.m_subView addSubview:navFeedMainViewCon.view];
         [navFeedMainViewCon didMoveToParentViewController:self];
         
         curNavCon = navFeedMainViewCon;
         
     }];

}

- (void) goIndicatorToSearch
{
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewIndicator.center = CGPointMake(self.m_view2.center.x, self.m_viewIndicator.center.y);
     }
                     completion:^(BOOL finished)
     {

     }];
}

- (void) goIndicatorToHome
{
    [UIView animateWithDuration:INDICATOR_ANIMATION
                          delay:0.f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_viewIndicator.center = CGPointMake(self.m_view1.center.x, self.m_viewIndicator.center.y);
     }
                     completion:^(BOOL finished)
     {
     }];
}

@end
