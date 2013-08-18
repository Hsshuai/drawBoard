//
//  DVIDrawBoardView.h
//  练习画板
//
//  Created by apple on 13-8-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVIDataClass.h"

@interface DVIDrawBoardView : UIView

@property (nonatomic,assign)float sliderValue;
@property (nonatomic ,retain)NSMutableArray *numOfArray;

- (void)addNewArray;
- (void)receivePoint:(NSString *)stringFromPoint;
- (void)preserveDatabase:(DVIDataClass *)dataClass;
- (void)setLineIndex:(CGFloat)index andBoolEraser:(BOOL)eraserFlogPara;
@end
