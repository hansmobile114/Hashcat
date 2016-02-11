//
//  CatProfileViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatSubView.h"
#import "UserProfileView.h"
#import "CatProfileView.h"

@class HMSegmentedControl;
@class ProfileEntity;
@class GetProfileEntity;

#define GET_PROFILE_REQUEST     20
#define FOLLOW_REQUEST          21

@interface CatProfileViewController : UIViewController<UIScrollViewDelegate, CatSubViewDelegate, UIGestureRecognizerDelegate, UserProfileViewDelegate, CatProfileViewDelegate>
{
    int nRequestMode;
    
    NSMutableArray* arrayMainViews;
    NSMutableArray* arrayPhotoViews;
    NSMutableArray* arrayBadgeViews;
    
    HMSegmentedControl *mainSegmentedControl;
    
    UIScrollView* scrollViewPhotos;
    UIScrollView* scrollViewBadges;
    
    GetProfileEntity* getProfileEntity;
    
    bool bLoad;
    
    bool bFollowed;
    int nFollowIdx;
}
@property (nonatomic, assign) bool m_bShowBadge;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageTopBgView;
@property (nonatomic, assign) bool m_bMyProfile;

@property (nonatomic, strong) ProfileEntity* m_profileEntity;
@property (weak, nonatomic) IBOutlet UIView *m_viewCatInfo;

@property (nonatomic, assign) int m_nProfileId;
@property (nonatomic, assign) int m_nProfileIndexInUser;
@property (nonatomic, strong) NSString* m_strProfileUsername;

@property (strong, nonatomic) UIScrollView *m_badgeAndPhotoScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageBgView;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *m_pageControl;

- (IBAction)actionEditProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnEdit;

@property (weak, nonatomic) IBOutlet UIView *m_viewPart;

@end
