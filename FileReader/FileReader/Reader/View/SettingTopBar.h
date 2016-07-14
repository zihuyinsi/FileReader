//
//  SettingTopBar.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 顶部设置条
 */

@protocol  SettingTopBarDelegate <NSObject>

- (void)goBack;//退出
- (void)showMultifunctionButton;

@end

@interface SettingTopBar : UIView

@property(nonatomic,assign)id<SettingTopBarDelegate> delegate;

- (void)showToolBar;

- (void)hideToolBar;

@end
