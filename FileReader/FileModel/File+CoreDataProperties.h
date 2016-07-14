//
//  File+CoreDataProperties.h
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "File.h"

NS_ASSUME_NONNULL_BEGIN

@interface File (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chapterName;
@property (nullable, nonatomic, retain) NSNumber *chapterTotal;

@end

NS_ASSUME_NONNULL_END
