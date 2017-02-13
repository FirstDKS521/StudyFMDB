//
//  DKSStatusCacheTool.h
//  StudyFMDB
//
//  Created by aDu on 16/11/26.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKSStatusCacheTool : NSObject

//status：模型数组
//+ (void)saveWithStatus:(NSArray *)statuses;

+ (void)saveWithDictionary:(NSDictionary *)dataDic;

+ (NSDictionary *)selectStatus;

@end
