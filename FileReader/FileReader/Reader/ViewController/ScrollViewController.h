//
//  ScrollViewController.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"

/**
 * 放置阅读页的控制器
 */

@interface ScrollViewController : UIViewController
{
    CoreDataManager *coreManager;
}

/**
 * 文件路径
 */
@property (nonatomic, copy) NSString *filePath;


/**
 * 总章节数
 */
@property (nonatomic, assign) NSUInteger totalChapter;

/**
 * 文件名
 */
@property (nonatomic, copy) NSString *chapterName;


@end
