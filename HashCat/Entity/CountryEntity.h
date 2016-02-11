//
//  CountryEntity.h
//  HashCat
//
//  Created by iOSDevStar on 6/18/15.
//  Copyright (c) 2015 iOSDevStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CountryEntity : NSObject

@property (nonatomic, strong) NSString* m_strCode;
@property (nonatomic, assign) int m_nID;
@property (nonatomic, strong) NSString* m_strName;

-(id) initWithDictInfo:(NSDictionary *) dictInfo;

@end
