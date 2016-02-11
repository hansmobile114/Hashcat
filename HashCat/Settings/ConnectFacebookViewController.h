//
//  ConnectFacebookViewController.h
//  HashCat
//
//  Created by iOSDevStar on 7/8/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectFacebookViewController : UIViewController
{
    bool bLogin;
    
    NSString* strFBUserBirthTime;
}

@property (weak, nonatomic) IBOutlet UIView *m_subView;

@property (weak, nonatomic) IBOutlet UIButton *m_btnConnectFB;
- (IBAction)actionConnectFacebook:(id)sender;
@end
