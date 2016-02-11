//
//  Utils.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BadgeEntity;
@class PhotoEntity;
@class ProfileEntity;

@interface Utils : NSObject

-(id) init;
+ (Utils *)sharedObject;

- (NSString *) getCurrentLocale;

- (CGFloat) getHeightOfText:(NSString *)strText fontSize:(float) fFontSize width:(float) fWidth;

- (NSString *)urlEncodeWithString: (NSString*)string;

- (NSString *)DateToString:(NSDate *)date withFormat:(NSString *)format;
- (NSDate *) StringToDate:(NSString *) strDate withFormat:(NSString *)format;
- (NSString *) timeInMiliSeconds:(NSDate *) date;
- (NSDate *) getDateFromMilliSec:(long long) lMilliSeconds;
- (NSDate *) getDateFromNorSec:(long long) lNorSec;
- (NSString *)BirthToString:(NSDate *)date withFormat:(NSString *)format;

- (NSString *) makeAPIURLString:(NSString *)strActionName;

- (void) saveImageToLocal:(UIImage *)image withName:(NSString *) strName;
- (UIImage *) readImageFromLocal:(NSString *) strName;

- (NSString *) getImageNameFromLink:(NSString *) strResourceLink;
-(UIImage*) scaleAndCropImage:(UIImage *) imgSource toSize:(CGSize)newSize;

-(UIImage *)rn_boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath image:(UIImage *)processImage;

-(BOOL)validateEmail:(NSString*)email;

- (void) makeNormalImage:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget;
-(UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;

- (void) loadImageFromServerAndLocal:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget;
- (void) loadImageFromServerAndLocalWithoutRound:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget;

- (void) makeBlurImage:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget;
- (NSString *) getBadgeImageName:(BadgeEntity *) badgeEntity;

- (bool) checkMyProfileId:(PhotoEntity *) photoEntity;
- (bool) checkMyProfileIdWithOnlyUsername:(NSString *) strUserName;
- (bool) checkMyProfileIdWithProfileInfo:(ProfileEntity *)profileEntity;

- (NSString *) getLikes:(long) lLikes;

- (bool) loadSettings:(NSString *) strField;
- (void) saveSettings:(NSString *) strField value:(bool) bValue;

- (void) makeShadowEffect:(UIView *) targetView radius:(float) fRadius color:(UIColor *) shadowColor corner:(float) fCornerRadius;
- (void) makeBoxShadowEffect:(UIView *) targetView radius:(float) fRadius color:(UIColor *) shadowColor corner:(float) fCornerRadius;

@end
