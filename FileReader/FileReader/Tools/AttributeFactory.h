//
//  AttributeFactory.h
//  FileReader
//
//  Created by lv on 16/7/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#ifndef AttributeFactory_h
#define AttributeFactory_h

#ifdef DEBUG
# define MyLog(fmt, ...) NSLog((@"\n[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" "~~~" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define MyLog(...);
#endif

// 设备大小
#define iPhoneWidth [UIScreen mainScreen].bounds.size.width
#define iPhoneHeight [UIScreen mainScreen].bounds.size.height

//userDefaults
#define UserDefaults [NSUserDefaults standardUserDefaults]

//appdelegate
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//Doucment
#define DoucmentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#define SAVETHEME       @"saveTheme"
#define SAVEPAGE        @"savePage"
#define OPEN            @"open"
#define FONT_SIZE       @"fontSize"
#define pubBookName     @"pubBookName"

#define ChapterOK       @"ChapterOK"
#define ChapterName     @"chapterName"
#define ChapterTotal    @"chapterTotal"

//offSet
#define offSet_x 15
#define offSet_y 30

//setting
#define MAX_FONT_SIZE 30
#define MIN_FONT_SIZE 10
#define MIN_TIPS @"字体已到最小"
#define MAX_TIPS @"字体已到最大"
#define kBottomBarH 150

#define ListViewW (iPhoneWidth/4*3)

//barColor
#define BAR_ColorArray   [@[[UIColor colorWithRed:0.38f green:0.56f blue:0.86f alpha:1.0f], [UIColor colorWithRed:0.50f green:0.83f blue:0.98f alpha:1.0f], [UIColor colorWithWhite:0.93f alpha:1.0f], [UIColor colorWithRed:0.53f green:0.61f blue:0.75f alpha:1.0f]] mutableCopy]

//wifi fileSize
#define GBUnit 1073741824
#define MBUnit 1048576
#define KBUnit 1024

#define UPLOADSTART @"uploadstart"
#define UPLOADING @"uploading"
#define UPLOADEND @"uploadend"
#define UPLOADISCONNECTED @"uploadisconnected"

#endif /* AttributeFactory_h */
