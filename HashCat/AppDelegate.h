//
//  AppDelegate.h
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class UserEntity;
@class MenuTabViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate
, CLLocationManagerDelegate>
{
    int nRequestMode;
    CLLocationManager *locationManager;
}

@property (nonatomic, assign) bool m_bHasBottomBar;

@property (nonatomic, assign) bool m_bRegisterSuccess;

@property (nonatomic, assign) MenuTabViewController* m_curMenuTabViewCon;

@property (nonatomic, assign) int m_nAppLoginMode;

@property (nonatomic, strong) UserEntity* m_currentUser;

@property (nonatomic, strong) NSString* m_strLatitude;
@property (nonatomic, strong) NSString* m_strLongitude;

@property (nonatomic, strong) NSString* m_strDeviceToken;

@property (nonatomic, strong) NSString* m_strAuthToken;

@property (nonatomic, strong) NSString* m_strCurCountryName;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray* m_arrCountries;
@property (strong, nonatomic) NSMutableDictionary* m_arrBadgesList;
@property (strong, nonatomic) NSMutableArray* m_arrBreeds;
@property (strong, nonatomic) NSMutableArray* m_arrGameCategories;

-(void)AlertWithCancel_btn:(NSString*)AlertMessage;
- (void) AlertSuccess:(NSString *) AlertMessage;
- (void) AlertFailure:(NSString *) AlertMessage;

- (void) loadAllCountryBreedInfo;

@end

