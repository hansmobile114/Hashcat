//
//  UserProfileView.m
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "UserProfileView.h"
#import "Global.h"

@implementation UserProfileView

- (void)awakeFromNib {
    // Initialization code
    self.m_imageView.layer.cornerRadius = self.m_imageView.frame.size.height / 2.f;
    self.m_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_imageView.layer.borderWidth = 3.f;
    self.m_imageView.clipsToBounds = YES;

    self.m_userImageVIew.layer.cornerRadius = self.m_userImageVIew.frame.size.height / 2.f;
    self.m_userImageVIew.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_userImageVIew.layer.borderWidth = 1.f;
    self.m_userImageVIew.clipsToBounds = YES;

    self.m_userImageVIew.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_userImageVIew addGestureRecognizer:tapGesture];

    self.m_imageView.userInteractionEnabled = YES;
    [self.m_imageView addGestureRecognizer:tapGesture];

}

- (void) tapGesture
{
    if (self.delegate)
        [self.delegate actionClickedUserPhoto:self userInfo:self.m_userEntry];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actionShowFollowers:(id)sender {
    if (self.delegate)
        [self.delegate showFollowersInUserProfile:self];
}

@end
