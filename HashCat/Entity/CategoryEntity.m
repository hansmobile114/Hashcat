//
//  CategoryEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import "CategoryEntity.h"
#import "Global.h"

@implementation CategoryEntity

-(id) initWithDictInfo:(NSDictionary *) dictInfo;
{
    if((self = [super init]))
    {
        if (![dictInfo isKindOfClass:[NSNull class]])
        {
            self.m_nID = (int)[[self checkAvaiablityForNumber:[dictInfo valueForKey:@"id"]] integerValue];
            self.m_bSelectable = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"selectable"]] boolValue];
            self.m_bActive = [[self checkAvaiablityForNumber:[dictInfo valueForKey:@"active"]] boolValue];
            self.m_strPhotoLink = [dictInfo valueForKey:@"photoLink"];
            self.m_strDescription = [dictInfo valueForKey:@"description"];
            self.m_strName = [dictInfo valueForKey:@"name"];
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
