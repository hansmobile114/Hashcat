//
//  SearchProfileView.h
//  HashCat
//
//  Created by iOSDevStar on 6/25/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchProfileViewDelegate;

@interface SearchProfileView : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, assign) int m_nIndex;
@property (nonatomic, assign) int m_nFollowIndex;

@property (nonatomic, strong) id<SearchProfileViewDelegate> delegate;

@property (assign, nonatomic) bool m_bFollowed;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UIView *m_viewContainer;

@property (weak, nonatomic) IBOutlet UIButton *m_btnAdd;
- (IBAction)actionAdd:(id)sender;

@end

@protocol SearchProfileViewDelegate
- (void) actionClickAdd:(SearchProfileView *) searchProfileView index:(int) nSelectedIndex;
- (void) actionViewProfile:(SearchProfileView *) searchProfileView index:(int) nSelectedIndex;
@end
