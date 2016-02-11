//
//  BadgeInfoViewController.m
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "BadgeListViewController.h"
#import "Global.h"
#import "BadgeDetailViewController.h"

@interface BadgeListViewController ()

@end

@implementation BadgeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"badge_title_choose_badge_type", nil);
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"winssegue"])
    {
        BadgeDetailViewController* viewCon = (BadgeDetailViewController *)segue.destinationViewController;
        viewCon.m_strTitle = [[[NSLocalizedString(@"badge_type_wins", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"badge_type_wins", nil) substringFromIndex:1]];
        viewCon.m_nBadgeType = WINS;
    }
    else if ([segue.identifier isEqualToString:@"likessegue"])
    {
        BadgeDetailViewController* viewCon = (BadgeDetailViewController *)segue.destinationViewController;
        viewCon.m_strTitle = [[[NSLocalizedString(@"badge_type_likes", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"badge_type_likes", nil) substringFromIndex:1]];
        viewCon.m_nBadgeType = LIKES;
    }
    else if ([segue.identifier isEqualToString:@"followerssegue"])
    {
        BadgeDetailViewController* viewCon = (BadgeDetailViewController *)segue.destinationViewController;
        viewCon.m_strTitle = [[[NSLocalizedString(@"badge_type_followers", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"badge_type_followers", nil) substringFromIndex:1]];
        viewCon.m_nBadgeType = FOLLOWERS;
    }
    else if ([segue.identifier isEqualToString:@"followingsegue"])
    {
        BadgeDetailViewController* viewCon = (BadgeDetailViewController *)segue.destinationViewController;
        viewCon.m_strTitle = [[[NSLocalizedString(@"badge_type_following", nil) substringToIndex:1] uppercaseString] stringByAppendingString:[NSLocalizedString(@"badge_type_following", nil) substringFromIndex:1]];
        viewCon.m_nBadgeType = FOLLOWING;
    }
}

@end
