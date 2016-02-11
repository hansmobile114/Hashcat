//
//  BadgeInfoViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/30/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatSubView.h"

@class BadgeEntity;

@interface BadgeInfoViewController : UIViewController<CatSubViewDelegate>
{
    int nRequestMode;
    
    NSMutableArray* arrayPhotoViews;
    NSMutableArray* arrayResult;
    
    bool bGetProfile;
}

@property (nonatomic, strong) BadgeEntity *m_badge;

@property (weak, nonatomic) IBOutlet UIImageView *m_badgeImageView;

@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeName;
@property (weak, nonatomic) IBOutlet UIView *m_viewBottomView;

@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeCondition;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeCondition;

@property (weak, nonatomic) IBOutlet UIScrollView *m_mainScrollView;

@end
