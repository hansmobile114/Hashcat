//
//  ViewController.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    int nRequestMode;
    
    NSString* strUsername;//FB : facebookid
    NSString* strPassword;//FB : accesstoken
    
    NSMutableDictionary* dictFBUserInfo;
    
    NSString* strFBUserBirthTime;
}

- (IBAction)actionFacebook:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *m_btnFacebook;
@end

