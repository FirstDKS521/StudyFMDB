//
//  ViewController.m
//  StudyFMDB
//
//  Created by aDu on 16/11/25.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "ViewController.h"
#import "BusinessViewController.h"
#import "FMDB.h"

@interface ViewController ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"contact.sqlite"];
    //创建数据库的实例，仅仅创建一个实例，并没打开数据库
    self.db = [FMDatabase databaseWithPath:filePath];
    
    //打开数据库
    BOOL flag = [_db open];
    if (flag) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
    }
    
    //创建数据库表
    //数据库操作插入、更新、删除都属于update
    //参数：sqlite语句
    BOOL flag1 = [_db executeUpdate:@"create table if not exists t_contact (id integer primary key autoincrement, name text, phone text);"];
    if (flag1) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

//增
- (IBAction)add:(id)sender {
    //问号表示数据库里面的占位符
    BOOL flag = [_db executeUpdate:@"insert into t_contact (name, phone) values (?, ?)", @"aDu", @"132666666"];
    if (flag) {
        NSLog(@"增加成功");
    } else {
        NSLog(@"增加失败");
    }
}

//删
- (IBAction)deleate:(id)sender {
    BOOL flag = [_db executeUpdate:@"delete from t_contact;"];
    if (flag) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

//改
- (IBAction)change:(id)sender {
    //FMDB：只能是对象，不能是基本数据类型，如果是int类型，就包装成NSNumber
    BOOL flag = [_db executeUpdate:@"update t_contact set name = ?", @"cuiRui"];
    if (flag) {
        NSLog(@"更改成功");
    } else {
        NSLog(@"更改失败");
    }
}

//查
- (IBAction)search:(id)sender {
    FMResultSet *result = [_db executeQuery:@"select * from t_contact"];
    
    //从结果集里面往下找
    while (result.next) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"%@--%@", name, phone);
    }
}

//事务
- (IBAction)business:(id)sender {
    BusinessViewController *vc = [[BusinessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
