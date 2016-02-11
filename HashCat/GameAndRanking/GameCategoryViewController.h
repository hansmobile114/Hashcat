//
//  GameCategoryViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/5/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatSubView.h"

@interface GameCategoryViewController : UIViewController<CatSubViewDelegate>
{
    NSMutableArray* arrayViews;
}

@property (nonatomic, strong) NSMutableArray* m_arrayResult;
@property (weak, nonatomic) IBOutlet UIImageView *m_topImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageLogo;

@end
