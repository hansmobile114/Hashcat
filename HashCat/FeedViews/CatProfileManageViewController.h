//
//  CatProfileManageViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/19/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "CatSubView.h"

@interface CatProfileManageViewController : UIViewController<CatSubViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    int nRequestMode;
    
    NSMutableArray* arrayViews;
    
    int nSelectedProfileIdx;
}

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *m_bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UIView *m_viewBottomPart;

@end
