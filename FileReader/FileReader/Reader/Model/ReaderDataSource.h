//
//  ReaderDataSource.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EveryChapter.h"

/**
 * 书籍内容来源
 */

@interface ReaderDataSource : NSObject

//当前章节数
@property (nonatomic, assign) NSUInteger currentChapterIndex;
//总章节
@property (nonatomic, assign) NSUInteger totalChapter;
//全文
@property (nonatomic, copy) NSMutableString *totalString;
//每章range
@property (nonatomic, strong) NSMutableArray *everyChapterRange;
//章节名
@property (nonatomic, copy) NSString *chapterName;

/**
 * 单例
 */
+ (ReaderDataSource *)shareInstance;

/**
 * 获取章节信息
 */
- (EveryChapter *)openChapter;

/**
 * 章节跳转
 */
- (EveryChapter *)openChapter: (NSUInteger) clickChapter;

/**
 * 打开的页数
 */
- (NSUInteger) openPage;

/**
 * 获取下一章内容
 */
- (EveryChapter *)nextChapter;

/**
 * 获取上一章内容
 */
- (EveryChapter *)preChapter;

/**
 * 全文搜索
 * @param keyWord 要搜索的关键字
 * @return 搜索的关键字所在的位置
 */
- (NSMutableArray *)searchWithKeyWords: (NSString *)keyWord;

/**
 * 获得全文
 */
- (void) resetTotalString;

/**
 * 获取指定章节的第一个字在整篇文章中的位置
 * @param page 指定章节？？
 * @return 位置
 */
- (NSInteger) getChapterBeginIndex: (NSUInteger)page;


@end
