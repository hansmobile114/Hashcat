//
//  UserProfileViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatSubView.h"

@class HMSegmentedControl;
@class UserEntity;

@interface UserProfileViewController : UIViewController<UIScrollViewDelegate, CatSubViewDelegate>
{
    NSMutableArray* arrayMainViews;
    NSMutableArray* arrayPhotoViews;
    NSMutableArray* arrayBadgeViews;
    
    HMSegmentedControl *mainSegmentedControl;
    
    UIScrollView* scrollViewPhotos;
    UIScrollView* scrollViewBadges;
    
    bool bLoad;
}

@property (nonatomic, assign) bool m_bShowBadge;

@property (nonatomic, strong) UserEntity* m_currentUser;

@property (nonatomic, assign) bool m_bMyProfile;
@property (nonatomic, assign) long m_nUserId;

@property (strong, nonatomic) UIScrollView *m_badgeAndPhotoScrollView;

- (IBAction)actionshowFollowing:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageTopBgView;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageBgView;

@property (weak, nonatomic) IBOutlet UIView *m_profileView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCatAmount;
@property (weak, nonatomic) IBOutlet UILabel *m_lblFollowingAmount;
@property (weak, nonatomic) IBOutlet UIImageView *m_profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;

- (IBAction)actionEditProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnEdit;

@property (weak, nonatomic) IBOutlet UIView *m_viewPart;

@end
