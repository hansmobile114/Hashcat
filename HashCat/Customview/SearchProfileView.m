//
//  SearchProfileView.m
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "SearchProfileView.h"
#import "Global.h"

@implementation SearchProfileView

- (void)awakeFromNib {
    // Initialization code
    self.m_imageView.layer.cornerRadius = self.m_imageView.frame.size.height / 2.f;
    self.m_imageView.layer.borderColor = MAIN_COLOR.CGColor;
    self.m_imageView.layer.borderWidth = 3.f;
    self.m_imageView.clipsToBounds = YES;
    
    self.m_imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_imageView addGestureRecognizer:tapGesture];
    
}

- (void) tapGesture
{
    if (self.delegate)
        [self.delegate actionViewProfile:self index:self.m_nIndex];
}

- (IBAction)actionAdd:(id)sender {
    if (self.delegate)
        [self.delegate actionClickAdd:self index:self.m_nIndex];
}

@end
