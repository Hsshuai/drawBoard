//
//  DVIDataManager.m
//  练习画板
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DVIDataManager.h"
#import <sqlite3.h>


static DVIDataManager *instance = nil;
@interface DVIDataManager()
{
    sqlite3 *_sqlite;
}
@end

@implementation DVIDataManager


+ (DVIDataManager *)dafaultManager
{
    if (instance == nil) {
        instance = [[DVIDataManager alloc] init];
    }
    
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _dataClassArray = [[NSMutableArray alloc] init];
        [self createSqlite];
    }
    return self;
}

#pragma mark- 数据库
- (void)createSqlite
{
    NSString *homePath = NSHomeDirectory();
    NSString *sqlPath = [NSString stringWithFormat:@"%@/Documents/test.db",homePath];
    const char *sqlPathString = [sqlPath UTF8String];
    
    int ret = sqlite3_open(sqlPathString, &_sqlite);
    if (SQLITE_OK != ret) {
        sqlite3_close(_sqlite);
        NSLog(@"打开失败");
        return;
    }
    
    NSString *sqlCreateTableStr = @"create table if not exists data_line "
    @" (id integer primary key autoincrement , "
    @"linedata Blob,picFlag double);";// , indexx INTEGER , eraser int , date TEXT
    [self executeSql:sqlCreateTableStr];
}

- (void)executeSql:(NSString *)sqlStr
{
    char *err;
    int ret = 0;
    if (_sqlite && (ret = sqlite3_exec(_sqlite, [sqlStr UTF8String], NULL, NULL, &err)) != SQLITE_OK) {
        [self closeDataBase];
        NSLog(@"%p,%d",_sqlite,ret);
    }
    else{
        int rowChanges = sqlite3_changes(_sqlite);
        NSLog(@"%d几条数据",rowChanges);
    }
}

- (void)closeDataBase
{
    if (_sqlite != NULL) {
        sqlite3_close(_sqlite);
        _sqlite = NULL;
    }
}

- (void)preserveArray
{
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:_dataClassArray];
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
//    + (id)dateWithTimeIntervalSince1970:(NSTimeInterval)seconds
    
//    NSInteger numOfIndex = dataClassPara.index;
//    NSInteger eraserFlog = dataClassPara.eraserFlog;
    
    char bytes[[arrayData length]];
    
    [arrayData getBytes:bytes length:[arrayData length]];
    
    //NSString *preserveSql1 = [NSString stringWithFormat:@"insert into data_line (linedata,indexx,eraser) values (%@, %d , %d);", arrayData, 1, 1];
    
    NSString *preserveSql = @"insert into data_line (linedata,picFlag) values ( ? , ?);";
    
    sqlite3_stmt *statement;
    if (SQLITE_OK != sqlite3_prepare_v2(_sqlite, [preserveSql UTF8String], -1, &statement, nil)) {
        NSLog(@"failed");
    }
    sqlite3_bind_blob(statement, 1, bytes, [arrayData length], NULL);
    sqlite3_bind_double(statement, 2, timeInterval);
//    sqlite3_bind_int(statement, 2, numOfIndex);
//    sqlite3_bind_int(statement, 3, eraserFlog);
    int ret = sqlite3_step(statement);
    if(SQLITE_DONE == ret)
    {
        NSLog(@"insert ok");
    }else
    {
        NSLog(@"insert failed");
    }
    sqlite3_finalize(statement);
    
    //    NSMutableArray *teA = [NSKeyedUnarchiver unarchiveObjectWithData:teD];
}
//- (void)preserveArray
//{
//    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:dataClassPara.dataArray];
//    NSInteger numOfIndex = dataClassPara.index;
//    NSInteger eraserFlog = dataClassPara.eraserFlog;
//    
//    char bytes[[arrayData length]];
//    
//    [arrayData getBytes:bytes length:[arrayData length]];
//    
//    //NSString *preserveSql1 = [NSString stringWithFormat:@"insert into data_line (linedata,indexx,eraser) values (%@, %d , %d);", arrayData, 1, 1];
//    
//    NSString *preserveSql = @"insert into data_line (linedata,indexx,eraser , date) values (?, ? , ? , ?);";
//    
//    sqlite3_stmt *statement;
//    if (SQLITE_OK != sqlite3_prepare_v2(_sqlite, [preserveSql UTF8String], -1, &statement, nil)) {
//        NSLog(@"failed");
//    }
//    sqlite3_bind_blob(statement, 1, bytes, [arrayData length], NULL);
//    sqlite3_bind_int(statement, 2, numOfIndex);
//    sqlite3_bind_int(statement, 3, eraserFlog);
//    int ret = sqlite3_step(statement);
//    if(SQLITE_DONE == ret)
//    {
//        NSLog(@"insert ok");
//    }else
//    {
//        NSLog(@"insert failed");
//    }
//    sqlite3_finalize(statement);
//    
//    //    NSMutableArray *teA = [NSKeyedUnarchiver unarchiveObjectWithData:teD];
//}

//- (void)checkData
//{
//    NSString *checkDataStr = @"select * from data_line;";
//    
//    sqlite3_stmt *statement;
//    if (SQLITE_OK != sqlite3_prepare_v2(_sqlite, [checkDataStr UTF8String], -1, &statement, nil)) {
//        NSLog(@"failed");
//    }
//    
//    while (sqlite3_step(statement) == SQLITE_ROW) {
//        char *bytes = (char *)sqlite3_column_blob(statement, 1);
//        int len = sqlite3_column_bytes(statement,1);
//        NSData *data = [NSData dataWithBytes:bytes length:len];
//        int indexx = sqlite3_column_int(statement, 2);
//        int eraserFlogPara = sqlite3_column_int(statement, 3);
//        
//        //        NSLog(@"%d",indexx);
//        NSMutableArray *pointArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        //        for (NSString *string in pointArray) {
//        //            NSLog(@"%@",string);
//        //        }
//        //        self.dataArray = [pointArray copy];
//        //        self.index = indexx;
//        DVIDataClass *data1 = [[DVIDataClass alloc] init];
//        data1.dataArray = pointArray;
//        data1.index = indexx;
//        data1.eraserFlog = eraserFlogPara;
//        
//        [self.dataClassArray addObject:data1];
//        [data1 release];
//        
//        //此DVIDrawBoardView不是加载进视图中得drawboardView
//        //        DVIDrawBoardView *drawBoardView = [[DVIDrawBoardView alloc ] init];
//        //        [drawBoardView preserveDatabase:self];
//        //        [drawBoardView release];
//        
//        //        if (_delegate && [_delegate respondsToSelector:@selector(reloadDataBase:)]) {
//        //            [_delegate reloadDataBase:self];
//        //        }
//    }
//    
//    sqlite3_finalize(statement);
//}

- (void)checkData
{
    NSString *checkDataStr = @"select * from data_line;";
    
    sqlite3_stmt *statement;
    if (SQLITE_OK != sqlite3_prepare_v2(_sqlite, [checkDataStr UTF8String], -1, &statement, nil)) {
        NSLog(@"failed");
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        char *bytes = (char *)sqlite3_column_blob(statement, 1);
        int len = sqlite3_column_bytes(statement,1);
        NSData *data = [NSData dataWithBytes:bytes length:len];
        NSTimeInterval timeInterval = sqlite3_column_double(statement, 2);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//        int indexx = sqlite3_column_int(statement, 2);
//        int eraserFlogPara = sqlite3_column_int(statement, 3);
        
        //        NSLog(@"%d",indexx);
        self.dataClassArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"111111:%p",_dataClassArray);
        //        for (NSString *string in pointArray) {
        //            NSLog(@"%@",string);
        //        }
        //        self.dataArray = [pointArray copy];
        //        self.index = indexx;
//        for (DVIDataClass *data1 in dataClassArray) {
//            data1.dataArray = pointArray;
//            data1.index = indexx;
//            data1.eraserFlog = eraserFlogPara;
//        }
//        DVIDataClass *data1 = [[DVIDataClass alloc] init];
        
        
//        [self.dataClassArray addObject:data1];
//        [data1 release];
        
        //此DVIDrawBoardView不是加载进视图中得drawboardView
        //        DVIDrawBoardView *drawBoardView = [[DVIDrawBoardView alloc ] init];
        //        [drawBoardView preserveDatabase:self];
        //        [drawBoardView release];
        
        //        if (_delegate && [_delegate respondsToSelector:@selector(reloadDataBase:)]) {
        //            [_delegate reloadDataBase:self];
        //        }
    }
    
    sqlite3_finalize(statement);
}

#pragma mark- 加载数据
- (void)addDataClass:(DVIDataClass *)dataClassPara
{
    [_dataClassArray addObject:dataClassPara];
}

- (void)dealloc
{
    [_dataClassArray release];
    
    [super dealloc];
}
@end
