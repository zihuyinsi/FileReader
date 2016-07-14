//
//  FunctionTools.h
//  FileReader
//
//  Created by lv on 16/7/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FunctionTools : NSObject


#pragma mark - 渐变颜色
/**
 *  根据NSArray(colors)以及CGRect(frame)获取一个UIImage(颜色渐变的UIImage)
 *
 *  @param colors 颜色数组
 *  @param frame  尺寸
 *
 *  @return UIImage
 */
+ (UIImage*) bgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame;


#pragma mark - 获取路径下所有文件名
/**
 *  获取filePath路径下所有文件名
 *
 *  @param filePath 路径
 *
 *  @return 文件名数组
 */
+ (NSMutableArray *)gainFileNameWithPath: (NSString *)filePath;

#pragma mark - 是否为空
/**
 *  是否是空字符串
 *
 *  @param someInfo 对象
 *
 *  @return 是否为空
 */
+ (BOOL) isEmptyWithSomeInfo: (id)someInfo;

#pragma mark - 匹配章节
/**
 *  正则匹配章节
 *
 *  @param isChapterStr 内容字符串
 *
 *  @return 是否是一个章节开始
 */
+ (BOOL) isChapter: (NSString *)isChapterStr;


@end
