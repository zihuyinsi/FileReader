//
//  CommonManager.m
//  FileReader
//
//  Created by lv on 15/12/29.
//  Copyright © 2015年 lv. All rights reserved.
//

#import "CommonManager.h"
#import "FunctionTools.h"

#import "Mark.h"

@implementation CommonManager


//主题
+ (NSUInteger) Manager_getThemeIDBefore
{
    NSString *themeID = [UserDefaults objectForKey: SAVETHEME];
    if ([FunctionTools isEmptyWithSomeInfo: themeID])
    {
        return 1;
    }
    else
    {
        return [themeID integerValue];
    }
}

+ (void) saveCurrentThemeID:(NSUInteger)currentThemeID
{
    [UserDefaults setObject: @(currentThemeID) forKey: SAVETHEME];
    [UserDefaults synchronize];
}


//页码
+ (NSUInteger) Manager_getPageBefore
{
    NSString *pageID = [UserDefaults objectForKey: SAVEPAGE];
    if ([FunctionTools isEmptyWithSomeInfo: pageID])
    {
        return 0;
    }
    else
    {
        return [pageID integerValue];
    }
}

+ (void) saveCurrentPage:(NSUInteger)currentPage
{
    [UserDefaults setObject: @(currentPage) forKey: SAVEPAGE];
    [UserDefaults synchronize];
}


//章节
+ (NSUInteger) Manager_getChapterBefore
{
    NSString *chapterID = [UserDefaults objectForKey: OPEN];
    if ([FunctionTools isEmptyWithSomeInfo: chapterID])
    {
        return 1;
    }
    else
    {
        return [chapterID integerValue];
    }
}

+ (void) saveCurrentChapter:(NSUInteger)currentChapter
{
    [UserDefaults setObject: @(currentChapter) forKey: OPEN];
    [UserDefaults synchronize];
}


//字体
+ (NSUInteger) Manager_getFontSizeBefore
{
    NSString *fontSize = [UserDefaults objectForKey: FONT_SIZE];
    if ([FunctionTools isEmptyWithSomeInfo: fontSize])
    {
        return 15;
    }
    else
    {
        return [fontSize integerValue];
    }
}

+ (void) saveFontSize:(NSUInteger)fontSize
{
    [UserDefaults setObject: @(fontSize) forKey: FONT_SIZE];
    [UserDefaults synchronize];
}


//书签
+ (void)saveCurrentMark:(NSUInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent
{
    NSDate *sendDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm"];
    NSString *locationString = [dateFormatter stringFromDate: sendDate];
    
    Mark *mark = [[Mark alloc] init];
    mark.markChapter = [NSString stringWithFormat: @"%lu", (unsigned long)currentChapter];
    mark.markRange = NSStringFromRange(chapterRange);
    mark.markContent = [chapterContent substringWithRange: chapterRange];
    mark.markTime = locationString;
    
    MyLog(@"chapterRange = %@", NSStringFromRange(chapterRange));
    
    if ([self checkIfHasBookmark: chapterRange withChapter: currentChapter])
    {
        //有书签
        NSData *data = [UserDefaults objectForKey: pubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        for (int i = 0; i < [oldSaveArray count]; i++)
        {
            Mark *mk = (Mark *)[oldSaveArray objectAtIndex: i];
            if (((NSRangeFromString(mk.markRange).location >= chapterRange.location) &&
                 (NSRangeFromString(mk.markRange).location < chapterRange.location + chapterRange.length)) &&
                ([mk.markChapter isEqualToString: [NSString stringWithFormat: @"%lu", (unsigned long)currentChapter]]))
            {
                [oldSaveArray removeObject: mk];
                [UserDefaults setObject: [NSKeyedArchiver archivedDataWithRootObject: oldSaveArray] forKey: pubBookName];
            }
        }
    }
    else
    {
        //没有书签
        NSData *data = [UserDefaults objectForKey: pubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        if ([oldSaveArray count] == 0)
        {
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject: mark];
            [UserDefaults setObject: [NSKeyedArchiver archivedDataWithRootObject: newSaveArray] forKey: pubBookName];
        }
        else
        {
            [oldSaveArray addObject: mark];
            [UserDefaults setObject: [NSKeyedArchiver archivedDataWithRootObject: oldSaveArray] forKey: pubBookName];
        }
        [UserDefaults synchronize];
    }
}

+ (BOOL) checkIfHasBookmark:(NSRange)currentRange withChapter:(NSUInteger)currentChapter
{
    NSData *data = [UserDefaults objectForKey: pubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    int k = 0;
    for (int i = 0; i < [oldSaveArray count]; i++)
    {
        Mark *mk = (Mark *)[oldSaveArray objectAtIndex: i];
        if ((NSRangeFromString(mk.markRange).location >= currentRange.location) &&
            (NSRangeFromString(mk.markRange).location < currentRange.location + currentRange.length) &&
            [mk.markChapter isEqualToString: [NSString stringWithFormat: @"%lu", (unsigned long)currentChapter]])
        {
            k++;
        }
        else
        {
        }
    }
    
    if (k >= 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSMutableArray *)Manager_getMark
{
    NSData *data = [UserDefaults objectForKey: pubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    if ([oldSaveArray count] == 0)
    {
        return nil;
    }
    else
    {
        return oldSaveArray;
    }
}

@end
