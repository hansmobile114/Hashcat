//
//  FeedNotificationsViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedNotificationsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    long lBeforeId;
    long lSinceId;
    
    bool bLoad;
    
    bool bDirectionMode;
    
    UIRefreshControl* refreshControl;
}

@property (nonatomic, strong)  NSMutableArray* m_arrayResult;
@property (nonatomic, strong)  NSMutableArray* m_arrayData;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end
