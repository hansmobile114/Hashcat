//
//  HomeViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKTabBarController;

@interface HomeViewController : UIViewController<UIAlertViewDelegate>
{
    int nCurHelpView;
}
@property (weak, nonatomic) IBOutlet UIButton *m_btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *m_btnRankings;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFeed;

@property (nonatomic, strong) AKTabBarController *tabBarController;

- (IBAction)actionPlay:(id)sender;
- (IBAction)actionRankings:(id)sender;
- (IBAction)actionFeed:(id)sender;

@end
