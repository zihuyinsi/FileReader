//
//  ReaderView.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 显示文本类
 */

@protocol ReaderViewDelegate <NSObject>

- (void)shutOffGesture:(BOOL)yesOrNo;
- (void)hideSettingToolBar;

@end

@interface ReaderView : UIView

@property (nonatomic, unsafe_unretained) NSUInteger font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) id <ReaderViewDelegate> delegate;

- (void) render;

@end
