//
//  AppDelegate.m
//  HashCat
//
//  Created by iOSDevStar on 6/17/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "FeedService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize m_strDeviceToken;
@synthesize m_strLatitude;
@synthesize m_strLongitude;
@synthesize m_strAuthToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    }
    
    FAKFontAwesome *naviBackIcon = [FAKFontAwesome timesCircleIconWithSize:16];
    [naviBackIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *imageClose = [naviBackIcon imageWithSize:CGSizeMake(16, 16)];

    FAKFontAwesome *naviBackHighlightIcon = [FAKFontAwesome timesCircleIconWithSize:16];
    [naviBackHighlightIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *imageHighlightClose = [naviBackHighlightIcon imageWithSize:CGSizeMake(16, 16)];

    [[UISearchBar appearance] setImage:imageClose forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:imageHighlightClose forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    
    self.m_arrCountries = [[NSMutableArray alloc] init];
    self.m_arrBreeds = [[NSMutableArray alloc] init];
    self.m_arrBadgesList = [[NSMutableDictionary alloc] init];
    self.m_arrGameCategories = [[NSMutableArray alloc] init];
    
    [self.m_arrBadgesList setValue:[[NSArray alloc] init] forKey:@"wins"];
    [self.m_arrBadgesList setValue:[[NSArray alloc] init] forKey:@"followers"];
    [self.m_arrBadgesList setValue:[[NSArray alloc] init] forKey:@"following"];
    [self.m_arrBadgesList setValue:[[NSArray alloc] init] forKey:@"likes"];
    
    self.m_currentUser = nil;
    
    self.m_bRegisterSuccess = false;
    
    m_strLongitude = @"0.0";
    m_strLatitude = @"0.0";

    m_strAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authtoken"];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    [locationManager startUpdatingLocation];
    
    m_strDeviceToken = TEST_DEVICE_TOKEN;
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

    [FBSDKLoginButton class];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    m_strLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    m_strLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *country = [[NSString alloc]initWithString:placemark.country];
             
             self.m_strCurCountryName = country;
             
             NSLog(@"%@", country);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    m_strLongitude = [NSString stringWithFormat:@"%.8f", 34.090000f];
    m_strLatitude = [NSString stringWithFormat:@"%.8f", -125.090000f];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) loadAllCountryBreedInfo
{
    nRequestMode = 1;
    [FeedService countriesWithDelegate:self];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);
    
    //    [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:@"devicetoken"];
    m_strDeviceToken = newToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.m_strDeviceToken forKey:@"deviceid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
}

-(void)AlertWithCancel_btn:(NSString*)AlertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:AlertMessage message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"continue_string", nil),nil];
        alertView.tag = 100;
        [alertView show];
    });
}

- (void) AlertSuccess:(NSString *) AlertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:SUCCESS_STRING message:AlertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"continue_string", nil) otherButtonTitles:nil];
        alertView.tag = 100;
        [alertView show];
    });
}

- (void) AlertFailure:(NSString *) AlertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:FAILTURE_STRING message:AlertMessage delegate:self cancelButtonTitle:NSLocalizedString(@"continue_string", nil)otherButtonTitles:nil];
        alertView.tag = 100;
        [alertView show];
    });
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *receivedData = [request responseString];
    
    NSArray* arrValues = [receivedData JSONValue];

    if (nRequestMode == 1)
    {
        [self.m_arrCountries removeAllObjects];
        
        for (int nIdx = 0; nIdx < arrValues.count; nIdx++)
        {
            NSDictionary* dictInfo = [arrValues objectAtIndex:nIdx];
            CountryEntity *countryEntity = [[CountryEntity alloc] initWithDictInfo:dictInfo];
            
            [self.m_arrCountries addObject:countryEntity];
        }
        
        nRequestMode = 2;
        [FeedService listAllBreedsWithDelegate:self];
    }
    
    if (nRequestMode == 2)
    {
        [self.m_arrBreeds removeAllObjects];
        
        for (int nIdx = 0; nIdx < arrValues.count; nIdx++)
        {
            NSDictionary* dictInfo = [arrValues objectAtIndex:nIdx];
            BreedEntity *countryEntity = [[BreedEntity alloc] initWithDictInfo:dictInfo];
            
            [self.m_arrBreeds addObject:countryEntity];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
    // Do the following if you use Mobile App Engagement Ads to get the deferred
    // app link after your app is installed.
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if (error) {
            NSLog(@"Received error while fetching deferred app link %@", error);
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
