//
//  ViewController.m
//  FileReader
//
//  Created by lv on 16/7/12.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "ViewController.h"

#import "FunctionTools.h"

#import "ScrollViewController.h"
#import "FileReaderStream.h"

#import "SearchBookViewController.h"
#import "WiFiBookViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *fileTableView;
@property (nonatomic, strong) NSMutableArray *fileNameArray;

@property (nonatomic, strong) FileReaderStream *readerStream;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) int chapterNum;


@end

@implementation ViewController

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
    [self.view setBackgroundColor: [UIColor colorWithWhite: 0.93 alpha: 1.f]];

    UIButton *searchBtn = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 25, 25)];
    [searchBtn setBackgroundColor: [UIColor clearColor]];
    [searchBtn setImage: [UIImage imageNamed: @"search.png"] forState: UIControlStateNormal];
    [searchBtn addTarget: self action: @selector(searchBtnClick) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *serachItem = [[UIBarButtonItem alloc] initWithCustomView: searchBtn];
    self.navigationItem.leftBarButtonItem = serachItem;
    
    UIButton *wifiBtn = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 25, 25)];
    [wifiBtn setBackgroundColor: [UIColor clearColor]];
    [wifiBtn setImage: [UIImage imageNamed: @"wifi.png"] forState: UIControlStateNormal];
    [wifiBtn addTarget: self action: @selector(wifiBtnClick) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: wifiBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _fileNameArray = [[NSMutableArray alloc] init];
    _chapterNum = 1;
    
    _fileTableView = [[UITableView alloc] init];
    [_fileTableView setFrame: CGRectMake( 0, 0, iPhoneWidth, iPhoneHeight-64)];
    [_fileTableView setBackgroundColor: [UIColor clearColor]];
    _fileTableView.delegate = self;
    _fileTableView.dataSource = self;
    _fileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _fileTableView];

    [self gainFileArray];
}

- (void) gainFileArray
{
    _fileNameArray = [FunctionTools gainFileNameWithPath: DoucmentPath];
    [_fileTableView reloadData];
    MyLog(@"fileNameArray = %@", _fileNameArray);
}

#pragma mark - searchBtn
- (void) searchBtnClick
{
    MyLog(@"书城");
    SearchBookViewController *searchBook = [[SearchBookViewController alloc] init];
    //    [self.navigationController pushViewController: searchBook animated: YES];
    [self presentViewController: searchBook animated: YES completion:^{
    }];
}

#pragma mark - wifiBtn
- (void) wifiBtnClick
{
    MyLog(@"wifi 传书");
    WiFiBookViewController *wifiBook = [[WiFiBookViewController alloc] init];
    [self.navigationController pushViewController: wifiBook animated: YES];
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fileNameArray count];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndf = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIndf];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [cell.textLabel setFont: [UIFont systemFontOfSize: 15.f]];
        
        UILabel *line = [[UILabel alloc] initWithFrame: CGRectMake( 10, 59, iPhoneWidth-10, 1)];
        [line setBackgroundColor: [[UIColor lightGrayColor] colorWithAlphaComponent: 0.3f]];
        [cell.contentView addSubview: line];
    }
    
    NSString *nameStr = [_fileNameArray objectAtIndex: indexPath.row];
    NSString *tempName = [[nameStr componentsSeparatedByString: @"."] objectAtIndex: 0];
    cell.textLabel.text = tempName;
    
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nameStr = [_fileNameArray objectAtIndex:indexPath.row];
    NSString *tempName = [[nameStr componentsSeparatedByString: @"."] objectAtIndex: 0];
    NSString *path = [NSString stringWithFormat: @"%@/%@", DoucmentPath, nameStr];
    
    ScrollViewController *scrollView = [[ScrollViewController alloc] init];
    scrollView.chapterName = tempName;
    scrollView.filePath = path;
    scrollView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: scrollView animated: YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
