//
//  ReaderDataSource.m
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import "ReaderDataSource.h"
#import "FunctionTools.h"

#import "CommonManager.h"

@implementation ReaderDataSource

+ (ReaderDataSource *) shareInstance
{
    static ReaderDataSource *dataSource;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[ReaderDataSource alloc] init];
    });
    
    return dataSource;
}

- (EveryChapter *) openChapter:(NSUInteger)clickChapter
{
    _currentChapterIndex = clickChapter;
    EveryChapter *chapter = [[EveryChapter alloc] init];
    
    //获取章节信息
    NSString *chapter_num = [NSString stringWithFormat:@"%@_%ld", _chapterName, _currentChapterIndex];
//    NSString *path = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSString *path = [NSString stringWithFormat: @"%@/%@/%@.txt", DoucmentPath, _chapterName, chapter_num];
    chapter.chapterContent = [NSString stringWithContentsOfFile: path encoding: 4 error: NULL];
    
    return chapter;
}

- (EveryChapter *) openChapter
{
    NSUInteger index = [CommonManager Manager_getChapterBefore];
    _currentChapterIndex = index;
    
    EveryChapter *chapter = [[EveryChapter alloc] init];
    
    //获取章节信息
    NSString *chapter_num = [NSString stringWithFormat:@"%@_%ld", _chapterName, _currentChapterIndex];
//    NSString *path = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSString *path = [NSString stringWithFormat: @"%@/%@/%@.txt", DoucmentPath, _chapterName, chapter_num];
    chapter.chapterContent = [NSString stringWithContentsOfFile: path encoding: 4 error: NULL];
    
    return chapter;
}

- (NSUInteger) openPage
{
    NSUInteger index = [CommonManager Manager_getPageBefore];
    return index;
}

- (EveryChapter *) nextChapter
{
    if (_currentChapterIndex >= _totalChapter)
    {
        MyLog(@"没有更多内容了");
        
        return nil;
    }
    else
    {
        _currentChapterIndex ++;
        
        EveryChapter *chapter = [EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex, _chapterName);
        return chapter;
    }
}

- (EveryChapter *) preChapter
{
    if (_currentChapterIndex <= 1)
    {
        MyLog(@"已经是第一页了");
        
        return nil;
    }
    else
    {
        _currentChapterIndex --;
        
        EveryChapter *chapter = [EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex, _chapterName);
        return chapter;
    }
}

- (void) resetTotalString
{
    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    
    for (int i = 1; i < INT_MAX; i++)
    {
        if (readTextData(i, _chapterName) != nil)
        {
            NSUInteger location = _totalString.length;
            [_totalString appendString: readTextData(i, _chapterName)];
            NSUInteger length = _totalString.length-location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject: NSStringFromRange(chapterRange)];
        }
        else
        {
            break;
        }
    }
}

- (NSInteger) getChapterBeginIndex:(NSUInteger)page
{
    NSInteger index = 0;
    for (int i = 1; i < page; i++)
    {
        if (readTextData(i, _chapterName) != nil)
        {
            index += readTextData(i, _chapterName).length;
        }
        else
        {
            break;
        }
    }
    
    return index;
}

- (NSMutableArray *) searchWithKeyWords:(NSString *)keyWord
{
    //关键字为空，则返回空数组
    if ([FunctionTools isEmptyWithSomeInfo: keyWord])
    {
        return nil;
    }
    
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++)
    {
        [blankWord appendString:@" "];
    }
    
    //一次搜索20条
    for (int i = 0; i < 20; i++)
    {
        if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound)
        {
            NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
            NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
            // NSLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
            int temp = 0;
            for (int j = 0; j < _everyChapterRange.count; j ++)
            {
                if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location)
                {
                    temp ++;
                }else
                {
                    break;
                }
            }
            
            [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
            [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
            
            NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
            NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [searchResult addObject:completeString];
            
            [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
        }else
        {
            break;
        }
    }
    
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;
}

- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender
{
    //获取1到x之间的整数
    if (sender == YES)
    {
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0)
        {
            location = temp;
        }
        
        return location;
    }
    else
    {
        
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length)
        {
            value = 0;
        }else
        {
        }
        
        return value;
    }
}

static NSString *readTextData(NSUInteger index, NSString *chapterName)
{
    NSString *chapter_num = [NSString stringWithFormat:@"%@_%ld", chapterName,index];
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSString *path1 = [NSString stringWithFormat: @"%@/%@/%@.txt", DoucmentPath, chapterName, chapter_num];
    NSString *content = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    return content;
}

@end
