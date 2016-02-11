//
//  CommentViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/28/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoEntity;

@interface CommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    int nRequestMode;
    
    long lBeforeId;
    long lSinceId;
    
    bool bLoad;
    
    bool bDirectionMode;

    UITextField *txtFieldComment;
    UIImageView* userImageView;
}

@property (nonatomic, assign) long m_nPhotoId;
@property (nonatomic, strong) PhotoEntity* m_photoEntity;

@property (nonatomic, strong)  NSMutableArray* m_arrayResult;
@property (nonatomic, strong)  NSMutableArray* m_arrayData;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *m_toolBar;

@end
