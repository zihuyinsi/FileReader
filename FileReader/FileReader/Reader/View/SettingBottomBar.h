//
//  SettingBottomBar.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 底部设置条
 */
@protocol SettingBottomBarDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)fontSizeChanged:(int)fontSize;//改变字号
- (void)callDrawerView;//侧边栏
- (void)turnToNextChapter;//下一章
- (void)turnToPreChapter;//上一章
- (void)sliderToChapterPage:(NSInteger)chapterIndex;
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme;
- (void)callCommentView;

@end

@interface SettingBottomBar : UIView

@property (nonatomic,strong) UIButton *smallFont;
@property (nonatomic,strong) UIButton *bigFont;
@property (nonatomic,assign) id<SettingBottomBarDelegate>delegate;
@property (nonatomic,assign) NSInteger chapterTotalPage;
@property (nonatomic,assign) NSInteger chapterCurrentPage;
@property (nonatomic,assign) NSInteger currentChapter;

- (void)changeSliderRatioNum:(float)percentNum;

- (void)showToolBar;

- (void)hideToolBar;

@end
