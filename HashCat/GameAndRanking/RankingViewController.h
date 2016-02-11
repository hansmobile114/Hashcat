//
//  RankingViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/4/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingSubView.h"
#import "TLTagsControl.h"

#define CHOOSE_BREED            90
#define CHOOSE_CATEGOTY         91
#define CHOOSE_AGE              92
#define CHOOSE_COUNTRY          93


#define CATEGORY_REQUEST        100
#define GET_RANNKING_REQUEST    101

@interface RankingViewController : UIViewController<RankingSubViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, TLTagsControlDelegate, UITableViewDataSource, UITableViewDelegate>
{
    int nRequestMode;
    
    NSMutableArray* arrayViews;
    
    NSMutableArray* arrayData;
    NSMutableArray* arrayCategory;
    NSMutableArray* arrayMonths;
    
    int nChooseMode;
    
    int nSelectedBreedIdx;
    int nSelectedCategoryIdx;
    int nSelectedMaxAge;
    int nSelectedMinAge;
    int nSelectedCountryIdx;
    bool bLikeOrWin;//true : like, false : win
    
    NSString* strSelectedFilterBreed;
    NSString* strSelectedFilterCategory;
    NSString* strSelectedFilterAge;
    NSString* strSelectedFilterCountry;
    
    NSMutableArray* arraySelectedFilterName;
}

@property (nonatomic, strong) NSMutableArray* m_arrayResult;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@property (weak, nonatomic) IBOutlet UIView *m_viewTagView;
@property (weak, nonatomic) IBOutlet TLTagsControl *m_tagList;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (weak, nonatomic) IBOutlet UIView *m_viewFilter;

@property (weak, nonatomic) IBOutlet UIButton *m_btnBreed;
- (IBAction)actionBreed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *m_btnCategory;
- (IBAction)actionCategory:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *m_btnAge;
- (IBAction)actionAge:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *m_btnCountry;
- (IBAction)actionCountry:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *m_btnMoreLikes;
- (IBAction)actionMoreLikes:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *m_btnMoreWins;
- (IBAction)actionmoreWins:(id)sender;

- (IBAction)actionCancelFilter:(id)sender;
- (IBAction)actionFilter:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *m_viewChoose;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *m_lblChooseTitle;
- (IBAction)actionChooseDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *m_picker;

@end
