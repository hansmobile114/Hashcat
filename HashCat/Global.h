//
//  Global.h
//  Education
//
//  Created by QingLong on 18/03/15.
//  Copyright (c) 2015 QingLong. All rights reserved.
//

#ifndef Education_Global_h
#define Education_Global_h

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <Foundation/Foundation.h>
#import "FontAwesomeKit.h"
#import "MBProgressHUD.h"
#import "UIImage+fixOrientation.h"
#import "UIImage+Utility.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "UserDefaultHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FacebookUtility.h"
#import "Utils.h"
#import "SVPullToRefresh.h"
#import "YXSpritesLoadingView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserEntity.h"
#import "ProfileEntity.h"
#import "PhotoEntity.h"
#import "CountryEntity.h"
#import "BreedEntity.h"
#import "FollowEntity.h"
#import "BadgeEntity.h"
#import "BadgesAcquiredEntity.h"
#import "FollowerEntity.h"
#import "OwnerEntity.h"
#import "GetProfileEntity.h"
#import "HMSegmentedControl.h"
#import "NotificationEntity.h"
#import "CategoriesEntity.h"
#import "CategoryEntity.h"
#import "ResponsiveLabel.h"
#import "DWTagList.h"
#import "DAKeyboardControl.h"
#import "CommentEntity.h"
#import "GameCategoryEntity.h"
#import "TLTagsControl.h"
#import "KxMenu.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define APP_FULL_NAME           @"HashCat"
#define APP_VERSION             @"1.09"
#define ITUNES_APP_ID           @"121332332"

#define DOCUMENTS_PATH          [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define MENU_TAB_HEIGHT         50.f

#define ICON_SIZE               24
#define NAVI_ICON_SIZE          24
#define TAB_ICON_SIZE           36

#define FACEBOOK_LOGIN          100
#define EMAIL_LOGIn             110

#define INDICATOR_ANIMATION     0.2f
#define NAVI_BUTTON_OFFSET      -8.f

#define NAVI_COLOR              [UIColor colorWithRed:253.f/255.f green:150.f/255.f blue:39.f/255.f alpha:1.0f]
#define MAIN_COLOR              [UIColor colorWithRed:245.f/255.f green:124.f/255.f blue:0.f/255.f alpha:1.0f]
#define BOX_SHADOW_COLOR        [UIColor colorWithRed:200.f / 255.f green:200.f / 255.f blue:200.f / 255.f alpha:1.f]
#define CONTAINER_SHADOW_COLOR  [UIColor colorWithRed:128.f / 255.f green:128.f / 255.f blue:128.f / 255.f alpha:1.f]
#define DISABLE_COLOR           [UIColor grayColor]

#define MAIN_FONT_NAME          @"Avenir-Book"
#define MAIN_BOLD_FONT_NAME     @"Avenir-Black"

#define SERVER_URL              @"http://hashcat.com.br"

#define RATING_CYCLE            3 //days

#define CORNER_RADIUS           3

#define MAX_TITLE               50
#define MAX_DESCRITPION         500

#define CAT_SUB_VIEW_HEIGHT     115.f

#define SUCCESS_STRING          NSLocalizedString(@"success_alert_string", nil)
#define FAILTURE_STRING         NSLocalizedString(@"failure_alert_string", nil)

#define NET_CONNECTION_ERROR    NSLocalizedString(@"network_offline_alert_title", nil)
#define SOMETHING_WRONG         NSLocalizedString(@"something_went_wrong", nil)

#define REFRESH_HEIGHT          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 120.f:240.f)

#define STORYBOARD_NAME          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"Main":@"Main_iPad")

#define g_Delegate              ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define POST_TEXT_PLACEHOLDER   NSLocalizedString(@"post_text_placeholder", nil)

#define TEST_DEVICE_TOKEN       @"12123423123321"
#define DEVICE_MODEL            @"iOS"

typedef enum {
    PRO,
    SUPPORTING,
    WINS,
    LIKES,
    FOLLOWERS,
    FOLLOWING,
    RANKING_POSITION
} BadgeTriggerType;

#define getBadgeTriggerType(enum) [@[@"PRO",@"SUPPORTING",@"WINS",@"LIKES",@"FOLLOWERS",@"FOLLOWING",@"RANKING_POSITION"] objectAtIndex:enum]

#define MAX_NOTIFICATIONS       20
#define MAX_COMMENT             10
#define MAX_FOLLOW              5
#define MAX_FEED                25
#define MAX_SEARCH              20
#define MAX_FRIENDS             100

//SETTING CONSTANTS
#define NOTIFICATION_SETTING    @"notification"
#define NOTIFICATION_MENOW      @"notificationmeow"
#define SAVE_PHOTOS_SETTING     @"savephotos"


//HELP INDEX
#define HELP_NONE               799
#define HELP_PLAY               800
#define HELP_RANKING            801
#define HELP_FEED               802
#define HELP_TOTAL              803

#endif
