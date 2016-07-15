//
//  ScrollViewController.m
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import "ScrollViewController.h"
#import "FunctionTools.h"
#import "ReaderDataSource.h"
#import "EveryChapter.h"
#import "Paging.h"
#import "CommonManager.h"
#import "Mark.h"
#import "SettingBottomBar.h"
#import "SettingTopBar.h"
#import "DrawerView.h"
#import "ReaderViewController.h"
#import "FileReaderStream.h"

#import "File.h"

@interface ScrollViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, ReaderViewControllerDelegate, SettingBottomBarDelegate, SettingTopBarDelegate, DrawerViewDelegate>
{
    UIPageViewController * _pageViewController;
    Paging * _paginater;
    BOOL _isTurnOver;     //是否跨章；
    BOOL _isRight;       //翻页方向  yes为右 no为左
    BOOL _pageIsAnimating;          //某些特别操作会导致只调用datasource的代理方法 delegate的不调用
    UITapGestureRecognizer *tapGesRec;
    SettingTopBar *_settingToolBar;
    SettingBottomBar *_settingBottomBar;
    
    UIButton *_markBtn;
    CGFloat   _panStartY;
    UIImage  *_themeImage;
}

@property (copy, nonatomic) NSString* chapterTitle_;
@property (copy, nonatomic) NSString* chapterContent_;
@property (unsafe_unretained, nonatomic) NSUInteger fontSize;
@property (unsafe_unretained, nonatomic) NSUInteger readOffset;
@property (assign, nonatomic) NSInteger readPage;

@property (nonatomic, strong) FileReaderStream *readerStream;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation ScrollViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithRed:0.81f green:0.89f blue:0.97f alpha:1.0f]];
    coreManager = [[CoreDataManager alloc]init];
    
    [self beginChapter];
}

- (void) beginChapter
{
    _totalChapter = 1;
    NSLog(@"doucmentPath = %@", DoucmentPath);
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        tempArray = [coreManager selectData: _chapterName];
    NSLog(@"tempArray = %@", tempArray);
    
    for (File *fileInfo in tempArray)
    {
        NSLog(@"fileInfo - name = %@, total = %@", fileInfo.chapterName, fileInfo.chapterTotal);
    }

    [self beginChapterWithPath: _filePath andName: _chapterName];

//    if ([tempArray count] > 0)
//    {
//        File *fileInfo = tempArray[0];
//        _totalChapter = [fileInfo.chapterTotal integerValue];
//        [self chapterOk];
//    }
//    else
//    {
//        //分章失败或未分章
//        [self beginChapterWithPath: _filePath andName: _chapterName];
//    }
}

- (void) beginChapterWithPath: (NSString *)filePath andName: (NSString *)fileName
{
    [self.view makeToast: @"请稍等..." duration: 1000.f position: @"CSToastPositionCenter"];
    //删除可能存在的文件夹
    NSString *tempPath = [NSString stringWithFormat: @"%@/%@", DoucmentPath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath: tempPath error:nil];
    
    //分段存储
    if (!_readerStream)
    {
        _readerStream = [[FileReaderStream alloc] initWithFilePath: filePath];
    }
    
    _isFirst = YES;
    [_readerStream enumerateLinesUsingBlock:^(NSInteger lineNum, NSString *line)
     {
         //         NSLog(@"lineNum = %ld, line = %@", (long)lineNum, line);
         
         //是否是序  或者  章节开始     章节 或者 大结局 结尾
         NSString *templine = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
         //        NSLog(@"templine = %@", templine);
         if ([templine isEqualToString: @"序"] || [FunctionTools isChapter: templine])
         {
             if (_isFirst)
             {
                 _isFirst = NO;
                 _totalChapter = 1;
             }
             else
             {
                 _totalChapter ++ ;
             }
         }
         else
         {
             if (_isFirst)
             {
                 _isFirst = NO;
                 _totalChapter = 1;
             }
             else
             {
             }
         }
         
         //创建文件夹
         NSString *fileMPath = [NSString stringWithFormat:@"%@/%@",DoucmentPath, fileName];
         BOOL isDir = NO;
         NSFileManager *fileManager = [NSFileManager defaultManager];
         BOOL existed = [fileManager fileExistsAtPath:fileMPath isDirectory:&isDir];
         if ( !(isDir == YES && existed == YES) )
         {
             [fileManager createDirectoryAtPath: fileMPath withIntermediateDirectories:YES attributes:nil error:nil];
         }
         
         //开始写入
         NSString *path = [NSString stringWithFormat: @"%@/%@/%@_%lu.txt", DoucmentPath, fileName, fileName, (unsigned long)_totalChapter];
         if(![fileManager fileExistsAtPath:path]) //如果不存在
         {
             [line writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
         }
         else
         {
             NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath: path];
             [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
             [fileHandle writeData: [line dataUsingEncoding: NSUTF8StringEncoding]]; //追加写入数据
             [fileHandle closeFile];
         }
     }
                            CompletionBlock:^(NSInteger numOfLines)
     {
         MyLog(@"numOfLines = %ld", (long)numOfLines);
         NSMutableArray *tempArray = [[NSMutableArray alloc] init];
         tempArray = [coreManager selectData: _chapterName];
         NSLog(@"tempArray = %@", tempArray);
         if ([tempArray count] > 0)
         {
             //修改数据库
             [coreManager updateData: fileName withFileTotal: [NSNumber numberWithInteger: _totalChapter]];
         }
         else
         {
             NSDictionary *fileInfo = [NSDictionary dictionaryWithObjectsAndKeys: fileName, @"chapterName", [NSNumber numberWithInteger: _totalChapter], @"chapterTotal", nil];
             
             NSMutableArray *tempArr = [NSMutableArray arrayWithObject: fileInfo];
             //插入数据库
             [coreManager insertCoreData: tempArr];
         }
         
         
         NSMutableArray *aa = [[NSMutableArray alloc] init];
         aa = [coreManager selectData: _chapterName];
         NSLog(@"tempArray = %@", aa);
         
         [self.view hideToastActivity];
         [self chapterOk];
     }];
}

- (void) chapterOk
{
    //章节名
    [ReaderDataSource shareInstance].chapterName = _chapterName;
    //设置总章节数
    [ReaderDataSource shareInstance].totalChapter = _totalChapter;
    
    self.fontSize = [CommonManager Manager_getFontSizeBefore];
    _pageIsAnimating = NO;
    
    NSInteger themeID = [CommonManager Manager_getThemeIDBefore];
    if (themeID == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)themeID]];
    }
    
    EveryChapter *chapter = [[ReaderDataSource shareInstance] openChapter];
    [self parseChapter:chapter];
    [self initPageView:NO];
    
    tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callToolBar)];
    [self.view addGestureRecognizer:tapGesRec];
    
    UIPanGestureRecognizer *panGesRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(LightRegulation:)];
    panGesRec.maximumNumberOfTouches = 2;
    panGesRec.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesRec];
}


- (void)LightRegulation:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.view];
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _panStartY = touchPoint.y;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat offSetY = touchPoint.y - _panStartY;
            // NSLog(@"offSetY == %f",offSetY);
            CGFloat light = [UIScreen mainScreen].brightness;
            if (offSetY >=0 )
            {
                
                CGFloat percent = offSetY/self.view.frame.size.height;
                CGFloat regulaLight = percent + light;
                if (regulaLight >= 1.0)
                {
                    regulaLight = 1.0;
                }
                [[UIScreen mainScreen] setBrightness:regulaLight];
            }
            else
            {
                CGFloat percent = offSetY/self.view.frame.size.height;
                CGFloat regulaLight = light + percent;
                if (regulaLight <= 0.0)
                {
                    regulaLight = 0.0;
                }
                [[UIScreen mainScreen] setBrightness:regulaLight];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)callToolBar
{
    if (_settingToolBar == nil)
    {
        _settingToolBar= [[SettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
        [self.view addSubview:_settingToolBar];
        _settingToolBar.delegate = self;
        [_settingToolBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
    
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    if (_settingBottomBar == nil)
    {
        _settingBottomBar = [[SettingBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kBottomBarH)];
        [self.view addSubview:_settingBottomBar];
        _settingBottomBar.chapterTotalPage = _paginater.pageCount;
        _settingBottomBar.chapterCurrentPage = _readPage;
        _settingBottomBar.currentChapter = [ReaderDataSource shareInstance].currentChapterIndex;
        _settingBottomBar.delegate = self;
        [_settingBottomBar showToolBar];
        [self shutOffPageViewControllerGesture:YES];
    }
    else
    {
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}

- (void)initPageView:(BOOL)isFromMenu;
{
    if (_pageViewController)
    {
        //  NSLog(@"remove pageViewController");
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    if (isFromMenu == YES)
    {
        [self showPage:0];
    }
    else
    {
        NSUInteger beforePage = [[ReaderDataSource shareInstance] openPage];
        [self showPage:beforePage];
    }
}

#pragma mark - readerVcDelegate
- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo
{
    if (yesOrNo == NO)
    {
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    else
    {
        _pageViewController.delegate = nil;
        _pageViewController.dataSource = nil;
    }
}

#pragma mark - 点击侧边栏目录跳转
- (void)turnToClickChapter:(NSInteger)chapterIndex
{
    EveryChapter *chapter = [[ReaderDataSource shareInstance] openChapter:chapterIndex + 1];//加1 是因为indexPath.row从0 开始的
    [self parseChapter:chapter];
    [self initPageView:YES];
}

- (void)sliderToChapterPage:(NSInteger)chapterIndex
{
    [self showPage:chapterIndex - 1];
}

#pragma mark - 点击侧边栏书签跳转
- (void)turnToClickMark:(Mark *)mark
{
    EveryChapter *chapter = [[ReaderDataSource shareInstance] openChapter:[mark.markChapter integerValue]];
    [self parseChapter: chapter];
    
    if (_pageViewController)
    {
        MyLog(@"remove pageViewController");
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] init];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    NSUInteger showPage = [self findOffsetInNewPage: NSRangeFromString(mark.markRange).location];
    [self showPage: showPage];
}

#pragma mark - 上一章
- (void)turnToPreChapter
{
    if ([ReaderDataSource shareInstance].currentChapterIndex <= 1)
    {
        [self.view makeToast: @"已经是第一章了"];
        MyLog(@"已经是第一章");
        return;
    }
    
    [self turnToClickChapter:[ReaderDataSource shareInstance].currentChapterIndex - 2];
}
#pragma mark - 下一章
- (void)turnToNextChapter
{
    if ([ReaderDataSource shareInstance].currentChapterIndex == [ReaderDataSource shareInstance].totalChapter)
    {
        [self.view makeToast: @"已经是最后一章了"];
        MyLog(@"已经是最后一章");
        return;
    }
    
    [self turnToClickChapter:[ReaderDataSource shareInstance].currentChapterIndex];
}

#pragma mark - 隐藏设置bar
- (void)hideTheSettingBar
{
    if (_settingToolBar == nil)
    {
    }
    else
    {
        [self hideMultifunctionButton];
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [self shutOffPageViewControllerGesture:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    if (_settingBottomBar == nil)
    {
    }
    else
    {
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
        [self shutOffPageViewControllerGesture:NO];
    }
}


#pragma mark --
- (void)parseChapter:(EveryChapter *)chapter
{
    self.chapterContent_ = chapter.chapterContent;
    self.chapterTitle_ = chapter.chapterTitle;
    [self configPaginater];
}

- (void)configPaginater
{
    _paginater = [[Paging alloc] init];
    ReaderViewController *temp = [[ReaderViewController alloc] init];
    temp.delegate = self;
    [temp view];
    _paginater.contentFont = self.fontSize;
    _paginater.textRenderSize = [temp readerTextSize];
    _paginater.contentText = self.chapterContent_;
    [_paginater paginate];
}

- (void)readPositionRecord
{
    NSUInteger currentPage = [_pageViewController.viewControllers.lastObject currentPage];
    NSRange range = [_paginater rangeOfPage:currentPage];
    self.readOffset = range.location;
}

- (void)fontSizeChanged:(int)fontSize
{
    [self readPositionRecord];
    self.fontSize = fontSize;
    _paginater.contentFont = self.fontSize;
    [_paginater paginate];
    NSUInteger showPage = [self findOffsetInNewPage:self.readOffset];
    [self showPage: showPage];
}

#pragma mark - 直接隐藏多功能下拉按钮
- (void)hideMultifunctionButton
{
    if (_markBtn)
    {
        [_markBtn removeFromSuperview];
        _markBtn = nil;
    }
}

#pragma mark - TopbarDelegate
- (void)goBack
{
    [CommonManager saveCurrentPage:_readPage];
    [CommonManager saveCurrentChapter:[ReaderDataSource shareInstance].currentChapterIndex];
    
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - 动画显示或隐藏多功能下拉按钮
- (void)showMultifunctionButton
{
    _markBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_markBtn setTitle:@"书签" forState:0];
    _markBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    _markBtn.frame = CGRectMake(self.view.frame.size.width - 70 , 20 + 44 + 16 , 44, 44);
    _markBtn.layer.cornerRadius = 22;
    
    NSRange range = [_paginater rangeOfPage:_readPage];
    if ([CommonManager checkIfHasBookmark:range withChapter:[ReaderDataSource shareInstance].currentChapterIndex])
    {
        _markBtn.selected = YES;
    }
    else
    {
        _markBtn.selected = NO;
    }
    
    if (_markBtn.selected == YES)
    {
        [_markBtn setTitleColor:[UIColor redColor] forState:0];
    }
    else
    {
        [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    _markBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_markBtn addTarget:self action:@selector(doMark) forControlEvents:UIControlEventTouchUpInside];
    
    DELAYEXECUTE(0.01, [self.view addSubview:_markBtn]);
}
#pragma mark - 多功能按钮群中的按钮触发事件
- (void)doMark
{
    _markBtn.selected = !_markBtn.selected;
    if (_markBtn.selected == YES)
    {
        [_markBtn setTitleColor:[UIColor redColor] forState:0];
    }
    else
    {
        [_markBtn setTitleColor:[UIColor whiteColor] forState:0];
    }
    
    NSRange range = [_paginater rangeOfPage:_readPage];
    [CommonManager saveCurrentMark:[ReaderDataSource shareInstance].currentChapterIndex andChapterRange:range byChapterContent:_paginater.contentText];
}

#pragma mark - 底部左侧按钮触发事件
- (void)callDrawerView
{
    [self callToolBar];
    tapGesRec.enabled = NO;
    DELAYEXECUTE(0.18, {DrawerView *drawerView = [[DrawerView alloc] initWithFrame:self.view.frame parentView:self.view];drawerView.delegate = self;
        [self.view addSubview:drawerView];});
}

#pragma mark - 底部右侧按钮触发事件
- (void)callCommentView
{
}

- (void)openTapGes
{
    tapGesRec.enabled = YES;
}

#pragma mark - 改变主题
- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme
{
    if (theme == 1)
    {
        _themeImage = nil;
    }
    else
    {
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)theme]];
    }
    
    [self showPage:self.readPage];
}

#pragma mark - 根据偏移值找到新的页码
- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset
{
    NSUInteger pageCount = _paginater.pageCount;
    for (int i = 0; i < pageCount; i++)
    {
        NSRange range = [_paginater rangeOfPage:i];
        if (range.location <= offset && range.location + range.length > offset)
        {
            return i;
        }
    }
    return 0;
}

//显示第几页
- (void)showPage:(NSUInteger)page
{
    ReaderViewController *readerController = [self readerControllerWithPage:page];
    [_pageViewController setViewControllers:@[readerController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL f){
                                     
                                 }];
}

- (ReaderViewController *)readerControllerWithPage:(NSUInteger)page
{
    _readPage = page;
    ReaderViewController *textController = [[ReaderViewController alloc] init];
    textController.delegate = self;
    if (_themeImage == nil)
    {
        textController.view.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        textController.view.backgroundColor = [UIColor colorWithPatternImage:_themeImage];
    }
    
    [textController view];
    textController.currentPage = page;
    textController.totalPage = _paginater.pageCount;
    textController.chapterTitle = self.chapterTitle_;
    textController.font = self.fontSize;
    textController.text = [_paginater stringOfPage:page];
    
    if (_settingBottomBar)
    {
        float currentPage = [[NSString stringWithFormat:@"%ld",_readPage] floatValue] + 1;
        float totalPage = [[NSString stringWithFormat:@"%ld",textController.totalPage] floatValue];
        
        float percent;
        if (currentPage == 1)
        {//强行放置头部
            percent = 0;
        }
        else
        {
            percent = currentPage/totalPage;
        }
        
        [_settingBottomBar changeSliderRatioNum:percent];
    }
    
    return textController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPageViewDataSource And UIPageViewDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    _isTurnOver = NO;
    _isRight = NO;
    
    // NSLog(@"go before");
    ReaderViewController *reader = (ReaderViewController *)viewController;
    NSUInteger currentPage = reader.currentPage;
    
    if (_pageIsAnimating && currentPage <= 0)
    {
        EveryChapter *chapter = [[ReaderDataSource shareInstance] nextChapter];
        [self parseChapter:chapter];
    }
    
    if (currentPage <= 0)
    {
        _isTurnOver = YES;
        EveryChapter *chapter = [[ReaderDataSource shareInstance] preChapter];
        if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""])
        {
            MyLog(@"已经是第一页了");
            [self.view makeToast: @"已经是第一页了"];
            _pageIsAnimating = NO;
            return  nil;
        }
        [self parseChapter:chapter];
        currentPage = self.lastPage + 1;
    }
    
    _pageIsAnimating = YES;
    
    ReaderViewController *textController = [self readerControllerWithPage:currentPage - 1];
    return textController;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    _isTurnOver = NO;
    _isRight = YES;
    
    //  NSLog(@"go after");
    ReaderViewController *reader = (ReaderViewController *)viewController;
    NSUInteger currentPage = reader.currentPage;
    
    if (_pageIsAnimating && currentPage <= 0)
    {
        EveryChapter *chapter = [[ReaderDataSource shareInstance] nextChapter];
        [self parseChapter:chapter];
    }
    
    if (currentPage >= self.lastPage)
    {
        _isTurnOver = YES;
        EveryChapter *chapter = [[ReaderDataSource shareInstance] nextChapter];
        if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""])
        {
            MyLog(@"没有更多内容了");
            [self.view makeToast: @"没有更多内容了"];
            _pageIsAnimating = NO;
            return nil;
        }
        [self parseChapter:chapter];
        currentPage = -1;
    }
    
    _pageIsAnimating = YES;
    
    ReaderViewController *textController = [self readerControllerWithPage:currentPage + 1];
    return textController;
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    _pageIsAnimating = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    if (completed)
    {
        //翻页完成
    }else
    { //翻页未完成 又回来了。
        if (_isTurnOver && !_isRight)
        {//往右翻 且正好跨章节
            EveryChapter *chapter = [[ReaderDataSource shareInstance] nextChapter];
            [self parseChapter:chapter];
        }
        else if(_isTurnOver && _isRight)
        {//往左翻 且正好跨章节
            EveryChapter *chapter = [[ReaderDataSource shareInstance] preChapter];
            [self parseChapter:chapter];
        }
    }
}

- (NSUInteger)lastPage
{
    return _paginater.pageCount - 1;
}


@end
