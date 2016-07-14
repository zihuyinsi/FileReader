//
//  WiFiHTTPConnection.h
//  FileReader
//
//  Created by lv on 16/1/26.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "HTTPConnection.h"
#import "MultipartFormDataParser.h"

@interface WiFiHTTPConnection : HTTPConnection<MultipartFormDataParserDelegate>
{
    BOOL isUploading;
    MultipartFormDataParser *parser;
    NSFileHandle *storeFile;
    UInt64 uploadFileSize;
}

@end
