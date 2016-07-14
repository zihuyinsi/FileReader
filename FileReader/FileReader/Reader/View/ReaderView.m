//
//  ReaderView.m
//  FileReader
//
//  Created by tsou on 15/12/30.
//  Copyright © 2015年 lv. All rights reserved.
//

#import "ReaderView.h"
#import <CoreText/CoreText.h>
#import "CommonManager.h"

@implementation ReaderView
{
    CTFrameRef _ctFrame;

    UITapGestureRecognizer *tapRecognizer;
    
    NSMutableString *_totalString;
}

#pragma mark - 手势
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)];
        tapRecognizer.enabled = NO;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

#pragma mark - 绘制相关方法
- (void)drawRect:(CGRect)rect
{
    if (!_ctFrame) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGAffineTransform transform = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, transform);
    
    CTFrameDraw(_ctFrame, context);
}

- (NSDictionary *)coreTextAttributes
{
//    UIFont *font_ = [UIFont systemFontOfSize:self.font];
    UIFont *font_ = [UIFont fontWithName: @"迷你简细行楷" size:self.font];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = font_.pointSize / 2;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *dic = @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font_, NSFontAttributeName: [UIFont fontWithName:@"迷你简细行楷" size:30.0]};
    return dic;
}


- (void)render
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:self.text];
    _totalString = [NSMutableString stringWithString:self.text];
    
    [attrString setAttributes:self.coreTextAttributes range:NSMakeRange(0, attrString.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(self.bounds, NULL);
    if (_ctFrame != NULL)
    {
        CFRelease(_ctFrame), _ctFrame = NULL;
    }
    _ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    //计算高度的方法****************************
    //    suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT), NULL);
    //    suggestedSize = CGSizeMake(ceilf(suggestedSize.width), ceilf(suggestedSize.height));
    //
    //    NSLog(@"height == %f",suggestedSize.height);
    //****************************************
    
    CFRelease(path);
    CFRelease(frameSetter);
}

- (CTFrameRef)getCTFrame
{
    return _ctFrame;
}

- (void)resetting
{
    [self setNeedsDisplay];
    
    tapRecognizer.enabled = NO;
}

#pragma mark -单击手势
- (void)TapAction:(UITapGestureRecognizer *)doubleTap
{
    [_delegate shutOffGesture:NO];
    [self setNeedsDisplay];

    tapRecognizer.enabled = NO;
}

@end
