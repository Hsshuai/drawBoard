//
//  DVIDataClass.h
//  练习画板
//
//  Created by apple on 13-8-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class DVIDataClass;
//@protocol DVIDataClassDelegate <NSObject>
//
//- (void)reloadDataBase:(DVIDataClass *)dataClass;
//
//@end

@interface DVIDataClass : NSObject <NSCoding>

@property (nonatomic ,retain) NSMutableArray *dataArray;
@property (nonatomic , assign)BOOL eraserFlog;
@property (nonatomic ,assign) CGFloat index;
//@property (nonatomic ,assign) id <DVIDataClassDelegate> delegate;

- (void)preserveArray;
- (NSMutableArray *)checkData:(NSMutableArray *)array;

@end
