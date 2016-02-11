//
//  CatSubView.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CatSubView.h"
#import "Global.h"

@implementation CatSubView

- (void)awakeFromNib {
    // Initialization code
    self.m_imageView.layer.cornerRadius = self.m_imageView.frame.size.height / 2.f;
    self.m_imageView.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_imageView.layer.borderWidth = 2.f;
    self.m_imageView.clipsToBounds = YES;
    
    self.m_imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_imageView addGestureRecognizer:tapGesture];

    UILongPressGestureRecognizer *gestureLongTouch = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleLongPress:)];
    gestureLongTouch.minimumPressDuration = 1.2f; //seconds
    gestureLongTouch.delegate = self;
    [self.m_imageView addGestureRecognizer:gestureLongTouch];
    gestureLongTouch = nil;

}

- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && !self.m_bCreateNewButton)
        {
            [self.delegate actionAdditionalProcess:self withIndex:self.m_nIndex];
        }
    }
}

- (void) tapGesture
{
    if (self.delegate)
    {
        if (self.m_bCreateNewButton)
            [self.delegate createNewOne:self withIndex:self.m_nIndex];
        else
            [self.delegate actionViewInfo:self withIndex:self.m_nIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
