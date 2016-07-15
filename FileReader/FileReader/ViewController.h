//
//  ViewController.h
//  FileReader
//
//  Created by lv on 16/7/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


//获取书籍信息
- (void) gainFileArray;

@end

