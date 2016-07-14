//
//  DrawerView.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mark.h"
#import "ListView.h"

@protocol DrawerViewDelegate <NSObject>

- (void)openTapGes;
- (void)turnToClickChapter:(NSInteger)chapterIndex;
- (void)turnToClickMark:(Mark *)mark;

@end

@interface DrawerView : UIView<UIGestureRecognizerDelegate, ListViewDelegate>{
    
    ListView *_listView;
}
@property(nonatomic, strong) UIView *parent;
@property(nonatomic, assign) id<DrawerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p;


@end
