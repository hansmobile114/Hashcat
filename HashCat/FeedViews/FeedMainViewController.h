//
//  FeedMainViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostSubView.h"
#import "DWTagList.h"

#define LIKE_REQUEST            11
#define GET_FEED_REQUEST        12
#define REPORT_REQUEST          13
#define REMOVE_PHOTO_REQUEST    14

@interface FeedMainViewController : UIViewController<UIScrollViewDelegate, PostSubViewDelegate, DWTagListDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    int nCurViewMode;
    
    int nRequestMode;
    
    long lBeforeId;
    long lSinceId;
    
    bool bLoad;
    
    bool bDirectionMode;
    
    int nPreLoadedCount;
    
    float fScrollHeight;
    float fScrollCurPos;
    
    int nSelectedLikePhotoId;
    int nSelectedReportPhotId;
}

@property (nonatomic, assign) bool m_bShowFromRanking;

@property (nonatomic, assign) bool m_bFirstView;

@property (nonatomic, assign) long m_lPhotoId;

@property (nonatomic, strong)  NSMutableArray* m_arrayViews;
@property (nonatomic, strong)  NSMutableArray* m_arrayResult;
@property (nonatomic, strong)  NSMutableArray* m_arrayData;

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@end
