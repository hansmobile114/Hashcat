//
//  RankingSubView.h
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RankingSubViewDelegate;

@interface RankingSubView : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, strong) id<RankingSubViewDelegate> delegate;

@property (nonatomic, assign) int m_nIndex;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageRankingView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageCatView;

@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBreed;
@property (weak, nonatomic) IBOutlet UILabel *m_lblAge;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWins;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLikes;

@property (weak, nonatomic) IBOutlet UIView *m_viewContainer;
- (IBAction)actionViewProfile:(id)sender;

@end

@protocol RankingSubViewDelegate
- (void) actionViewProfile:(RankingSubView *) rankingSubView index:(int) nSelectedIndex;
- (void) actionViewPhoto:(RankingSubView *) rankingSubView index:(int) nSelectedIndex;
@end
