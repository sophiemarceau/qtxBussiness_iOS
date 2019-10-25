//
//  ScanView.m
//  ObjcBusiness
//
//  Created by 屈小波 on 2017/8/28.
//  Copyright © 2017年 sophiemarceau_qu. All rights reserved.
//

#import "ScanView.h"
@interface ScanView (){
    CGFloat minX ,maxX,minY ,maxY;
}

/**
 扫描区域大小
 */
@property (assign,nonatomic)CGSize rectSize;

/**
 *扫描区域相对于view中心点的偏移量，向上为负值 向下为正值
 */
@property (assign,nonatomic)CGFloat offsetY;
//扫描线
@property (strong,nonatomic)UIImageView *animationLineImageView;

//表示是否变向扫描
@property (assign,getter=isAnimationReverse)BOOL animationReverse;

/**
 表示当前动画是否在进行
 */
@property (assign,getter=isAnimating)BOOL animating;


@property (nonatomic,strong)UILabel *subtitleLabel;
@property (nonatomic,strong)UILabel *netAddressLabel;
@property (nonatomic,strong)UILabel *subtitleDescLabel;
@end

@implementation ScanView

-(id)initWithFrame:(CGRect)frame rectSize:(CGSize)size offsetY:(CGFloat)offsetY{
    self = [super initWithFrame:frame];
    if (self) {
        self.rectSize = size;
        self.offsetY = offsetY;
        //计算基准坐标
        minX = (self.frame.size.width -self.rectSize.width)/2;
        maxX = minX + self.rectSize.width;
        minY = (self.frame.size.height - self.rectSize.height)/2 + self.offsetY;
        maxY = minY + self.rectSize.height;
        [self addSubview:self.subtitleLabel];
        [self addSubview:self.netAddressLabel];
        [self addSubview:self.subtitleDescLabel];
        
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制半透明黑色区域
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.4f);
    
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, minY));//正方形上方
    CGContextFillRect(context, CGRectMake(0, minY, minX, self.rectSize.height));//正方形左侧
    CGContextFillRect(context, CGRectMake(0, maxY, self.frame.size.width, self.frame.size.height-maxY));//正方形下方
    CGContextFillRect(context, CGRectMake(maxX, minY, minX, self.rectSize.height));//正方形右侧

    //绘制中间区域的白色边框
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    
    CGContextAddRect(context, CGRectMake(minX, minY, self.rectSize.width, self.rectSize.height));
    CGContextStrokePath(context);
    
    //绘制中间区域的四个角落
    CGFloat cornerLineLength = 24*AUTO_SIZE_SCALE_X; //线的长度
    CGFloat cornerLineThcik = 3.0f*AUTO_SIZE_SCALE_X;//线的宽度
    
    CGContextSetStrokeColorWithColor(context, RedUIColorC1.CGColor);
    CGContextSetLineWidth(context, cornerLineThcik);
    
    //绘制 左上角
    CGContextMoveToPoint(context, minX+cornerLineLength-cornerLineThcik, minY - cornerLineThcik);//左上尖角的最右端 坐标
    CGContextAddLineToPoint(context, minX-cornerLineThcik, minY-cornerLineThcik);//左上尖角的 尖的位置的坐标
    CGContextAddLineToPoint(context, minX-cornerLineThcik, minY+cornerLineLength-cornerLineThcik);//左上尖角的 最下端的坐标
    
    //绘制 右下角
    CGContextMoveToPoint(context, minX+cornerLineLength-cornerLineThcik, maxY + cornerLineThcik);//右下尖角的最右端 坐标
    CGContextAddLineToPoint(context, minX-cornerLineThcik, maxY+cornerLineThcik);
    CGContextAddLineToPoint(context, minX-cornerLineThcik, maxY-cornerLineLength+cornerLineThcik);

    //绘制 右上角
    CGContextMoveToPoint(context, maxX-cornerLineLength+cornerLineThcik, minY - cornerLineThcik);
    CGContextAddLineToPoint(context, maxX+cornerLineThcik, minY-cornerLineThcik);
    CGContextAddLineToPoint(context, maxX+cornerLineThcik, minY+cornerLineLength-cornerLineThcik);

    //绘制 右下角
    CGContextMoveToPoint(context, maxX-cornerLineLength+cornerLineThcik, maxY + cornerLineThcik);
    CGContextAddLineToPoint(context, maxX+cornerLineThcik, maxY+cornerLineThcik);
    CGContextAddLineToPoint(context, maxX+cornerLineThcik, maxY-cornerLineLength+cornerLineThcik);

    CGContextStrokePath(context);
}

-(UIImageView *)animationLineImageView{
    if (_animationLineImageView == nil) {
        _animationLineImageView = [UIImageView new];
        _animationLineImageView.frame = CGRectMake(minX, minY, self.rectSize.width, 1.0f);
        _animationLineImageView.backgroundColor = RedUIColorC1;
       [self addSubview:_animationLineImageView];
    }
    return _animationLineImageView;
}

-(void)startAnimation{
    self.animationLineImageView.frame = CGRectMake(minX, minY, self.rectSize.width, 1);

    if (self.isAnimating) {
        return;
    }
    self.animating = YES;
    
    [UIView animateWithDuration:3.0f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.animationReverse) {
            self.animationLineImageView.frame = CGRectMake(minX, minY, self.rectSize.width, 1);
        }else{
            self.animationLineImageView.frame = CGRectMake(minX, maxY, self.rectSize.width, 1);
        }
    } completion:^(BOOL finished) {//finished表示 这个view这个动画是否完整的结束做完了
        if(finished){
            self.animationReverse = !self.animationReverse;
            self.animating = NO;
            [self startAnimation];
        }else{
            [self stopAnimation];
        }
    }];
}

-(void)stopAnimation{
    [self.animationLineImageView  removeFromSuperview];
    self.animationLineImageView = nil;
    self.animating = NO;
    self.animationReverse = NO;
}

-(UILabel *)subtitleLabel{
    if (_subtitleLabel== nil) {
        _subtitleLabel = [CommentMethod initLabelWithText:@"在电脑浏览器打开下方网址" textAlignment:NSTextAlignmentCenter font:16 TextColor:[UIColor whiteColor]];
        _subtitleLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 16*AUTO_SIZE_SCALE_X);
    }
    return _subtitleLabel;
}

-(UILabel *)netAddressLabel{
    if (_netAddressLabel == nil) {
        _netAddressLabel = [CommentMethod initLabelWithText:@"e.qtxsy.com" textAlignment:NSTextAlignmentCenter font:30 TextColor:RedUIColorC1];
        _netAddressLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 71*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
    }
    return _netAddressLabel;
}

-(UILabel *)subtitleDescLabel{
    if (_subtitleDescLabel == nil) {
        _subtitleDescLabel = [CommentMethod initLabelWithText:@"扫码二维码后登录企业后台" textAlignment:NSTextAlignmentCenter font:16 TextColor:[UIColor whiteColor]];
        _subtitleDescLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 121*AUTO_SIZE_SCALE_X, kScreenWidth-30*AUTO_SIZE_SCALE_X, 30*AUTO_SIZE_SCALE_X);
    }
    return _subtitleDescLabel;
}
@end
