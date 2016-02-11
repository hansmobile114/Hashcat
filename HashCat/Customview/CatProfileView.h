//
//  CatProfileView.h
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CatProfileViewDelegate;

@interface CatProfileView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) id<CatProfileViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *m_lblPhotoAmount;
@property (weak, nonatomic) IBOutlet UILabel *m_lblFollowerAmount;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;

@property (weak, nonatomic) IBOutlet UILabel *m_lblBreed;

@property (weak, nonatomic) IBOutlet UIImageView *m_icoinBreed;

- (IBAction)actionShowFollowers:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *m_lblFollowersTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPhotosTitle;

@end

@protocol CatProfileViewDelegate
- (void) showFollowersInCatProfile:(CatProfileView *) catView;
@end