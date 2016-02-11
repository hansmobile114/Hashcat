//
//  CatProfileView.m
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CatProfileView.h"
#import "Global.h"
#import "CatProfileViewController.h"

@implementation CatProfileView

- (void)awakeFromNib {
    // Initialization code
    self.m_imageView.layer.cornerRadius = self.m_imageView.frame.size.height / 2.f;
    self.m_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.m_imageView.layer.borderWidth = 3.f;
    self.m_imageView.clipsToBounds = YES;
    
    self.m_imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_imageView addGestureRecognizer:tapGesture];
    
    self.m_lblFollowersTitle.text = NSLocalizedString(@"followers_or_following_title_followers", nil);
    self.m_lblPhotosTitle.text = NSLocalizedString(@"cat_profile_sub_photo_amounts", nil);
}

- (void) tapGesture
{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actionShowFollowers:(id)sender {
    if(self.delegate)
        [self.delegate showFollowersInCatProfile:self];
}

@end
