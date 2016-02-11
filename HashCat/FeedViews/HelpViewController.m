//
//  HelpViewController.m
//  HashCat
//
//  Created by iOSDevStar on 8/3/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "HelpViewController.h"
#import "Global.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_scrollView.delegate = self;
    self.m_scrollView.pagingEnabled = YES;
    
    [self.m_btnSkip setTitle:NSLocalizedString(@"skip_button", nil) forState:UIControlStateNormal];

    self.m_imgCat.animationImages = @[[UIImage imageNamed:@"cat_anim1.png"], [UIImage imageNamed:@"cat_anim2.png"], [UIImage imageNamed:@"cat_anim3.png"], [UIImage imageNamed:@"cat_anim4.png"]];
    self.m_imgCat.animationDuration = 1.f;
    self.m_imgCat.animationRepeatCount = 0;
    [self.m_imgCat startAnimating];
    
    self.m_imgSwipe.animationImages = @[[UIImage imageNamed:@"swipe_anim1.png"], [UIImage imageNamed:@"swipe_anim2.png"], [UIImage imageNamed:@"swipe_anim3.png"], [UIImage imageNamed:@"swipe_anim4.png"]];
    self.m_imgSwipe.animationDuration = 1.f;
    self.m_imgSwipe.animationRepeatCount = 0;
    [self.m_imgSwipe startAnimating];
    
    self.m_btnSkip.hidden = YES;
    
    [self makeImagesAndTitles];
    
    [self makeScrollView];
}

- (void) makeImagesAndTitles
{
    arrayImages = [[NSMutableArray alloc] init];
    arrayTitles = [[NSMutableArray alloc] init];
    
    if (self.m_nHelpMode == HELP_PLAY)
    {
        for (int nIdx = 1; nIdx <= 5; nIdx++)
        {
            NSString* strFileName = [NSString stringWithFormat:@"play%d_%@.png", nIdx, [[Utils sharedObject] getCurrentLocale]];
            [arrayImages addObject:[UIImage imageNamed:strFileName]];
        }
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_1", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_2", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_3", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_4", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_5", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_finish", nil)];
    }
    else if (self.m_nHelpMode == HELP_RANKING)
    {
        for (int nIdx = 1; nIdx <= 3; nIdx++)
        {
            NSString* strFileName = [NSString stringWithFormat:@"rank%d_%@.png", nIdx, [[Utils sharedObject] getCurrentLocale]];
            [arrayImages addObject:[UIImage imageNamed:strFileName]];
        }
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_1", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_2", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_3", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_finish", nil)];

    }
    else if (self.m_nHelpMode == HELP_FEED)
    {
        for (int nIdx = 1; nIdx <= 5; nIdx++)
        {
            NSString* strFileName = [NSString stringWithFormat:@"feed%d_%@.png", nIdx, [[Utils sharedObject] getCurrentLocale]];
            [arrayImages addObject:[UIImage imageNamed:strFileName]];
        }
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_1", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_2", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_3", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_4", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_5", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_finish", nil)];
    }
    else if (self.m_nHelpMode == HELP_TOTAL)
    {
        for (int nIdx = 1; nIdx <= 5; nIdx++)
        {
            NSString* strFileName = [NSString stringWithFormat:@"play%d_%@.png", nIdx, [[Utils sharedObject] getCurrentLocale]];
            [arrayImages addObject:[UIImage imageNamed:strFileName]];
        }
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_1", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_2", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_3", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_4", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_play_5", nil)];
        
        for (int nIdx = 1; nIdx <= 3; nIdx++)
        {
            NSString* strFileName = [NSString stringWithFormat:@"rank%d_%@.png", nIdx, [[Utils sharedObject] getCurrentLocale]];
            [arrayImages addObject:[UIImage imageNamed:strFileName]];
        }
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_1", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_2", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_ranking_3", nil)];

        for (int nIdx = 1; nIdx <= 5; nIdx++)
        {
            NSString* strFileName = [NSString stringWithFormat:@"feed%d_%@.png", nIdx, [[Utils sharedObject] getCurrentLocale]];
            [arrayImages addObject:[UIImage imageNamed:strFileName]];
        }
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_1", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_2", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_3", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_4", nil)];
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_5", nil)];
        
        [arrayTitles addObject:NSLocalizedString(@"wizard_label_feed_finish", nil)];
    }


    self.m_pageControl.numberOfPages = arrayTitles.count;

}

- (void) makeScrollView
{
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * arrayTitles.count, 10);
    
    for (int nIdx = 0; nIdx < arrayTitles.count; nIdx++)
    {
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * nIdx, 20.f, self.view.frame.size.width - 10.f, self.view.frame.size.height)];
        lblTitle.text = [arrayTitles objectAtIndex:nIdx];
        lblTitle.font = [UIFont fontWithName:MAIN_FONT_NAME size:18.f];
        lblTitle.textColor = MAIN_COLOR;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.numberOfLines = 0.f;
        [lblTitle sizeToFit];
        
        lblTitle.center = CGPointMake(self.view.frame.size.width / 2.f * (2 * nIdx + 1), lblTitle.frame.size.height / 2.f + 30.f);

        [self.m_scrollView addSubview:lblTitle];

        if (nIdx == 0)
            continue;
        
        if (nIdx == arrayTitles.count - 1)
        {
            UIButton* btnGotit = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnGotit setBackgroundImage:[UIImage imageNamed:@"button_orange.9.png"] forState:UIControlStateNormal];
            [btnGotit setBackgroundImage:[UIImage imageNamed:@"btn_white.9.png"] forState:UIControlStateHighlighted];
            [btnGotit setBackgroundImage:[UIImage imageNamed:@"btn_white.9.png"] forState:UIControlStateSelected];
            [btnGotit setTitle:NSLocalizedString(@"wizard_got_it", nil) forState:UIControlStateNormal];
            [btnGotit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnGotit setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
            
            btnGotit.titleLabel.font = [UIFont fontWithName:MAIN_FONT_NAME size:18.f];
            btnGotit.frame = CGRectMake(0, 0, 120, 40.f);
            btnGotit.center = CGPointMake(self.view.frame.size.width / 2.f * (2 * nIdx + 1), lblTitle.center.y + lblTitle.frame.size.height / 2.f + 30.f + btnGotit.frame.size.height / 2.f);
            [btnGotit addTarget:self action:@selector(actionSkip:) forControlEvents:UIControlEventTouchUpInside];
            [self.m_scrollView addSubview:btnGotit];
            continue;
        }
        
        UIImage* imgHelp = [arrayImages objectAtIndex:nIdx];
        float fImageViewWidth = self.view.frame.size.width - 20.f;
        float fImageViewHeight = fImageViewWidth / imgHelp.size.width * imgHelp.size.height;
        
        if (lblTitle.center.y + lblTitle.frame.size.height / 2.f + 30.f + fImageViewHeight > self.m_pageControl.frame.origin.y - 20.f)
        {
            float fTemp = lblTitle.center.y + lblTitle.frame.size.height / 2.f + 30.f + fImageViewHeight - (self.m_pageControl.frame.origin.y - 20.f);
            
            fImageViewHeight -= fTemp;
            fImageViewHeight -= 10.f;
        }
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * nIdx + 10.f, lblTitle.center.y + lblTitle.frame.size.height / 2.f + 30.f, self.view.frame.size.width - 20.f, fImageViewHeight)];
        imageView.image = [arrayImages objectAtIndex:nIdx];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        [self.m_scrollView addSubview:imageView];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.view.frame.size.width;
    float fractionalPage = self.m_scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.m_pageControl.currentPage = page;
    
    if (page == 0)
    {
        self.m_btnSkip.hidden = YES;
        self.m_imgSwipe.hidden = NO;
        [self.m_imgCat startAnimating];
    }
    else if (page == arrayTitles.count - 1)
    {
        self.m_btnSkip.hidden = YES;
        [self.m_imgCat stopAnimating];
    }
    else
    {
        self.m_btnSkip.hidden = NO;
        self.m_imgSwipe.hidden = YES;
        [self.m_imgCat startAnimating];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionSkip:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
