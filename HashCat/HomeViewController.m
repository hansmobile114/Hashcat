//
//  HomeViewController.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "HomeViewController.h"
#import "AKTabBarController.h"
#import "JSCustomBadge.h"
#import "Global.h"
#import "GameCategoryViewController.h"
#import "RankingViewController.h"
#import "MenuTabViewController.h"
#import "GameService.h"
#import "HelpViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_btnPlay.center = CGPointMake(-1 * self.m_btnPlay.frame.size.width, self.m_btnPlay.center.y);
    self.m_btnRankings.center = CGPointMake(-1 * self.m_btnRankings.frame.size.width, self.m_btnRankings.center.y);
    self.m_btnFeed.center = CGPointMake(-1 * self.m_btnFeed.frame.size.width, self.m_btnFeed.center.y);
    
    nCurHelpView = HELP_NONE;
    
    [self showLoadingView];
    [GameService categoriesWithDelegate:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (nCurHelpView != HELP_NONE)
    {
       if (nCurHelpView == HELP_PLAY)
           [self actionPlay:self.m_btnPlay];
        else if (nCurHelpView == HELP_RANKING)
            [self actionRankings:self.m_btnRankings];
        else if (nCurHelpView == HELP_FEED)
            [self actionFeed:self.m_btnFeed];
        
        return;
    }
    
    [UIView animateWithDuration:1.f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_btnPlay.center = CGPointMake(self.view.frame.size.width / 2, self.m_btnPlay.center.y);
     }
     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
     }];

    [UIView animateWithDuration:1.f
                          delay:0.2f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_btnRankings.center = CGPointMake(self.view.frame.size.width / 2, self.m_btnRankings.center.y);
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
     }];

    [UIView animateWithDuration:1.f
                          delay:0.4f
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.m_btnFeed.center = CGPointMake(self.view.frame.size.width / 2, self.m_btnFeed.center.y);
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
     }];

    [self showRatingAlertView];
}

- (void) showRatingAlertView
{
    int nRatingPossible = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"rating"];

    long long lCurTime = [[[Utils sharedObject] timeInMiliSeconds:[NSDate date]] longLongValue];
    long long lRatingTime = [((NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"rating_date"]) longLongValue];
    
    if ( (nRatingPossible == 0) || (nRatingPossible == 2 && (lCurTime - lRatingTime > RATING_CYCLE * 24 * 3600 * 1000)) )
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"dialog_title", nil), APP_FULL_NAME] message:NSLocalizedString(@"rate_message", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"rate", nil), NSLocalizedString(@"later", nil), NSLocalizedString(@"no_thanks", nil), nil];
        
        [alertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self rateApp];
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"rating"];
        [[NSUserDefaults standardUserDefaults] setValue:[[Utils sharedObject] timeInMiliSeconds:[NSDate date]] forKey:@"rating_date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"rating"];
        [[NSUserDefaults standardUserDefaults] setValue:[[Utils sharedObject] timeInMiliSeconds:[NSDate date]] forKey:@"rating_date"];
        return;
    }
    else if (buttonIndex == 2)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"rating"];
        [[NSUserDefaults standardUserDefaults] setValue:[[Utils sharedObject] timeInMiliSeconds:[NSDate date]] forKey:@"rating_date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void) rateApp
{
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", ITUNES_APP_ID];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@", ITUNES_APP_ID];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.m_btnPlay.center = CGPointMake(-1 * self.m_btnPlay.frame.size.width, self.m_btnPlay.center.y);
    self.m_btnRankings.center = CGPointMake(-1 * self.m_btnRankings.frame.size.width, self.m_btnRankings.center.y);
    self.m_btnFeed.center = CGPointMake(-1 * self.m_btnFeed.frame.size.width, self.m_btnFeed.center.y);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionPlay:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    bool bShowHelp = [[NSUserDefaults standardUserDefaults] boolForKey:@"playhelp"];
    if (!bShowHelp)
    {
        nCurHelpView = HELP_PLAY;
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"playhelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //help
        HelpViewController* helpViewCon = [storyboard instantiateViewControllerWithIdentifier:@"helpview"];
        helpViewCon.m_nHelpMode = HELP_PLAY;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:helpViewCon animated:YES completion:nil];
        });
        
        return;
    }
    
    nCurHelpView = HELP_NONE;
    
    GameCategoryViewController *menuTabView = [storyboard instantiateViewControllerWithIdentifier:@"categoryview"];
    g_Delegate.m_bHasBottomBar = false;
    [self.navigationController pushViewController:menuTabView animated:YES];
}

- (IBAction)actionRankings:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    bool bShowHelp = [[NSUserDefaults standardUserDefaults] boolForKey:@"rankinghelp"];
    if (!bShowHelp)
    {
        nCurHelpView = HELP_RANKING;

        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"rankinghelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //help
        HelpViewController* helpViewCon = [storyboard instantiateViewControllerWithIdentifier:@"helpview"];
        helpViewCon.m_nHelpMode = HELP_RANKING;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:helpViewCon animated:YES completion:nil];
        });
        
        return;
    }

    nCurHelpView = HELP_NONE;

    RankingViewController *menuTabView = [storyboard instantiateViewControllerWithIdentifier:@"rankingview"];
    g_Delegate.m_bHasBottomBar = false;
    [self.navigationController pushViewController:menuTabView animated:YES];
}

- (IBAction)actionFeed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
    
    bool bShowHelp = [[NSUserDefaults standardUserDefaults] boolForKey:@"feedhelp"];
    if (!bShowHelp)
    {
        nCurHelpView = HELP_FEED;

        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"feedhelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //help
        HelpViewController* helpViewCon = [storyboard instantiateViewControllerWithIdentifier:@"helpview"];
        helpViewCon.m_nHelpMode = HELP_FEED;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:helpViewCon animated:YES completion:nil];
        });
        
        return;
    }

    nCurHelpView = HELP_NONE;

    MenuTabViewController *menuTabView = [storyboard instantiateViewControllerWithIdentifier:@"menutabview"];
    g_Delegate.m_bHasBottomBar = true;
    [self.navigationController pushViewController:menuTabView animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
    NSString *receivedData = [request responseString];
    NSArray* arrResponse = [receivedData JSONValue];
    if (arrResponse.count == 0)
        return;
    
    [g_Delegate.m_arrGameCategories removeAllObjects];
    for (int nIdx = 0; nIdx < arrResponse.count; nIdx++)
    {
        NSDictionary* dictOne = [arrResponse objectAtIndex:nIdx];
        
        GameCategoryEntity* gameCategoryEntity = [[GameCategoryEntity alloc] initWithDictInfo:dictOne];
        
        [g_Delegate.m_arrGameCategories addObject:gameCategoryEntity];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self hideLoadingView];
}

@end
