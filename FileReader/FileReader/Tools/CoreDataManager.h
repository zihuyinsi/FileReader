//
//  CoreDataManager.h
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
//查询
- (NSMutableArray*)selectData:(NSString *)fileName;
//删除
- (void)deleteData;
//修改
- (void)updateData:(NSString*)fileName withFileTotal: (NSNumber *)fileTotal;

@end
