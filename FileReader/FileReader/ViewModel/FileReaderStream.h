//
//  FileReaderStream.h
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HandleBlock)(NSInteger lineNum, NSString *line);
typedef void (^CompletionBlock)(NSInteger numOfLines);

@interface FileReaderStream : NSObject

- (id) initWithFilePath: (NSString *)filePath;

- (void) enumerateLinesUsingBlock: (HandleBlock)block CompletionBlock: (CompletionBlock)completionBlock;

- (void) enumerateLinesUsing;

@end
