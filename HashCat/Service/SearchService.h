//
//  SearchService.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface SearchService : NSObject

+ (void) searchProfiles:(NSString *) strName beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) searchHashtags:(NSString *) strName beforeId:(long) lBeforeId withDelegate:(id) pObj;
+ (void) searchCategory:(NSString *) strName beforeId:(long) lBeforeId withDelegate:(id) pObj;

@end
