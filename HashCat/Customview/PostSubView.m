//
//  PostSubView.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "PostSubView.h"
#import "Global.h"

@implementation PostSubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
    self.m_userImageView.layer.cornerRadius = self.m_userImageView.frame.size.height / 2.f;
    self.m_userImageView.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_userImageView.layer.borderWidth = 3.f;
    self.m_userImageView.clipsToBounds = YES;

    // one tap
    self.m_userImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_userImageView addGestureRecognizer:tapGesture];

    // double tap
    self.m_postImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(doubleTapGesture)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [doubleTapGesture setDelegate:self];
    [self.m_postImageView addGestureRecognizer:doubleTapGesture];
    
    self.m_lblPostText.userInteractionEnabled = YES;
    
    PatternTapResponder hashTagTapAction = ^(NSString *tappedString){
        if ([self.delegate respondsToSelector:@selector(actionClickHashTag:withString:)]) {
            [self.delegate actionClickHashTag:self withString:tappedString];
        }
    };
    [self.m_lblPostText enableHashTagDetectionWithAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR,
                                                             RLTapResponderAttributeName:hashTagTapAction}];
    
    PatternTapResponder userHandleTapAction = ^(NSString *tappedString){
        if ([self.delegate respondsToSelector:@selector(actionClickUserName:withString:)]) {
            [self.delegate actionClickUserName:self withString:tappedString];
        }};
    [self.m_lblPostText enableUserHandleDetectionWithAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR,
                                                                RLTapResponderAttributeName:userHandleTapAction}];
}

- (void) tapGesture
{
    if (self.delegate)
        [self.delegate actionViewProfile:self withIndex:self.m_nIndex];
}

- (void) doubleTapGesture
{
    if (self.delegate)
        [self.delegate actionClickLike:self withIndex:self.m_nIndex];
}

- (IBAction)actionViewProfile:(id)sender {
    if (self.delegate)
        [self.delegate actionViewProfile:self withIndex:self.m_nIndex];
}

- (IBAction)actionLike:(id)sender {
    if (self.delegate)
        [self.delegate actionClickLike:self withIndex:self.m_nIndex];
}

- (IBAction)actionComment:(id)sender {
    if (self.delegate)
        [self.delegate actionClickComment:self withIndex:self.m_nIndex];
}

- (IBAction)actionSeeLikeUsers:(id)sender {
    if (self.delegate)
        [self.delegate actionClickLikeUsers:self withIndex:self.m_nIndex];
}

- (IBAction)actionReport:(id)sender {
    if (self.delegate)
        [self.delegate actionClickReport:self withIndex:self.m_nIndex];
}
@end
