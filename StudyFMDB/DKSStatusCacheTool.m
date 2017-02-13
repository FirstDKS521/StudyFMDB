//
//  DKSStatusCacheTool.m
//  StudyFMDB
//
//  Created by aDu on 16/11/26.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "DKSStatusCacheTool.h"
#import "DKSStatus.h"
#import "FMDB.h"

static FMDatabase *_db;
@implementation DKSStatusCacheTool

+ (void)initialize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"status.sqlite"];
    //创建数据库实例
    _db = [FMDatabase databaseWithPath:filePath];
    //打开数据库
    if ([_db open]) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
    }
    //创建表格
    BOOL flag = [_db executeUpdate:@"create table if not exists t_status (dict blob);"];
    if (flag) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

+ (void)saveWithDictionary:(NSDictionary *)dataDic
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    BOOL flag = [_db executeUpdate:@"insert into t_status (dict) values (?)", data];
    if (flag) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

+ (NSDictionary *)selectStatus
{
    NSString *sql = [NSString stringWithFormat:@"select * from t_status"];
    FMResultSet *result = [_db executeQuery:sql];
    NSDictionary *dic;
    while (result.next) {
        NSData *data = [result objectForColumnName:@"dict"];
        NSLog(@"%@", data);
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return dic;
}

@end
