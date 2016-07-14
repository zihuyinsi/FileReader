//
//  Paging.h
//  FileReader
//
//  Created by lv on 15/12/29.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 分页计算并给予内容
 */

@interface Paging : NSObject

@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, assign) NSUInteger contentFont;
@property (nonatomic, assign) CGSize textRenderSize;

/**
 * 分页
 */
- (void) paginate;

/**
 * 分了多少页
 *
 * @return 所分的页数
 */
- (NSUInteger) pageCount;

/**
 * 获取page页的内容
 * @param page 页码数
 * @return 内容
 */
- (NSString *)stringOfPage: (NSUInteger)page;

/**
 * 根据当前的页码计算范围   防止改变字号时偏移过多
 * @param page 当前页码
 * @return 范围
 */
- (NSRange) rangeOfPage: (NSUInteger)page;



@end
