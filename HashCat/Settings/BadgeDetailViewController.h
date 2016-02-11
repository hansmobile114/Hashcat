//
//  BadgeDetailViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface BadgeDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* arrayBadges;
}

@property (assign, nonatomic) BadgeTriggerType m_nBadgeType;

@property (strong, nonatomic) NSString* m_strTitle;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageVIew;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (weak, nonatomic) IBOutlet UIView *m_viewBottomPart;

@end
