//
//  ReaderViewController.m
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import "ReaderViewController.h"
#import "ReaderView.h"
#import "CommonManager.h"

@interface ReaderViewController ()<ReaderViewDelegate>
{
    ReaderView *_readerView;
}

@end

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _readerView = [[ReaderView alloc] initWithFrame: CGRectMake( offSet_x, offSet_y, iPhoneWidth - 2*offSet_x,  iPhoneHeight - 2*offSet_y)];
    _readerView.delegate = self;
    [self.view addSubview: _readerView];
}

#pragma mark - ReaderViewDelegate
- (void)shutOffGesture:(BOOL)yesOrNo
{
    [_delegate shutOffPageViewControllerGesture:yesOrNo];
}

- (void)hideSettingToolBar
{
    [_delegate hideTheSettingBar];
}

- (void)setFont:(NSUInteger )font_
{
    _readerView.font = font_;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _readerView.text = text;
    
    [_readerView render];
}

- (NSUInteger )font
{
    return _readerView.font;
}

- (CGSize)readerTextSize
{
    return _readerView.bounds.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
