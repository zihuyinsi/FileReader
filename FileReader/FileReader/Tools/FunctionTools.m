//
//  FunctionTools.m
//  FileReader
//
//  Created by lv on 16/7/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "FunctionTools.h"
#include <uchardet.h>
#define NUMBER_OF_SAMPLES (2048)

@implementation FunctionTools


#pragma mark - 渐变颜色
/**
 *  根据NSArray(colors)以及CGRect(frame)获取一个UIImage(颜色渐变的UIImage)
 *
 *  @param colors 颜色数组
 *  @param frame  尺寸
 *
 *  @return UIImage
 */
+ (UIImage*) bgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors)
    {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    
    start = CGPointMake(0.0, frame.size.height);
    end = CGPointMake(frame.size.width, 0.0);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - 获取路径下所有文件名
/**
 *  获取filePath路径下所有文件名
 *
 *  @param filePath 路径
 *
 *  @return 文件名数组
 */
+ (NSMutableArray *)gainFileNameWithPath: (NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] init];
    NSArray *fileA = [fileManager contentsOfDirectoryAtPath: filePath error: nil];
    for (int i = 0; i < [fileA count]; i++)
    {
        NSString *filename = [fileA objectAtIndex: i];
        if([filename hasSuffix:@".txt"])
        {
            [fileNameArray addObject: filename];
        }
    }
    
    return fileNameArray;
}

#pragma mark - 是否为空
/**
 *  是否是空字符串
 *
 *  @param someInfo 对象
 *
 *  @return 是否为空
 */
+ (BOOL) isEmptyWithSomeInfo: (id)someInfo
{
    if ([someInfo isEqual: [NSNull null]] || someInfo == nil || someInfo == NULL)
    {
        return YES;
    }
    
    if ([someInfo isKindOfClass: [NSString class]])
    {
        if ([someInfo isEqualToString: @""] || [someInfo length] == 0)
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 匹配章节
/**
 *  正则匹配章节
 *
 *  @param isChapterStr 内容字符串
 *
 *  @return 是否是一个章节开始
 */
+ (BOOL) isChapter: (NSString *)isChapterStr
{
    NSString *Chapter = @"第?[ \t\n\x0B\f\r]{0,10}[0-9〇零一二三四五六七八九十百千]{0,20}[ \t\n\x0B\f\r]{0,10}[章回节卷集幕计部期].*";
    NSPredicate *chapterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Chapter];
    return [chapterTest evaluateWithObject: isChapterStr];
}


#pragma mark - 获取编码
/**
 *  获取文件编码格式
 *
 *  @param filePath  文件路径
 *
 *  @return  文件编码格式
 */
+ (NSStringEncoding) gainEncodingWithFilePath: (NSString *)filePath
{
    FILE* file;
    char buf[NUMBER_OF_SAMPLES];
    size_t len;
    uchardet_t ud;
    
    /* 打开被检测文本文件，并读取一定数量的样本字符 */
    file = fopen([filePath UTF8String], "rt");
    if (file==NULL)
    {
        printf("文件打开失败！\n");
        return NSUTF8StringEncoding;
    }
    len = fread(buf, sizeof(char), NUMBER_OF_SAMPLES, file);
    fclose(file);
    
    ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0)
    {
        printf("分析编码失败！\n");
        return NSUTF8StringEncoding;
    }
    uchardet_data_end(ud);
    printf("文本的编码方式是%s。\n", uchardet_get_charset(ud));
    const char *encode = uchardet_get_charset(ud);
    uchardet_delete(ud);
    
    CFStringEncoding cfEncode = 0;
    NSString *encodeStr=[[NSString alloc] initWithCString: encode encoding: NSUTF8StringEncoding];
    if ([encodeStr isEqualToString:@"gb18030"])
    {
        cfEncode= kCFStringEncodingGB_18030_2000;
    }
    else if([encodeStr isEqualToString:@"Big5"])
    {
        cfEncode= kCFStringEncodingBig5;
    }
    else if([encodeStr isEqualToString:@"UTF-8"])
    {
        cfEncode= kCFStringEncodingUTF8;
    }
    else if([encodeStr isEqualToString:@"Shift_JIS"])
    {
        cfEncode= kCFStringEncodingShiftJIS;
    }
    else if([encodeStr isEqualToString:@"windows-1252"])
    {
        cfEncode= kCFStringEncodingWindowsLatin1;
    }
    else if([encodeStr isEqualToString:@"x-euc-tw"])
    {
        cfEncode= kCFStringEncodingEUC_TW;
    }
    else if([encodeStr isEqualToString:@"EUC-KR"])
    {
        cfEncode= kCFStringEncodingEUC_KR;
    }
    else if([encodeStr isEqualToString:@"EUC-JP"])
    {
        cfEncode= kCFStringEncodingEUC_JP;
    }
    NSStringEncoding fileEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncode);
    return fileEncoding;
}


@end
