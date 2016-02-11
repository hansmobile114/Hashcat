//
//  RankingSubView.m
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "RankingSubView.h"
#import "Global.h"

@implementation RankingSubView

- (void)awakeFromNib {
    // Initialization code
    
    self.m_imageCatView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setDelegate:self];
    [self.m_imageCatView addGestureRecognizer:tapGesture];
    
}

- (void) tapGesture
{
    if (self.delegate)
        [self.delegate actionViewPhoto:self index:self.m_nIndex];
}

- (IBAction)actionViewProfile:(id)sender {
    if (self.delegate)
        [self.delegate actionViewProfile:self index:self.m_nIndex];
}
@end
