//
//  Utils.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "Utils.h"
#import "Global.h"

@implementation Utils

-(id) init
{
    if((self = [super init]))
    {
    }
    return self;
}

+ (Utils *)sharedObject
{
    static Utils *objUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUtility = [[Utils alloc] init];
    });
    return objUtility;
}

- (NSString *) getCurrentLocale
{
   return [[NSLocale preferredLanguages] objectAtIndex:0];
}

- (CGFloat) getHeightOfText:(NSString *)strText fontSize:(float) fFontSize width:(float) fWidth
{
    CGFloat height = 0.0;
    CGFloat commentlabelWidth = fWidth - 10.f;
    CGRect rect = [strText boundingRectWithSize:(CGSize){commentlabelWidth, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:MAIN_FONT_NAME size:fFontSize]}
                                        context:nil];
    height = rect.size.height;
    return height;
}

-(NSString *)BirthToString:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];//2013-07-15:10:00:00
    NSString * strdate = [formatter stringFromDate:date];
    
    return strdate;
}

-(NSString *)DateToString:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];//2013-07-15:10:00:00
    NSString * strdate = [formatter stringFromDate:date];
    strdate = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    
    if ([format isEqualToString:@"MMM dd"])
    {
        float fDiffSec = [[NSDate date] timeIntervalSinceDate:date];
        if (fDiffSec < 30)
            strdate = NSLocalizedString(@"a few seconds ago", nil);
        else if (fDiffSec / 60 < 60)
        {
            int fVal = (int)(fDiffSec / 60);
            if (fVal == 1)
                strdate = NSLocalizedString(@"1 minute ago", nil);
            else
                strdate = [NSString stringWithFormat:@"%d %@", fVal, NSLocalizedString(@"minutes ago", nil)];
        }
        else if (fDiffSec / 3600 < 24)
        {
            int fVal = (int)(fDiffSec / 3600);
            if (fVal == 1)
                strdate = NSLocalizedString(@"1 hour ago", nil);
            else
                strdate = [NSString stringWithFormat:@"%d %@", fVal, NSLocalizedString(@"hours ago", nil)];
        }
        else if (fDiffSec / 3600 / 24 <= 3)
        {
            int fVal = (int)(fDiffSec / 3600 / 24);
            if (fVal == 1)
                strdate = NSLocalizedString(@"1 day ago", nil);
            else
                strdate = [NSString stringWithFormat:@"%d %@", fVal, NSLocalizedString(@"days ago", nil)];
        }
        
        NSLog(@"%f", fDiffSec);
    }
    
    return strdate;
}

- (NSDate *) StringToDate:(NSString *) strDate withFormat:(NSString *)format;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];//2013-07-15:10:00:00
    NSDate* date = [formatter dateFromString:strDate];
    
    return date;
}

- (NSString *) timeInMiliSeconds:(NSDate *) date
{
    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    return timeInMS;
}

- (NSDate *) getDateFromMilliSec:(long long) lMilliSeconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(lMilliSeconds / 1000)];
    
    return date;
}

- (NSDate *) getDateFromNorSec:(long long) lNorSec
{
    NSDate* curDate = [NSDate date];
    
    NSDate* date = [NSDate dateWithTimeInterval:-1 * lNorSec / 1000 / 60 sinceDate:curDate];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([@(floor([curDate timeIntervalSince1970])) longLongValue] - lNorSec / 1000)];
    
    return date;
}

-(UIImage*) scaleAndCropImage:(UIImage *) imgSource toSize:(CGSize)newSize
{
    float ratio = imgSource.size.width / imgSource.size.height;
    
    UIGraphicsBeginImageContext(newSize);
    
    if (ratio > 1) {
        CGFloat newWidth = ratio * newSize.width;
        CGFloat newHeight = newSize.height;
        CGFloat leftMargin = (newWidth - newHeight) / 2;
        [imgSource drawInRect:CGRectMake(-leftMargin, 0, newWidth, newHeight)];
    }
    else {
        CGFloat newWidth = newSize.width;
        CGFloat newHeight = newSize.height / ratio;
        CGFloat topMargin = (newHeight - newWidth) / 2;
        [imgSource drawInRect:CGRectMake(0, -topMargin, newSize.width, newSize.height/ratio)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSString *)urlEncodeWithString: (NSString*)string
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (CFStringRef)string,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();+$,%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return (NSString *)CFBridgingRelease(urlString);
}

- (NSString *) makeAPIURLString:(NSString *)strActionName
{
    NSString* strUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, strActionName];
    return  strUrl;
}


- (void) saveImageToLocal:(UIImage *)image withName:(NSString *) strName
{
    NSData *pngData = UIImageJPEGRepresentation(image, 0.6);
    
    NSString *filePath = [DOCUMENTS_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", strName]];
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    pngData  = nil;
}

- (UIImage *) readImageFromLocal:(NSString *) strName
{
    UIImage* image = nil;
    NSString *filePath = [DOCUMENTS_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", strName]];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    if (imgData)
        image = [[UIImage alloc] initWithData:imgData];
    imgData = nil;
    
    return  image;
}

- (NSString *) getImageNameFromLink:(NSString *) strResourceLink
{
    NSString* strFileName = @"";
    NSArray* arrayStrings = [strResourceLink componentsSeparatedByString:@"/"];
    if (arrayStrings.count == 0)
        strFileName = @"nophoto";
    else
    {
        if ([strResourceLink rangeOfString:@"facebook"].location == NSNotFound)
            strFileName = [arrayStrings lastObject];
        else
        {
            int nArrCnt = (int)arrayStrings.count;
            strFileName = [arrayStrings objectAtIndex:nArrCnt - 2];
        }
    }
    
    return strFileName;
}

-(UIImage *)rn_boxblurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath image:(UIImage *)processImage
{
    if (!processImage)
        return nil;
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = processImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    // create unchanged copy of the area inside the exclusionPath
    UIImage *unblurredImage = nil;
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo) kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    // overlay images?
    if (unblurredImage != nil) {
        UIGraphicsBeginImageContext(returnImage.size);
        [returnImage drawAtPoint:CGPointZero];
        [unblurredImage drawAtPoint:CGPointZero];
        
        returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

-(BOOL)validateEmail:(NSString*)email
{
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) )
    {
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else
        return NO;
}


-(UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius
{
    CALayer *imageLayer = [CALayer layer];
    NSLog(@"size =%f, %f", image.size.width, image.size.height);
    
    float fFinalSize = image.size.width;
    if (image.size.width > image.size.height)
        fFinalSize = image.size.height;
    
    imageLayer.frame = CGRectMake(0, 0, fFinalSize, fFinalSize);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = fFinalSize / 2.f;
    
    UIGraphicsBeginImageContext(CGSizeMake(fFinalSize, fFinalSize));
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

- (void) makeNormalImage:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget;
{
    if ([strPhoto isKindOfClass:[NSNull class]]) return;
    if (strPhoto == nil || [strPhoto isEqualToString:@""]) return;
    
    float fRadius = 0.f;
    if (imageViewTaget.frame.size.width > imageViewTaget.frame.size.height)
        fRadius = imageViewTaget.frame.size.height / 2.f;
    else
        fRadius = imageViewTaget.frame.size.width / 2.f;
    
    NSString* strFileName = [self getImageNameFromLink:strPhoto];
    UIImage *image = [self readImageFromLocal:strFileName];
    if (image)
    {
        imageViewTaget.image = image;
    }
    else
    {
        __block UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.center = CGPointMake(imageViewTaget.frame.size.width / 2, imageViewTaget.frame.size.height / 2);
        activityView.color = MAIN_COLOR;
        [imageViewTaget addSubview:activityView];
        [activityView startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            NSURL* urlWithString = [NSURL URLWithString:strPhoto];
            __block NSData* imageData = [NSData dataWithContentsOfURL:urlWithString];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                UIImage* downloadedImage = [UIImage imageWithData:imageData];
                [[Utils sharedObject] saveImageToLocal:downloadedImage withName:strFileName];
                imageViewTaget.image = downloadedImage;
                
                [activityView stopAnimating];
                activityView.hidden = YES;
                [activityView removeFromSuperview];
                activityView = nil;
                
                imageData = nil;
                downloadedImage = nil;
            });
        });
    }
}

- (void) makeBlurImage:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget;
{
    imageViewTaget.image = [self rn_boxblurImageWithBlur:0.6f exclusionPath:nil image:[UIImage imageNamed:@"bg_patas.png"]];
    
    if ([strPhoto isKindOfClass:[NSNull class]]) return;
    if (strPhoto == nil || [strPhoto isEqualToString:@""]) return;
    
    float fRadius = 0.f;
    if (imageViewTaget.frame.size.width > imageViewTaget.frame.size.height)
        fRadius = imageViewTaget.frame.size.height / 2.f;
    else
        fRadius = imageViewTaget.frame.size.width / 2.f;
    
    NSString* strFileName = [self getImageNameFromLink:strPhoto];
    UIImage *image = [self readImageFromLocal:strFileName];
    if (image)
    {
        imageViewTaget.image = [self rn_boxblurImageWithBlur:0.6f exclusionPath:nil image:image];
    }
    else
    {
        __block UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.center = CGPointMake(imageViewTaget.frame.size.width / 2, imageViewTaget.frame.size.height / 2);
        activityView.color = MAIN_COLOR;
        [imageViewTaget addSubview:activityView];
        [activityView startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            NSURL* urlWithString = [NSURL URLWithString:strPhoto];
            __block NSData* imageData = [NSData dataWithContentsOfURL:urlWithString];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                UIImage* downloadedImage = [UIImage imageWithData:imageData];
                [[Utils sharedObject] saveImageToLocal:downloadedImage withName:strFileName];
                imageViewTaget.image = [self rn_boxblurImageWithBlur:0.6f exclusionPath:nil image:downloadedImage];
                
                [activityView stopAnimating];
                activityView.hidden = YES;
                [activityView removeFromSuperview];
                activityView = nil;
                
                imageData = nil;
                downloadedImage = nil;
            });
        });
    }
}

- (void) loadImageFromServerAndLocal:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget
{
    if ([strPhoto isKindOfClass:[NSNull class]]) return;
    if (strPhoto == nil || [strPhoto isEqualToString:@""]) return;
    
    float fRadius = 0.f;
    if (imageViewTaget.frame.size.width > imageViewTaget.frame.size.height)
        fRadius = imageViewTaget.frame.size.height / 2.f;
    else
        fRadius = imageViewTaget.frame.size.width / 2.f;
    
    __weak UIImageView* curImageView = imageViewTaget;

    /*
    [curImageView setImageWithURL:[NSURL URLWithString:strPhoto] placeholderImage:[UIImage imageNamed:@"ic_hashcat_silhouete_200.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     */
    
    [curImageView setImageWithURL:[NSURL URLWithString:strPhoto] placeholderImage:[UIImage imageNamed:@"ic_hashcat_silhouete_200.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if (image)
        {
            curImageView.image = [[Utils sharedObject] makeRoundedImage:image radius:fRadius];

        }
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void) loadImageFromServerAndLocalWithoutRound:(NSString *) strPhoto imageView:(UIImageView *)imageViewTaget
{
    if ([strPhoto isKindOfClass:[NSNull class]]) return;
    if (strPhoto == nil || [strPhoto isEqualToString:@""]) return;
    
    float fRadius = 0.f;
    if (imageViewTaget.frame.size.width > imageViewTaget.frame.size.height)
        fRadius = imageViewTaget.frame.size.height / 2.f;
    else
        fRadius = imageViewTaget.frame.size.width / 2.f;
    
    [imageViewTaget setImageWithURL:[NSURL URLWithString:strPhoto] placeholderImage:[UIImage imageNamed:@"ic_hashcat_silhouete_200.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (NSString *) getBadgeImageName:(BadgeEntity *) badgeEntity
{
    NSString* strBadgeImageName = @"";
    
    NSString* strBageTrigger = badgeEntity.m_strTrigger;
    if ([strBageTrigger isEqualToString:@"WINS"])
    {
        NSLog(@"win = %d", badgeEntity.m_nWin);
        
        if (badgeEntity.m_nWin < 1000)
            strBadgeImageName = @"badge_wins_bronze.png";
        else if ((badgeEntity.m_nWin >= 1000) && (badgeEntity.m_nWin < 100 * 1000))
            strBadgeImageName = @"badge_wins_silver.png";
        else if (badgeEntity.m_nWin >= 100 * 1000)
            strBadgeImageName = @"badge_wins_gold.png";
    }

    if ([strBageTrigger isEqualToString:@"LIKES"])
    {
        if (badgeEntity.m_nLikes < 2.5 * 1000)
            strBadgeImageName = @"badge_likes_bronze.png";
        else if ( (badgeEntity.m_nLikes >= 2.5 * 1000) && (badgeEntity.m_nLikes < 500 * 1000))
            strBadgeImageName = @"badge_likes_silver.png";
        else if(badgeEntity.m_nLikes >= 500 * 1000)
            strBadgeImageName = @"badge_likes_gold.png";
    }

    if ([strBageTrigger isEqualToString:@"FOLLOWERS"])
    {
        NSLog(@"followers = %d", badgeEntity.m_nValue);

        if (badgeEntity.m_nValue < 1000)
            strBadgeImageName = @"badge_followers_bronze.png";
        else if ((badgeEntity.m_nValue >= 1000) && (badgeEntity.m_nValue < 100 * 1000))
            strBadgeImageName = @"badge_followers_silver.png";
        else if (badgeEntity.m_nValue >= 100 * 1000)
            strBadgeImageName = @"badge_followers_gold.png";
    }

    if ([strBageTrigger isEqualToString:@"FOLLOWING"])
    {
        NSLog(@"following = %d", badgeEntity.m_nValue);

        if (badgeEntity.m_nValue < 25)
            strBadgeImageName = @"badge_following_bronze.png";
        else if ((badgeEntity.m_nValue >= 25) && (badgeEntity.m_nValue < 500))
            strBadgeImageName = @"badge_following_silver.png";
        else if (badgeEntity.m_nValue >= 500)
            strBadgeImageName = @"badge_following_gold.png";
    }

    if ([strBageTrigger isEqualToString:@"RANKING_POSITION"])
    {
        if (badgeEntity.m_nRankingPosition == 1)
            strBadgeImageName = @"badge_ranking_position_gold.png";
        else if (badgeEntity.m_nRankingPosition == 2)
            strBadgeImageName = @"badge_ranking_position_silver.png";
        else if (badgeEntity.m_nRankingPosition == 3)
            strBadgeImageName = @"badge_ranking_position_bronze.png";
        else
            strBadgeImageName = @"badge_ranking_position_default.png";
    }
    
    return strBadgeImageName;
}

- (bool) checkMyProfileId:(PhotoEntity *)photoEntity
{
    //check whether this photo is current user's
    bool bExist = false;
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrProfiles.count; nIdx++)
    {
        ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nIdx];
        if ([photoEntity.m_profile.m_strUsername isEqualToString:profileEntity.m_strUsername])
        {
            bExist = true;
            break;
        }
    }
    
    return bExist;
}

- (bool) checkMyProfileIdWithProfileInfo:(ProfileEntity *)profileEntity
{
    //check whether this photo is current user's
    bool bExist = false;
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrProfiles.count; nIdx++)
    {
        ProfileEntity* myProfileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nIdx];
        if ([myProfileEntity.m_strUsername isEqualToString:profileEntity.m_strUsername])
        {
            bExist = true;
            break;
        }
    }
    
    return bExist;
}

- (bool) checkMyProfileIdWithOnlyUsername:(NSString *) strUserName
{
    //check whether this photo is current user's
    bool bExist = false;
    for (int nIdx = 0; nIdx < g_Delegate.m_currentUser.m_arrProfiles.count; nIdx++)
    {
        ProfileEntity* profileEntity = [g_Delegate.m_currentUser.m_arrProfiles objectAtIndex:nIdx];
        if ([strUserName isEqualToString:profileEntity.m_strUsername])
        {
            bExist = true;
            break;
        }
    }
    
    return bExist;
}

- (NSString *) getLikes:(long) lLikes
{
    NSString* strLikes = @"";
    
    int nQuad = (int)(lLikes / 1000);
    if (nQuad >= 1)
    {
        strLikes = [NSString stringWithFormat:@"%dK", nQuad];
        
        nQuad /= 1000;
        if (nQuad >= 1)
            strLikes = [NSString stringWithFormat:@"%dM", nQuad];
    }
    else
        strLikes = [NSString stringWithFormat:@"%ld", lLikes];
    
    return strLikes;
}

- (bool) loadSettings:(NSString *) strField
{
    bool bValue = [[NSUserDefaults standardUserDefaults] boolForKey:strField];
    if (bValue)
        return false;
    else
        return true;
}

- (void) saveSettings:(NSString *) strField value:(bool) bValue
{
    if (bValue)
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:strField];
    else
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:strField];
    
}

- (void) makeShadowEffect:(UIView *) targetView radius:(float) fRadius color:(UIColor *) shadowColor corner:(float) fCornerRadius
{
    targetView.layer.shadowRadius = fRadius;
    targetView.layer.masksToBounds = NO;
    [[targetView layer] setShadowColor:shadowColor.CGColor];
    [[targetView layer] setShadowOffset:CGSizeMake(0,0)];
    [[targetView layer] setShadowOpacity:1];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds cornerRadius:fCornerRadius];
    [[targetView layer] setShadowPath:[path1 CGPath]];

}

- (void) makeBoxShadowEffect:(UIView *) targetView radius:(float) fRadius color:(UIColor *) shadowColor corner:(float) fCornerRadius
{
    targetView.layer.shadowRadius = fRadius;
    targetView.layer.masksToBounds = NO;
    [[targetView layer] setShadowColor:shadowColor.CGColor];
    [[targetView layer] setShadowOffset:CGSizeMake(fRadius - 1,fRadius)];
    [[targetView layer] setShadowOpacity:1];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds cornerRadius:fCornerRadius];
    [[targetView layer] setShadowPath:[path1 CGPath]];
}

@end
