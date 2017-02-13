//
//  BusinessViewController.m
//  StudyFMDB
//
//  Created by aDu on 16/11/26.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "BusinessViewController.h"
#import "DKSStatusCacheTool.h"
#import "SYFMDBManager.h"
#import "MyModel.h"
#import "UserModel.h"
#import "FMDB.h"

@interface BusinessViewController ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事务";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[SYFMDBManager shareManager] createTable:[MyModel class]];
    MyModel *my = [[MyModel alloc] init];
    my.aId = @"123";
    my.name = @"阿杜";
    my.sex = @"男";
    [[SYFMDBManager shareManager] insertModel:my];

    [[SYFMDBManager shareManager] createTable:[UserModel class]];
    UserModel *user = [[UserModel alloc] init];
    user.aId = @"456";
    user.age = @"25";
    user.address = @"杭州";
    [[SYFMDBManager shareManager] insertModel:user];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"user.sqlite"];
    
    //创建数据库实例
    self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    //创建数据库的表
    //提供了一个多线程安全的数据库实例
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"create table if not exists t_user (id integer primary key autoincrement, name text, money integer)"];
        if (flag) {
            NSLog(@"success");
        } else {
            NSLog(@"failure");
        }
    }];
}

//增
- (IBAction)insert:(id)sender {
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"insert into t_user (name, money) values (?, ?)", @"a", @1000];
        [db executeUpdate:@"insert into t_user (name, money) values (?, ?)", @"b", @5000];
        if (flag) {
            NSLog(@"增加成功");
        } else {
            NSLog(@"增加失败");
        }
    }];
}

//删
- (IBAction)delete:(id)sender {
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"delete from t_user;"];
        if (flag) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    }];
}

//改
- (IBAction)update:(id)sender {
    //update t_user set money = 500 where name = 'a';
    //update t_user set money = 1000 where name = 'b';
    //a -> b 500
    //b + 500 = b 1000
    
    [_queue inDatabase:^(FMDatabase *db) {
        //开启事务
        [db beginTransaction];
        
       BOOL flag = [db executeUpdate:@"update t_user set money = ? where name = ?;", @500, @"a"];
        if (flag) {
            NSLog(@"修改成功");
        } else {
            NSLog(@"修改失败");
            //回滚
            [db rollback];
        }
        
        BOOL flag1 = [db executeUpdate:@"update t_user set money = ? where name = ?;", @1000, @"b"];
        if (flag1) {
            NSLog(@"修改成功");
        } else {
            NSLog(@"修改失败");
            //回滚
            [db rollback];
        }
        
        //全部完成的时候再去提交
        [db commit];
    }];
}

//查
- (IBAction)select:(id)sender {
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"select * from t_user"];
        while (result.next) {
            NSString *name = [result stringForColumn:@"name"];
            int money = [result intForColumn:@"money"];
            NSLog(@"%@---%@", name, @(money));
        }
    }];
}

//封装存
- (IBAction)fengZhuang:(id)sender {
    NSDictionary *dic = @{@"name":@"aDu", @"age":@"20"};
    [DKSStatusCacheTool saveWithDictionary:dic];
}

//封装取
- (IBAction)fengZhuangQu:(id)sender {
    NSDictionary *dic = [DKSStatusCacheTool selectStatus];
    NSLog(@"%@", dic);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
