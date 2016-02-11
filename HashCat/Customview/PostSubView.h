//
//  PostSubView.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResponsiveLabel;

@protocol PostSubViewDelegate;

@interface PostSubView : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, assign) int m_nIndex;
@property (weak, nonatomic) IBOutlet UIView *mn_viewContainer;

@property (nonatomic, strong) id<PostSubViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *m_userImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgClock;

@property (weak, nonatomic) IBOutlet UIImageView *m_postImageView;
- (IBAction)actionViewProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLikeB;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCommentB;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLikeImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCommentImage;

@property (weak, nonatomic) IBOutlet UIView *m_viewAction;
- (IBAction)actionLike:(id)sender;
- (IBAction)actionComment:(id)sender;
- (IBAction)actionSeeLikeUsers:(id)sender;

@property (weak, nonatomic) IBOutlet ResponsiveLabel *m_lblPostText;

@property (weak, nonatomic) IBOutlet UIView *m_viewBottomPart;

@property (weak, nonatomic) IBOutlet UIView *m_viewCategory;

- (IBAction)actionReport:(id)sender;

@end

@protocol PostSubViewDelegate<NSObject>
- (void) actionViewProfile:(PostSubView *) subView withIndex:(int) nIndex;
- (void) actionClickLikeUsers:(PostSubView *) subView withIndex:(int) nIndex;
- (void) actionClickLike:(PostSubView *) subView withIndex:(int) nIndex;
- (void) actionClickComment:(PostSubView *) subView withIndex:(int) nIndex;
- (void) actionClickReport:(PostSubView *) subView withIndex:(int) nIndex;
- (void) actionClickHashTag:(PostSubView *) subView withString:(NSString *) strHashTag;
- (void) actionClickUserName:(PostSubView *) subView withString:(NSString *) strUsername;
@end