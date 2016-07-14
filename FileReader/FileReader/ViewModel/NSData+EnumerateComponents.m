//
//  NSData+EnumerateComponents.m
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "NSData+EnumerateComponents.h"

@implementation NSData (EnumerateComponents)


- (void)obj_enumerateComponentsSeparatedBy:(NSData *)delimiter usingBlock:(EnumerateBlock)block
{
    //current location in data
    NSUInteger location = 0;
    
    while (YES) {
        //get a new component separated by delimiter
        NSRange rangeOfDelimiter = [self rangeOfData:delimiter
                                             options:0
                                               range:NSMakeRange(location, self.length - location)];
        
        //has reached the last component
        if (rangeOfDelimiter.location == NSNotFound) {
            break;
        }
        
        NSRange rangeOfNewComponent = NSMakeRange(location, rangeOfDelimiter.location - location + delimiter.length);
        //get the data of every component
        NSData *everyComponent = [self subdataWithRange:rangeOfNewComponent];
        //invoke the block
        block(everyComponent, NO);
        //make the offset of location
        location = NSMaxRange(rangeOfNewComponent);
    }
    
    //reminding data
    NSData *reminder = [self subdataWithRange:NSMakeRange(location, self.length - location)];
    //handle reminding data
    block(reminder, YES);
}

@end
