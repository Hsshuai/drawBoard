//
//  DVIDataClass.m
//  练习画板
//
//  Created by apple on 13-8-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DVIDataClass.h"
#import <sqlite3.h>
#import "DVIDrawBoardView.h"
#import "DVIViewController.h"
@interface DVIDataClass()
{
    sqlite3 *_sqlite;
    
    id _target;
    SEL _action;
}
@end

@implementation DVIDataClass

@synthesize dataArray = _dataArray;

- (id)init
{
    if (self = [super init]) {
        _dataArray = [[NSMutableArray alloc] init];
        if(_sqlite == nil)
        [self createSqlite];
//        DVIViewController *viewController = [[[DVIViewController alloc] init]autorelease];
//        self.delegate = viewController;
    }
    return self;
}

- (void)createSqlite
{
//    NSString *homePath = NSHomeDirectory();
    NSString *sqlPath = [NSString stringWithFormat:@"/Users/apple/Desktop/test.db"];
    const char *sqlPathString = [sqlPath UTF8String];
    
    int ret = sqlite3_open(sqlPathString, &_sqlite);
    if (SQLITE_OK != ret) {
        sqlite3_close(_sqlite);
        NSLog(@"打开失败");
        return;
    }
    
    NSString *sqlCreateTableStr = @"create table if not exists data_line "
                                  @" (id integer primary key autoincrement , "
                                  @"linedata Blob , indexx INTEGER);";
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
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:_dataArray];
    NSInteger numOfIndex = _index;
    
    char bytes[[arrayData length]];
    
    [arrayData getBytes:bytes length:[arrayData length]];
    
    NSString *preserveSql = @"insert into data_line (linedata,indexx) values (?, ?);";

    sqlite3_stmt *statement;
    if (SQLITE_OK != sqlite3_prepare_v2(_sqlite, [preserveSql UTF8String], -1, &statement, nil)) {
        NSLog(@"failed");
    }
    sqlite3_bind_blob(statement, 1, bytes, [arrayData length], NULL);
    sqlite3_bind_int(statement, 2, numOfIndex);
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

- (NSMutableArray *)checkData:(NSMutableArray *)array
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
        int indexx = sqlite3_column_int(statement, 2);
        
//        NSLog(@"%d",indexx);
        NSMutableArray *pointArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        for (NSString *string in pointArray) {
//            NSLog(@"%@",string);
//        }
//        self.dataArray = [pointArray copy];
//        self.index = indexx;
        DVIDataClass *data1 = [[DVIDataClass alloc] init];
        data1.dataArray = pointArray;
        data1.index = indexx;
        
        [array addObject:data1];
        [data1 release];
        
        //此DVIDrawBoardView不是加载进视图中得drawboardView
//        DVIDrawBoardView *drawBoardView = [[DVIDrawBoardView alloc ] init];
//        [drawBoardView preserveDatabase:self];
//        [drawBoardView release];
        
//        if (_delegate && [_delegate respondsToSelector:@selector(reloadDataBase:)]) {
//            [_delegate reloadDataBase:self];
//        }
    }
    
    sqlite3_finalize(statement);
    return array;
}

#pragma mark- 目标动作


#pragma mark- NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_dataArray forKey:@"dataArray"];
    [aCoder encodeBool:_eraserFlog forKey:@"eraserFlog"];
    [aCoder encodeFloat:_index forKey:@"index"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
//    self = [super init];
    if (self = [super init]) {
        self.dataArray = [aDecoder decodeObjectForKey:@"dataArray"];
        _eraserFlog = [aDecoder decodeBoolForKey:@"eraserFlog"];
        _index = [aDecoder decodeFloatForKey:@"index"];
    }
    return self;
}


@end
