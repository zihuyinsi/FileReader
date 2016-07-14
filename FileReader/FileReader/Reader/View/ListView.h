//
//  ListView.h
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mark.h"

@protocol ListViewDelegate <NSObject>

- (void)clickMark:(Mark *)mark;
- (void)clickChapter:(NSInteger)chaperIndex;
- (void)removeE_ListView;

@end

@interface ListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *_segmentControl;
    NSInteger dataCount;
    NSMutableArray *_dataSource;
    CGFloat  _panStartX;
    BOOL    _isMenu;
    BOOL    _isMark;
    BOOL    _isNote;
}
@property (nonatomic,assign)id<ListViewDelegate> delegate;

@property (nonatomic,strong)UITableView *listView;

@end
