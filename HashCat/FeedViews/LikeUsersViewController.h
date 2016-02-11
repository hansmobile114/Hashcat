//
//  LikeUsersViewController.h
//  HashCat
//
//  Created by iOSDevStar on 8/3/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProfileView.h"

@interface LikeUsersViewController : UIViewController<SearchProfileViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* arrayViews;
    
    int nRequestMode;
    
    long lBeforeId;
    long lSinceId;
    
    bool bLoad;
    
    bool bDirectionMode;
    int nPreLoadedCount;
    float fScrollHeight;
    
    int nSelectedFollowIdx;
    bool bSelectedFollowed;
    
    SearchProfileView* curSelectedSearchView;
}

@property (nonatomic, assign) long m_nId;

@property (nonatomic, strong) NSMutableArray* m_arrayResult;
@property (nonatomic, strong)  NSMutableArray* m_arrayData;

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end
