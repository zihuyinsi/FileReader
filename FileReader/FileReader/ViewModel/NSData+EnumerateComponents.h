//
//  NSData+EnumerateComponents.h
//  FileReader
//
//  Created by lv on 16/7/13.
//  Copyright © 2016年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EnumerateBlock)(NSData *data, BOOL isLast);

@interface NSData (EnumerateComponents)

- (void)obj_enumerateComponentsSeparatedBy:(NSData *)delimiter usingBlock:(EnumerateBlock)block;

@end
