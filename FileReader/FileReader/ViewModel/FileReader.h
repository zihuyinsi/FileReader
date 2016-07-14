//
//  FileReader.h
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileReader : NSObject
{
    NSString *filePath;
    
    NSFileHandle *fileHandle;
    unsigned long long currentOffset;
    unsigned long long totalFileLength;
    
    NSString *lineDelimiter;
    NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString *lineDelimiter;
@property (nonatomic, assign) NSUInteger chunkSize;

- (id) initWithFilePath: (NSString *)aPath;
- (NSString *) readLine;
- (NSString *) readTrimmedLine;

# if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock: (void(^)(NSString *, BOOL *))block;
#endif

@end
