//
//  HCL_ChartView.m
//  HCL_ChartView
//
//  Created by bryantcharyn on 16/3/25.
//  Copyright © 2016年 linkloving. All rights reserved.
//

#import "HCL_ChartView.h"
@interface HCL_ChartView ()
{
    HCLRange maxAndMin;
    CGFloat barWidth;
}
@property (nonatomic,strong)NSArray *xValues;

@property (nonatomic,strong)NSArray *yValues;

@property (nonatomic,strong)NSArray *xSideLabels;//X label you wanna show.
@property (nonatomic,strong)NSArray *ySideLabels;//Y label you wanna show.




@end
@implementation HCL_ChartView
#define TEXT_HEIGHT 15
#define BAR_MARGIN 2
#define X_LABEL_MARGIN 24
#define Y_LABEL_MARGIN X_LABEL_MARGIN
#define ZB_HEIGHT (self.frame.size.height - X_LABEL_MARGIN)
#define ZB_WIDTH (self.frame.size.width - Y_LABEL_MARGIN)

#define SELF_SIZE self.frame.size
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowY = NO;
        self.isShowX = YES;
        self.labelTextColor = [UIColor blackColor];
    }
    return self;
}

-(UIColor *)bgColor
{
    if (!_bgColor) {
        return [UIColor whiteColor];
    }
    return _bgColor;
}
-(UIColor *)barColor
{
    if (!_barColor) {
        return [UIColor greenColor];
    }
    return _barColor;
}
-(UIColor *)xyLabelColor
{
    if (!_xyLabelColor) {
        return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    return _xyLabelColor;
}

-(void)setDataSource:(id<HCL_ChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    self.xValues = [_dataSource xTitlesForView:self];
    if ([_dataSource respondsToSelector:@selector(xSideLabelsForView:)]) {
        self.xSideLabels = [_dataSource xSideLabelsForView:self];
    }
    
    self.yValues = [_dataSource yTitlesForView:self];
    
    if ([_dataSource respondsToSelector:@selector(ySideLabelsForView:)]) {
        self.ySideLabels = [_dataSource ySideLabelsForView:self];
    }
    
    barWidth = ((self.frame.size.width - Y_LABEL_MARGIN) - (self.xValues.count + 1) * BAR_MARGIN)/self.xValues.count;
    maxAndMin = [_dataSource maxAndMinForView:self];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,0,rect.size.height);//旋转画布
    CGContextScaleCTM(context, 1, -1);
    [self drawBg:context rect:rect]; //画背景图片
    
    for (int i = 0; i <_ySideLabels.count; i++) {//画y轴label
        NSString *ySideValue = _ySideLabels[i];
        CGFloat barHeight = ZB_HEIGHT * ([ySideValue integerValue] / maxAndMin.max);
        [self drawText:context withStr:ySideValue point:CGPointMake(0, SELF_SIZE.height - barHeight - X_LABEL_MARGIN - TEXT_HEIGHT) needLine:YES];
    }
    
    for (int i = 0; i <_xSideLabels.count; i++) {//画x轴label
        NSString *xSideValue = _xSideLabels[i];
        CGFloat barHeight = ZB_WIDTH / (_xSideLabels.count - 1) * i;
        [self drawText:context withStr:xSideValue point:CGPointMake( barHeight,ZB_HEIGHT) needLine:NO];
    }
    
        for (int i = 0 ; i < _yValues.count; i++) {//画bar
            NSString *yValue = _yValues[i];
            CGFloat barHeight = ZB_HEIGHT * ([yValue integerValue] / maxAndMin.max);
            CGFloat barX = BAR_MARGIN * (i + 1) + (barWidth * i) + Y_LABEL_MARGIN / 2;
            [self drawBarWithContext:context andRect:CGRectMake(barX, X_LABEL_MARGIN , barWidth, barHeight)];
        }
}
//画背景
-(void)drawBg:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSetFillColorWithColor(context,self.bgColor.CGColor);//填充颜色
    CGContextFillRect(context,rect);//填充框
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
//画xy的轴
    [self drawLines:context rect:rect];
    

}
/**
 *  画xy轴
 *
 *  @param context <#context description#>
 *  @param rect    <#rect description#>
 */
-(void)drawLines:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSetStrokeColorWithColor(context, self.xyLabelColor.CGColor);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,0,rect.size.height);//旋转画布
    CGContextScaleCTM(context, 1, -1);
//
    if(_isShowY)//Y轴
    {
    CGContextMoveToPoint(context, X_LABEL_MARGIN, Y_LABEL_MARGIN);
    CGContextAddLineToPoint(context, X_LABEL_MARGIN, rect.size.height - X_LABEL_MARGIN);
    CGContextStrokePath(context);
    }
    if(_isShowX)//X轴
    {
    CGContextTranslateCTM(context,0,rect.size.height);//旋转画布
    CGContextScaleCTM(context, 1, -1);
    
    CGContextMoveToPoint(context, X_LABEL_MARGIN, Y_LABEL_MARGIN);
    CGContextAddLineToPoint(context, rect.size.width ,  Y_LABEL_MARGIN);
    CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);

}
/**
 *  画柱状
 *
 *  @param context <#context description#>
 *  @param rect    <#rect description#>
 */
-(void)drawBarWithContext:(CGContextRef)context andRect:(CGRect)rect
{
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextSetFillColorWithColor(context, self.barColor.CGColor);//填充颜色
    CGContextFillRect(context,rect);//填充框
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
}

//画文字

-(void)drawText:(CGContextRef)context withStr:(NSString *)yValue point:(CGPoint)point needLine:(BOOL)needLine
{
    CGContextSaveGState(context);//保存未旋转状态
    CGContextTranslateCTM(context,0,SELF_SIZE.height);//旋转画布
    CGContextScaleCTM(context, 1, -1);
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:9.0f], NSFontAttributeName,self.labelTextColor,NSForegroundColorAttributeName, nil];
    [yValue drawAtPoint:point withAttributes:dic];//CGPointMake(0,SELF_SIZE.height - barHeight - X_LABEL_MARGIN - TEXT_HEIGHT) withAttributes:nil];
    if (needLine) {
        
    CGContextSetStrokeColorWithColor(context, self.xyLabelColor.CGColor);
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
    CGContextMoveToPoint(context, point.x,  point.y + TEXT_HEIGHT  );
    CGContextAddLineToPoint(context,SELF_SIZE.width - point.x,  point.y + TEXT_HEIGHT );
    CGContextStrokePath(context);
    }

    CGContextRestoreGState(context);//恢复之前保存的状态
}

@end
