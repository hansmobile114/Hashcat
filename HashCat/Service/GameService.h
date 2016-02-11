//
//  GameService.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface GameService : NSObject

+ (void) categoriesWithDelegate:(id) pObj;

+ (void) mashCategory:(long) lCategoryId withCache:(bool) bCache withDelegate:(id) pObj;

+ (void) reportPhoto:(long) lPhotoId withDelegate:(id) pObj;

+ (void) voteWinner:(long) lWinnerId withLooser:(long) lLooserId withCategory:(long) lCategoryId withDelegate:(id) pObj;

@end
