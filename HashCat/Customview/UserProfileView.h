//
//  UserProfileView.h
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserEntity;

@protocol UserProfileViewDelegate;

@interface UserProfileView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UserEntity* m_userEntry;

@property (nonatomic, strong) id<UserProfileViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *m_userImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPhotoAmount;
@property (weak, nonatomic) IBOutlet UILabel *m_lblFollowerAmount;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDescription;
- (IBAction)actionShowFollowers:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageFollowerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *m_imagePhotosIcon;

@end

@protocol UserProfileViewDelegate
- (void) actionClickedUserPhoto:(UserProfileView *) userView userInfo:(UserEntity *) userEntity;
- (void) showFollowersInUserProfile:(UserProfileView *) userView;

@end
