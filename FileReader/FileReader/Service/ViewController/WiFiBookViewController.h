//
//  WiFiBookViewController.h
//  FileReader
//
//  Created by lv on 16/1/25.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPServer;

@interface WiFiBookViewController : UIViewController
{
    UInt64 currentDataLength;
}

@property (nonatomic, strong) HTTPServer *httpServer;

@property (strong, nonatomic) UIProgressView *progressView;     //upload progress
@property (strong, nonatomic) UILabel *lbHTTPServer;
@property (strong, nonatomic) UILabel *lbFileSize;                      //Total size of uploaded file
@property (strong, nonatomic) UILabel *lbCurrentFileSize;           //The size of the current upload

@end
