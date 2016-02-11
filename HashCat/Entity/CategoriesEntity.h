//
//  CategoriesEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CategoryEntity;
@interface CategoriesEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, assign) int m_nWinsCategory;
@property (nonatomic, assign) int m_nMashsCategory;
@property (nonatomic, assign) long long m_nDate;
@property (nonatomic, strong) CategoryEntity* m_category;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
