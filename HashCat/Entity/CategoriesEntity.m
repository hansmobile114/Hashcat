//
//  CategoriesEntity.m
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CategoriesEntity.h"
#import "Global.h"

@implementation CategoriesEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_nDate = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"date"]] longLongValue];
            self.m_nWinsCategory = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"winsCategory"]] integerValue];
            self.m_nMashsCategory = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"mashsCategory"]] integerValue];
            self.m_category = [[CategoryEntity alloc] initWithDictInfo:[dictInfo valueForKey:@"category"]];
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
