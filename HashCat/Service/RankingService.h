//
//  RankingService.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface RankingService : NSObject

+ (void) filterWithCategoryId:(long) lCategoryId withBreedId:(long) lBreedId withCountryId:(long) lCountryId withMonthsMin:(int) nMonthsMin withMonthsMax:(int) nMonthsMax withOrderByLikes:(bool) bOrderByLikes withDelegate:(id) pObj;

@end
