//
//  EveryChapter.h
//  FileReader
//
//  Created by lv on 15/12/29.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 每章的内容与标题
 */

@interface EveryChapter : NSObject

@property (nonatomic, strong) NSString *chapterContent;
@property (nonatomic, strong) NSString *chapterTitle;

@end
