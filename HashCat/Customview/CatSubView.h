//
//  CatSubView.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CatSubViewDelegate;

@interface CatSubView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) id<CatSubViewDelegate> delegate;

@property (nonatomic, assign) bool m_bCreateNewButton;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property (nonatomic, assign) int m_nIndex;

@end

@protocol CatSubViewDelegate
- (void) actionViewInfo:(CatSubView *) catSubView withIndex:(NSInteger) index;
- (void) createNewOne:(CatSubView *) catSubView withIndex:(NSInteger) index;
- (void) actionAdditionalProcess:(CatSubView *) catSubView withIndex:(NSInteger) index;
@end
