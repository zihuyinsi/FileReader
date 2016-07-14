//
//  SearchBookViewController.m
//  FileReader
//
//  Created by tsou on 16/2/19.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "SearchBookViewController.h"
#import "FunctionTools.h"

@interface SearchBookViewController ()
{
    UITextField *searchField;
    UIButton *searchBtn;
    
    UITableView *searchBookTableView;
    int page;
    BOOL isLoadingMore;
    
    NSMutableArray *dataArray;
}

@end

@implementation SearchBookViewController


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    
    CGRect frame = self.navigationController.navigationBar.bounds;
    UIImage *barImg = [FunctionTools bgImageFromColors: BAR_ColorArray withFrame: frame];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage: barImg];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor: [UIColor colorWithWhite: 0.93 alpha: 1.f]];

    //搜索
    UIView *searchTextView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, iPhoneWidth, 64)];
    CGRect frame = searchTextView.bounds;
    UIImage *barImg = [FunctionTools bgImageFromColors: BAR_ColorArray withFrame: frame];
    [searchTextView setBackgroundColor: [UIColor colorWithPatternImage: barImg]];
    [self.view addSubview: searchTextView];
    
    //返回
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake( 10, 27, 30, 30)];
    [backBtn setBackgroundColor: [UIColor clearColor]];
    [backBtn setBackgroundImage: [UIImage imageNamed: @"close"] forState: UIControlStateNormal];
    [backBtn addTarget: self action: @selector(backBtnClick) forControlEvents: UIControlEventTouchUpInside];
    [searchTextView addSubview: backBtn];
    
    searchField = [[UITextField alloc] initWithFrame: CGRectMake( 50, 24.5, iPhoneWidth-60, 35)];
    [searchField setBackgroundColor: [UIColor whiteColor]];
    searchField.delegate = self;
    searchField.placeholder = @"输入搜索内容";
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 7.f;
    searchField.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3].CGColor;
    searchField.layer.borderWidth = 0.5;
    [searchTextView addSubview: searchField];
}

#pragma mark - UITabelViewDelegate/UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITextFileDelegate
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - backBtnClick
- (void) backBtnClick
{
    [self.view endEditing: NO];
    
    [self dismissViewControllerAnimated: YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
