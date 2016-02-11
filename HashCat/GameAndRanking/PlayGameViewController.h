//
//  PlayGameViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/4/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameCategoryEntity;
@class PhotoEntity;
@class ASIFormDataRequest;

#define MASH_REQUEST        50
#define VOTE_REQUEST        51
#define FOLLOW_REQUEST      52
#define REPORT_REQUEST      53

@interface PlayGameViewController : UIViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    int nRequestMode;
    PhotoEntity* photoEntityOne;
    PhotoEntity* photoEntityTwo;
    
    long lWinnerId;
    long lLooseId;
    
    bool bFollowOne;
    int nFollowOneIndex;
    
    bool bFollowTwo;
    int nFollowTwoIndex;
    
    bool bWhichCatFollow;
}

@property (nonatomic, strong) GameCategoryEntity* m_categoryEntity;
@property (weak, nonatomic) IBOutlet UIImageView *m_topImageView;

- (IBAction)actionReport:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *m_viewCat1;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCat1;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageCat1;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFollow1;
@property (weak, nonatomic) IBOutlet UIButton *m_btnViewInfo1;

- (IBAction)actionFollow1:(id)sender;
- (IBAction)actionViewCat1:(id)sender;
- (IBAction)actionViewInfo1:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *m_viewCat2;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCat2;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageCat2;
@property (weak, nonatomic) IBOutlet UIButton *m_btnFollow2;
@property (weak, nonatomic) IBOutlet UIButton *m_btnViewInfo2;

- (IBAction)actionFollow2:(id)sender;
- (IBAction)actionViewCat2:(id)sender;
- (IBAction)actionViewInfo2:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *m_viewCatInfo;
@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;
- (IBAction)actionViewClose:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *m_imageLogo;


@end
