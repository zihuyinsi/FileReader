//
//  SearchBookCell.h
//  FileReader
//
//  Created by tsou on 16/2/20.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBookCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UILabel *titLabel;
@property (nonatomic, strong) IBOutlet UILabel *msgLabel;
@property (nonatomic, strong) IBOutlet UILabel *desLabel;
@property (nonatomic, strong) IBOutlet UILabel *line;

@end
