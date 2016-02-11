//
//  UserListViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/4/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProfileView.h"

#define GET_FOLLOWING_REQUEST   60
#define FOLLOW_REQUEST          61

@interface UserListViewController : UIViewController<SearchProfileViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
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

@property (nonatomic, assign) bool m_bViewMode;
@property (nonatomic, assign) long m_nId;

@property (nonatomic, strong) NSMutableArray* m_arrayResult;
@property (nonatomic, strong)  NSMutableArray* m_arrayData;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end
