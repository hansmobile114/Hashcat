//
//  FeedSearchViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProfileView.h"

@class HMSegmentedControl;

@interface FeedSearchViewController : UIViewController<UISearchBarDelegate, SearchProfileViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    int nRequestMode;
    
    bool bLoad;
    
    NSMutableArray* arrayMainViews;
    NSMutableArray* arrayPhotoViews;
    NSMutableArray* arrayBadgeViews;
    
    HMSegmentedControl *mainSegmentedControl;
    
    UIScrollView* scrollViewPhotos;
    UIScrollView* scrollViewBadges;

    NSMutableArray* arrayPhotos;
    
    long lBeforeId;
    
    int nPreLoadedCount;
    
    int nSelectedFollowIdx;
    bool bSelectedFollowed;
    
    SearchProfileView* curSelectedSearchView;
    
    bool bLoadSuggestionPhotos;
    bool bLoadSuggestionProfiles;
}

@property (strong, nonatomic) UITableView* tableViewBadges;
@property (strong, nonatomic) NSMutableArray* arrayBadges;
@property (strong, nonatomic) NSMutableArray* arrayData;

@property (nonatomic, assign) bool bHashtagMode;

@property (nonatomic, assign) bool m_bFirstView;

@property (strong, nonatomic) NSString* m_strSearchText;

@property (strong, nonatomic) UIScrollView *m_badgeAndPhotoScrollView;

@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;

@property (weak, nonatomic) IBOutlet UIView *m_viewPart;

@end
