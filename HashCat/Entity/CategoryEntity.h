//
//  CategoryEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryEntity : NSObject

@property (nonatomic, assign) int m_nID;
@property (nonatomic, assign) bool m_bSelectable;
@property (nonatomic, assign) bool m_bActive;
@property (nonatomic, strong) NSString * m_strPhotoLink;
@property (nonatomic, strong) NSString * m_strDescription;
@property (nonatomic, strong) NSString * m_strName;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
