//
//  WiFiBookViewController.m
//  FileReader
//
//  Created by lv on 16/1/25.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "WiFiBookViewController.h"

#import "HTTPServer.h"
#import "WiFiHTTPConnection.h"

@interface WiFiBookViewController ()

@end

@implementation WiFiBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake( 0, 0, 25, 25)];
    [backBtn setBackgroundColor: [UIColor clearColor]];
    [backBtn setImage: [UIImage imageNamed: @"back.png"] forState: UIControlStateNormal];
    [backBtn addTarget: self action: @selector(backBtnClick) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView: backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    // Do any additional setup after loading the view.
    
    
    currentDataLength = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithStart:) name:UPLOADSTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploading:) name:UPLOADING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithEnd:) name:UPLOADEND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithDisconnect:) name:UPLOADISCONNECTED object:nil];
    
    
    [self initViews];
    
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setType:@"_http._tcp."];
    [_httpServer setPort: 12345];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/website"];
    [_httpServer setDocumentRoot:webPath];
    [_httpServer setConnectionClass: [WiFiHTTPConnection class]];
    [self startServer];
}

- (void) initViews
{
    _lbHTTPServer = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 150.0, 300.0, 40.0)];
    [_lbHTTPServer setBackgroundColor:[UIColor clearColor]];
    [_lbHTTPServer setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_lbHTTPServer setLineBreakMode: NSLineBreakByWordWrapping];
    [_lbHTTPServer setNumberOfLines:2];
    [self.view addSubview:_lbHTTPServer];
    
    _lbFileSize = [[UILabel alloc] initWithFrame:CGRectMake(250.0, 195.0, 60.0, 20.0)];
    [_lbFileSize setBackgroundColor:[UIColor clearColor]];
    [_lbFileSize setFont:[UIFont boldSystemFontOfSize:13.0]];
    [self.view addSubview:_lbFileSize];
    
    _lbCurrentFileSize = [[UILabel alloc] initWithFrame:CGRectMake(188.0, 195.0, 60.0, 20.0)];
    [_lbCurrentFileSize setBackgroundColor:[UIColor clearColor]];
    [_lbCurrentFileSize setFont:[UIFont boldSystemFontOfSize:13.0]];
    [_lbCurrentFileSize setTextAlignment: NSTextAlignmentRight];
    [self.view addSubview:_lbCurrentFileSize];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [_progressView setFrame:CGRectMake(10.0, 220.0, 300.0, 20.0)];
    [_progressView setHidden:YES];
    [self.view addSubview:_progressView];
}


- (void) uploadWithStart:(NSNotification *) notification
{
    UInt64 fileSize = [(NSNumber *)[notification.userInfo objectForKey:@"totalfilesize"] longLongValue];
    __block NSString *showFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (fileSize>GBUnit)
        {
            showFileSize = [[NSString alloc] initWithFormat:@"/%.1fG", (CGFloat)fileSize / (CGFloat)GBUnit];
        }
        if (fileSize>MBUnit && fileSize<=GBUnit)
        {
            showFileSize = [[NSString alloc] initWithFormat:@"/%.1fMB", (CGFloat)fileSize / (CGFloat)MBUnit];
        }
        else if (fileSize>KBUnit && fileSize<=MBUnit)
        {
            showFileSize = [[NSString alloc] initWithFormat:@"/%lliKB", fileSize / KBUnit];
        }
        else if (fileSize<=KBUnit)
        {
            showFileSize = [[NSString alloc] initWithFormat:@"/%lliB", fileSize];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_lbFileSize setText:showFileSize];
            [_progressView setHidden:NO];
        });
    });
    showFileSize = nil;
}

- (void) uploadWithEnd:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        [_progressView setHidden:YES];
        [_progressView setProgress:0.0];
        [_lbFileSize setText:@""];
        [_lbCurrentFileSize setText:@""];
    });
}

- (void) uploadWithDisconnect:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        [_progressView setHidden:YES];
        [_progressView setProgress:0.0];
        [_lbFileSize setText:@""];
        [_lbCurrentFileSize setText:@""];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Information" message: @"Upload data interrupt!" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cannelAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
            //取消
            [self dismissViewControllerAnimated: YES completion: nil];
        }];
        [alert addAction: cannelAction];
        
        [self presentViewController: alert animated: YES completion: nil];
    });
}

- (void) uploading:(NSNotification *)notification
{
    float value = [(NSNumber *)[notification.userInfo objectForKey:@"progressvalue"] floatValue];
    currentDataLength += [(NSNumber *)[notification.userInfo objectForKey:@"cureentvaluelength"] intValue];
    __block NSString *showCurrentFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (currentDataLength>GBUnit)
        {
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fG", (CGFloat)currentDataLength / (CGFloat)GBUnit];
        }
        if (currentDataLength>MBUnit && currentDataLength<=GBUnit)
        {
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fMB", (CGFloat)currentDataLength / (CGFloat)MBUnit];
        }
        else if (currentDataLength>KBUnit && currentDataLength<=MBUnit)
        {
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliKB", currentDataLength / KBUnit];
        }
        else if (currentDataLength<=KBUnit)
        {
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliB", currentDataLength];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress += value;
            [_lbCurrentFileSize setText:showCurrentFileSize];
        });
    });
    showCurrentFileSize = nil;
}

- (void) startServer
{
    NSError *error;
    if ([_httpServer start:&error])
        [_lbHTTPServer setText:[NSString stringWithFormat:@"Started HTTP Server\nhttp://%@:%hu", [_httpServer hostName], [_httpServer listeningPort]]];
    else
        NSLog(@"Error Started HTTP Server:%@", error);
}



#pragma mark - back
- (void) backBtnClick
{
    [_httpServer stop];
    currentDataLength = 0;
    [_progressView setHidden:YES];
    [_progressView setProgress:0.0];
    [_lbFileSize setText:@""];
    [_lbCurrentFileSize setText:@""];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADSTART object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADING object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADEND object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPLOADISCONNECTED object:nil];
    
    [self.navigationController popViewControllerAnimated: YES];
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
