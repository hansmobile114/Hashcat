//
//  SuggestionsViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProfileView.h"

#define GET_PROFILE_REQUEST     20
#define FOLLOW_REQUEST          21
#define FOLLOW_ALL_REQUEST      22
#define RELOGIN_REQUEST         23

@interface SuggestionsViewController : UIViewController<SearchProfileViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, SearchProfileViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    int nRequestMode;
    
    NSMutableArray* arrayBadgeViews;
    
    NSMutableArray* arrayBadges;

    SearchProfileView* curSelectedSearchView;

    int nSelectedFollowIdx;
    bool bSelectedFollowed;

}

- (IBAction)actionFollowAll:(id)sender;
- (IBAction)actionContinue:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIView *m_viewBottomPart;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end
