//
//  MarkTableViewCell.m
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import "MarkTableViewCell.h"

@implementation MarkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _chapterLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
        _chapterLbl.textColor = [UIColor redColor];
        _chapterLbl.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_chapterLbl];
        
        
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(iPhoneWidth*3/4 - 140, 5, 125, 20)];
        _timeLbl.textColor = [UIColor redColor];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        _timeLbl.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLbl];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 28, iPhoneWidth*3/4 - 50, 60)];
        _contentLbl.numberOfLines = 3;
        _contentLbl.font = [UIFont systemFontOfSize:16];
        _contentLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_contentLbl];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
