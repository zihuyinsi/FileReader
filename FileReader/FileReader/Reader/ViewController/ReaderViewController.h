//
//  ReaderViewController.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 显示阅读内容
 */

@protocol ReaderViewControllerDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)hideTheSettingBar;

@end

@interface ReaderViewController : UIViewController

@property (nonatomic, assign) id <ReaderViewControllerDelegate> delegate;
@property (nonatomic, unsafe_unretained) NSUInteger currentPage;
@property (nonatomic, unsafe_unretained) NSUInteger totalPage;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, unsafe_unretained) NSUInteger font;
@property (nonatomic, copy) NSString *chapterTitle;
@property (nonatomic, unsafe_unretained, readonly) CGSize readerTextSize;

- (CGSize) readerTextSize;

@end
