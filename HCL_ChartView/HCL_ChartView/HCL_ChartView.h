//
//  HCL_ChartView.h
//  HCL_ChartView
//
//  Created by bryantcharyn on 16/3/25.
//  Copyright © 2016年 linkloving. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HCL_ChartViewDataSource;
@interface HCL_ChartView : UIView

@property (nonatomic,strong)id<HCL_ChartViewDataSource> dataSource;

@property (nonatomic,strong)UIColor *barColor;//柱状颜色
@property (nonatomic,strong)UIColor *bgColor;//背景颜色
@property (nonatomic,strong)UIColor *xyLabelColor; //x y 轴以及 字的颜色;
@property (strong,nonatomic)UIColor *labelTextColor;

@property (assign,nonatomic)BOOL isShowX; //是否显示X坐标轴
@property (assign,nonatomic)BOOL isShowY;//是否显示Y坐标轴



@end


struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range HCLRange;
CG_INLINE HCLRange HCLRangeMake(CGFloat max, CGFloat min);

CG_INLINE HCLRange
HCLRangeMake(CGFloat max, CGFloat min){
    HCLRange p;
    p.max = max;
    p.min = min;
    return p;
}

@protocol HCL_ChartViewDataSource <NSObject>

-(NSArray *)xTitlesForView:(HCL_ChartView *)chartView;

-(NSArray *)yTitlesForView:(HCL_ChartView *)chartView;

-(HCLRange)maxAndMinForView:(HCL_ChartView *)chartView;

-(NSArray *)ySideLabelsForView:(HCL_ChartView *)chartView;//Y轴旁边显示的数值数组，此值所显示的比例须在 上个方法中的范围内 maxAndMinForView

-(NSArray *)xSideLabelsForView:(HCL_ChartView *)chartView;//根据传进来的值得个数，进行平分，此处为本人项目需求

@end