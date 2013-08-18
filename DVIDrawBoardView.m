//
//  DVIDrawBoardView.m
//  练习画板
//
//  Created by apple on 13-8-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//1.取得坐标
//2.把坐标传到UIView中去
//3.在UIView中画出来

#import "DVIDrawBoardView.h"
#import "DVIDataManager.h"

@interface DVIDrawBoardView()
{
    UIView *_view;
    
    
    BOOL eraserFlog;
    BOOL pencilFlog;
    
}
@end

@implementation DVIDrawBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _numOfArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor yellowColor];

        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 300, self.frame.size.width, self.frame.size.height - 300)];
        _view.backgroundColor = [UIColor colorWithRed:241 green:241 blue:241 alpha:0.5];
//        _view.alpha = 0.5;
//        [self addSubview:_view];
//        [_view release];
        _view.alpha = 0;
        
        [self addRescindButton];
        [self addEraserButton];
        [self addPencilButton];
        eraserFlog = NO;
        pencilFlog = NO;
        [self addPreserveButton];
        [self openContentButton];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark- 封装按钮方法
- (void)addRescindButton
{
    UIButton *rescindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rescindButton.frame = CGRectMake(0, 0, 100, 40);
    rescindButton.backgroundColor = [UIColor blueColor];
    [rescindButton setTitle:@"撤销" forState:UIControlStateNormal];
    [rescindButton addTarget:self action:@selector(rescindArrayLine) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:rescindButton];
}

- (void)addEraserButton
{
    UIButton *eraserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eraserButton.frame = CGRectMake(self.frame.size.width - 45, 0 , 45, 45);
    [eraserButton setBackgroundImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [eraserButton addTarget:self action:@selector(eraserAction) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:eraserButton];
}

- (void)addPencilButton
{
    UIButton *pencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pencilButton.frame = CGRectMake(self.frame.size.width - 90, 0 , 45, 45);
    [pencilButton setBackgroundImage:[UIImage imageNamed:@"pencil.png"] forState:UIControlStateNormal];
    [pencilButton addTarget:self action:@selector(pencilAction) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:pencilButton];
}

- (void)addPreserveButton
{
    UIButton *preserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    preserveButton.frame = CGRectMake(self.frame.size.width - 150, 0 , 45, 45);
    [preserveButton setTitle:@"保存" forState:UIControlStateNormal];
    [preserveButton setBackgroundColor:[UIColor redColor]];
    [preserveButton addTarget:self action:@selector(preserveAction) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:preserveButton];
}

- (void)openContentButton
{
    UIButton *openContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openContentButton.frame = CGRectMake(self.frame.size.width - 200, 0 , 45, 45);
    [openContentButton setTitle:@"打开" forState:UIControlStateNormal];
    [openContentButton setBackgroundColor:[UIColor greenColor]];
    [openContentButton addTarget:self action:@selector(openContentAction) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:openContentButton];
}



#pragma mark- 按钮方法
- (void)rescindArrayLine
{
    [_numOfArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)eraserAction
{
    eraserFlog = YES;
}

- (void)pencilAction
{
//    pencilFlog = YES;
    eraserFlog = NO;
}

//- (void)preserveAction
//{
//    for (DVIDataClass *dataClass in _numOfArray) {
////         [dataClass preserveArray];
//        DVIDataManager *dataManager = [DVIDataManager dafaultManager];
//        [dataManager preserveArray];
//    }
//   
//}

- (void)openContentAction
{
    DVIDataClass *dataClass = [[DVIDataClass alloc] init];
    _numOfArray = [dataClass checkData:_numOfArray];
    //[_numOfArray addObject:dataClass];
    [self setNeedsDisplay];
}

//- (void)sliderAction
//{
//    
//}


#pragma mark- 添加数组元素
- (void)receivePoint:(NSString *)stringFromPoint
{
    DVIDataManager *dataManager = [DVIDataManager dafaultManager];
    NSMutableArray *lastPointsArray = ((DVIDataClass *)[dataManager.dataClassArray lastObject]).dataArray;
    [lastPointsArray addObject:stringFromPoint];
}

- (void)addNewArray
{
    DVIDataClass *dataClass = [[DVIDataClass alloc] init];
//    dataClass.delegate=self;
//    if (eraserFlog == YES) {
//        dataClass.index = 2;
//    }
//    else if(pencilFlog == YES){
//        dataClass.index = 1;
//    }
    dataClass.index = _sliderValue;
    dataClass.eraserFlog = eraserFlog;
    DVIDataManager *dataManager = [DVIDataManager dafaultManager];
    [dataManager addDataClass:dataClass];
    [dataClass release];
}

#pragma mark- 画布
- (void)drawRect:(CGRect)rect
{
    [self drawLine];
}

- (void)drawLine
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGPoint firstPoint = CGPointFromString((NSString *)[_pointArray objectAtIndex:0]);
    //需要什么?1.起始点.2.数组.
    DVIDataManager *dataManager = [DVIDataManager dafaultManager];
    NSLog(@"%p",dataManager.dataClassArray);
    for (int i = 0; i < [dataManager.dataClassArray count]; i ++) {

        DVIDataClass *dataClass = [dataManager.dataClassArray objectAtIndex:i];
        NSString *firstPointStr = [dataClass.dataArray objectAtIndex:0];
        NSLog(@"%@",firstPointStr);
        CGPoint firstPoint = CGPointFromString(firstPointStr);
        CGContextMoveToPoint(context,firstPoint.x, firstPoint.y);
        //CGContextMoveToPoint(context, _firstPoint.x, _firstPoint.y);
        for (int j = 1; j < [dataClass.dataArray count]; j++) {
            CGPoint point = CGPointFromString((NSString *)[dataClass.dataArray objectAtIndex:j]);
            CGContextAddLineToPoint(context,point.x , point.y);
        }
//        if (eraserFlog == YES) {
//            [[UIColor yellowColor] setStroke];
//        }
//        else if(eraserFlog == NO)
//        {
//            [[UIColor blackColor] setStroke];
//        }
        
        if (dataClass.eraserFlog == YES) {
            [[UIColor yellowColor] setStroke];
        }
        else{
            [[UIColor blackColor] setStroke];
        }
        CGContextSetLineWidth(context, dataClass.index);
        //(context, kCGLineCapRound);//设置连接点样式
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    
}

#pragma mark- 接收setting中数据
- (void)setLineIndex:(CGFloat)index andBoolEraser:(BOOL)eraserFlogPara
{
    _sliderValue = index;
    eraserFlog = eraserFlogPara;
}

#pragma mark- 接收数据库
- (void)preserveDatabase:(DVIDataClass *)dataClass
{
    [_numOfArray addObject:dataClass];
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [_numOfArray release];
    _numOfArray = nil;
    [super dealloc];
}
@end
