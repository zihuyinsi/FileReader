//
//  CommonManager.h
//  FileReader
//
//  Created by lv on 15/12/29.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 公共管理类
 */

@interface CommonManager : NSObject

/**
 * 保存页码
 * @param currentPage 现页码
 */
+ (void) saveCurrentPage: (NSUInteger) currentPage;

/**
 * 获取之前的页码
 * @return 页码
 */
+ (NSUInteger) Manager_getPageBefore;


/**
 * 保存章节
 * @param currentChapter 现章节
 */
+ (void) saveCurrentChapter: (NSUInteger) currentChapter;

/**
 * 获取之前的章节
 * @return 章节
 */
+ (NSUInteger) Manager_getChapterBefore;


/**
 * 保存主题ID
 * @param currentThemeID 主题ID
 */
+ (void) saveCurrentThemeID: (NSUInteger) currentThemeID;

/**
 * 获取之前的主题
 * @return 主题ID
 */
+ (NSUInteger) Manager_getThemeIDBefore;


/**
 * 存储字号
 * @param fontSize 存储的字体大小
 */
+ (void) saveFontSize: (NSUInteger) fontSize;

/**
 * 获取字号
 * @return 字体大小
 */
+ (NSUInteger) Manager_getFontSizeBefore;


/**
 * 检查当前页是否加了书签
 * @param currentRange 当前Range
 * @param currentChapter 
 * @return 是否加了书签
 */
+ (BOOL) checkIfHasBookmark: (NSRange) currentRange withChapter: (NSUInteger) currentChapter;

/**
 * 保存书签
 * @param currentChapter  当前章节
 * @param chapterRange  当前起始的一段文字Range
 */
+ (void) saveCurrentMark: (NSUInteger) currentChapter andChapterRange: (NSRange)chapterRange byChapterContent: (NSString *)chapterContent;

/**
 * 获得书签数组
 * @return 书签数组
 */
+ (NSMutableArray *) Manager_getMark;


@end
