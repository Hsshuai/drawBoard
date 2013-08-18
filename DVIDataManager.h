//
//  DVIDataManager.h
//  练习画板
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVIDataClass.h"

@interface DVIDataManager : NSObject

@property(nonatomic ,retain)NSMutableArray *dataClassArray;

+ (DVIDataManager *)dafaultManager;
- (void)preserveArray;
- (void)addDataClass:(DVIDataClass *)dataClassPara;
- (void)checkData;
@end
