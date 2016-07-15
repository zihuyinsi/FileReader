//
//  FileReaderStream.m
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "FileReaderStream.h"
#import "NSData+EnumerateComponents.h"
#import "FunctionTools.h"

@interface FileReaderStream () <NSStreamDelegate>

@property (nonatomic, strong) NSInputStream *inputStream;           //文件读入流
@property (nonatomic, strong) NSOperationQueue *queue;              //操作队列

@property (nonatomic, strong) NSString *filePath;                   //文件路径
@property (nonatomic, assign) NSStringEncoding fileEncoding;       //编码格式

@property (nonatomic, strong) NSMutableData *reminder;              //中间缓冲区
@property (nonatomic, assign) NSInteger lineNumber;                 //当前读取的行数
@property (nonatomic, copy) NSData *delimiter;                      //分割符
@property (nonatomic, copy) HandleBlock callBlock;
@property (nonatomic, copy) CompletionBlock completionBlock;

@end

@implementation FileReaderStream

- (id) initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        //
        self.filePath = filePath;
        self.fileEncoding = [FunctionTools gainEncodingWithFilePath: filePath];
        self.delimiter = [@"\n" dataUsingEncoding: self.fileEncoding];
    }
    return self;
}

- (id) initWithFilePath: (NSString *)filePath andNSStringEncoding: (NSStringEncoding)encodeing
{
    self = [super init];
    if (self)
    {
        //
        self.filePath = filePath;
        self.fileEncoding = encodeing;
        self.delimiter = [@"\n" dataUsingEncoding: self.fileEncoding];
    }
    return self;
}

- (void) enumerateLinesUsing
{
    if (self.queue == nil)
    {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    
    NSAssert(self.queue.maxConcurrentOperationCount == 1, @"Cannot read file concurrently");
    NSAssert(self.inputStream == nil, @"Cannot progress multiple input stream in parallel");
    
    //    self.inputStream = [NSInputStream inputStreamWithFileAtPath: self.filePath];
    self.inputStream = [[NSInputStream alloc] initWithFileAtPath: self.filePath];
    self.inputStream.delegate = self;
    [self.inputStream scheduleInRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
    [self.inputStream open];
}

- (void) enumerateLinesUsingBlock:(HandleBlock)block CompletionBlock:(CompletionBlock)completionBlock
{
    if (self.queue == nil)
    {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    
    NSAssert(self.queue.maxConcurrentOperationCount == 1, @"Cannot read file concurrently");
    NSAssert(self.inputStream == nil, @"Cannot progress multiple input stream in parallel");
    
    self.callBlock = block;
    self.completionBlock = completionBlock;
    
    //    self.inputStream = [NSInputStream inputStreamWithFileAtPath: self.filePath];
    self.inputStream = [[NSInputStream alloc] initWithFileAtPath: self.filePath];
    self.inputStream.delegate = self;
    [self.inputStream scheduleInRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
    [self.inputStream open];
}

#pragma mark - NSStreamDelegate
- (void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    MyLog(@"123123123123");
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            
            break;
            
        case NSStreamEventErrorOccurred:
            MyLog(@"NSStreamEventErrorOccureed: error when reading file");
            break;
            
        case NSStreamEventEndEncountered:
        {                           //handle last part of data
            [self emitLineWithData:self.reminder];          //handle last part of data
            self.reminder = nil;
            [self.inputStream close];
            [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.inputStream = nil;
            [self.queue addOperationWithBlock:^{
                self.completionBlock(self.lineNumber + 1);  //invoke the completion block
            }];
        }
            break;
            
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *buffer = [[NSMutableData alloc] initWithLength:4 * 1024];
            NSUInteger length = (NSUInteger)[self.inputStream read:[buffer mutableBytes] maxLength:[buffer length]];
            if (length > 0) {
                [buffer setLength:length];
                __weak id weakSelf = self;
                [self.queue addOperationWithBlock:^{
                    [weakSelf processDataChunk:buffer];
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void) emitLineWithData: (NSData *)data
{
    NSUInteger lineNum = self.lineNumber;
    self.lineNumber += 1;
    
    if (data.length > 0)
    {
//        NSString *line = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSString *line = [[NSString alloc] initWithData: data encoding:  self.fileEncoding];
        self.callBlock(lineNum, line);
    }
}

- (void) processDataChunk: (NSMutableData *)buffer
{
    if (self.reminder == nil)
    {
        self.reminder = buffer;
    }
    else
    {
        //last chunk of data have some data (part of last line) reminding.
        [self.reminder appendData:buffer];
    }
    
    //separate self.reminder to lines and handle them
    [self.reminder obj_enumerateComponentsSeparatedBy: self.delimiter usingBlock:^(NSData *data, BOOL isLast) {
        
        //if it isn't last line. handle each one
        if (isLast == NO) {
            [self emitLineWithData:data];
        } else if (data.length > 0) {
            //if last line has some data reminding, save these data
            self.reminder = [data mutableCopy];
        } else {
            self.reminder = nil;
        }
    }];
}



@end
