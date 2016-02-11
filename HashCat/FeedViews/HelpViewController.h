//
//  HelpViewController.h
//  HashCat
//
//  Created by iOSDevStar on 8/3/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableArray* arrayImages;
    NSMutableArray* arrayTitles;
}

@property (nonatomic, assign) int m_nHelpMode;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *m_imgSwipe;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgCat;

@property (weak, nonatomic) IBOutlet UIPageControl *m_pageControl;

@property (weak, nonatomic) IBOutlet UIButton *m_btnSkip;
- (IBAction)actionSkip:(id)sender;

@end
