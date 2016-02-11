//
//  PhotoEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "PhotoEntity.h"
#import "Global.h"

@implementation PhotoEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    self.m_arrCategories = [[NSMutableArray alloc] init];
    
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nCommentsCount = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"commentsCount"]] integerValue];
            self.m_nDate = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"date"]] longLongValue];
            self.m_strDescription = [dictInfo valueForKey:@"description"];
            self.m_nID = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] longLongValue];
            self.m_nLikeCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"likesCount"]] integerValue];
            self.m_strPhotoLink = [dictInfo valueForKey:@"link"];
            self.m_fMashs = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"mashs"]] floatValue];
            self.m_profile = [[ProfileEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"profile"]];
            self.m_nProfilePhoto = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"profilePhoto"]] integerValue];
            self.m_nReportCnt = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"reports"]] integerValue];
            self.m_bUserAlreadyLikes = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"userAlreadyLikes"]] boolValue];
            self.m_fWins = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"wins"]] floatValue];
            
            NSMutableArray* arrCategories = [dictInfo valueForKey:@"categories"];
            for (int nIdx = 0; nIdx < arrCategories.count; nIdx++)
            {
                NSDictionary* dictOne = [arrCategories objectAtIndex:nIdx];
                CategoriesEntity* categoriesEntity = [[CategoriesEntity alloc] initWithDictInfo:dictOne];
                [self.m_arrCategories addObject:categoriesEntity];
            }
        }
    }
    
    return self;
}

- (NSString *) checkAvaiablityForNumber:(id) pObj
{
    if ([pObj isKindOfClass:[NSNull class]])
        return @"0";
    else
        return pObj;
}

@end
