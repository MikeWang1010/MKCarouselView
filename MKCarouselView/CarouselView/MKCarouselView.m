//
//  MKCarouselView.m
//  MKCarouselView
//
//  Created by MikeWang on 2017/7/7.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kImageViewCount 3
#define kDuration 3.

#import "MKCarouselView.h"
#import "MKPageControlView.h"
#import "MKCarouselViewModel.h"

@interface MKCarouselView ()<MKPageControlViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *ringhtImageView;
@property (nonatomic, strong) MKPageControlView *pageControlView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat starOffsetX;

@end

@implementation MKCarouselView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray <MKCarouselViewModel *>*)dataArray {
    
    if (self = [super initWithFrame:frame]) {
        self.dataArray = dataArray;
        [self setupSubView];
        if (self.dataArray.count > 1) {
            [self addTimer];
        }else{
            self.scrollView.scrollEnabled = NO;
        }
    }
    return self;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(0, 5, self.frame.size.width, 30);
    self.pageControlView.frame = CGRectMake(0, self.frame.size.height - 30, self.bounds.size.width, 30);
    if (self.dataArray.count > 0) {
        self.leftImageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.frame.size.height);
        self.middleImageView.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.frame.size.height);
        self.ringhtImageView.frame = CGRectMake( 2 * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.frame.size.height);
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"dealloc");
}

#pragma mark 增加定时器

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kDuration target:self selector:@selector(scrollImageView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark 设置子控件
- (void)setupSubView {
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControlView];
    [self addSubview:self.titleLabel];
    if (self.dataArray.count > 0) {
        [self.scrollView addSubview:self.leftImageView];
        [self.scrollView addSubview:self.middleImageView];
        [self.scrollView addSubview:self.ringhtImageView];
        self.scrollView.contentSize = CGSizeMake(kImageViewCount * kScreenW, 0.);
        [self.scrollView setContentOffset:CGPointMake(kScreenW, 0)];
        [self setDefaultImage];
    }
    
    
}

#pragma mark 设置默认显示图片,已经pageControlView
-(void)setDefaultImage{
    //加载默认图片
    MKCarouselViewModel *leftMode = [self.dataArray lastObject];
    MKCarouselViewModel *middleModel = [self.dataArray firstObject];
    self.leftImageView.image = [UIImage imageNamed:leftMode.iconName];
    self.middleImageView.image = [UIImage imageNamed:middleModel.iconName];
    self.titleLabel.text = middleModel.title;
    if(self.dataArray.count > 1) {
        MKCarouselViewModel *rightMode = [self.dataArray objectAtIndex:1];
        self.ringhtImageView.image = [UIImage imageNamed:rightMode.iconName];
    }else {
        self.pageControlView.hidden = YES;
    }
    self.currentIndex = 0;
    //设置当前页
    self.pageControlView.pageCount = self.dataArray.count;
    self.pageControlView.currentIndex = self.currentIndex;
}

#pragma mark 滚动图片
-(void)scrollImageView{
    self.currentIndex++;
    if (self.currentIndex == self.dataArray.count) {
        self.currentIndex = 0;
    }
    ///此处设置动画的时间一定要小于滑动的时间
    [UIView animateWithDuration:0.5 animations:^{
        ///动画发生的滑动时不可以点击
        self.middleImageView.userInteractionEnabled =NO;
        //先滑动到右边的imageView
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, 0);
    } completion:^(BOOL finished) {
        self.middleImageView.userInteractionEnabled = YES;
        //修改每个imageView对应image，保存总是显示中间的imageView
        [self chanegeImageView];
        self.pageControlView.currentIndex = self.currentIndex;
        
    }];
}

#pragma mark 改变每个imageView对应image
//这个方法里面分别计算出左中右三个imageView所对应的图片，然后马上让屏幕显示中间的imageView
- (void)chanegeImageView {
    
    NSInteger leftIndex = (self.currentIndex + self.dataArray.count - 1) % self.dataArray.count;
    NSInteger rightIndex= (self.currentIndex + 1) % self.dataArray.count;
    
    MKCarouselViewModel *leftMode = [self.dataArray objectAtIndex:leftIndex];
    MKCarouselViewModel *middleModel = [self.dataArray objectAtIndex:self.currentIndex];
    MKCarouselViewModel *rightMode = [self.dataArray objectAtIndex:rightIndex];
    self.leftImageView.image = [UIImage imageNamed:leftMode.iconName];;
    self.middleImageView.image = [UIImage imageNamed:middleModel.iconName];
    self.titleLabel.text = middleModel.title;
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 1, 0);
    self.ringhtImageView.image = [UIImage imageNamed:rightMode.iconName];
}

#pragma mark 当前imageView点击
- (void)imageViewClick:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(carouselView:didActionWithIndex:)]) {
        [self.delegate carouselView:self didActionWithIndex:self.currentIndex];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.starOffsetX = scrollView.contentOffset.x;
    [self.timer setFireDate:[NSDate distantFuture]];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //这里处理手动拖动
    CGFloat offsetx = self.scrollView.contentOffset.x;
    if (offsetx != self.starOffsetX) {
        if (offsetx <= 0 ) {
            if (self.currentIndex == 0) {
                self.currentIndex = self.dataArray.count - 1;
            }else {
                self.currentIndex--;
            }
        }else {
            if (self.currentIndex == self.dataArray.count -1) {
                self.currentIndex = 0;
            }else {
                self.currentIndex++;
            }
        }
        [self chanegeImageView];
        self.pageControlView.currentIndex = self.currentIndex;
    }
    [self.timer setFireDate:[NSDate dateWithTimeInterval:kDuration sinceDate:[NSDate date]]];
}


#pragma mark - MKPageControlViewDelegate 代理

- (void)pageControlView:(MKPageControlView *)view didChangeWithIndex:(NSInteger)current {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.currentIndex = current;
    [self chanegeImageView];
    
    [self.timer setFireDate:[NSDate dateWithTimeInterval:kDuration sinceDate:[NSDate date]]];
}


#pragma mark - 属性
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
    }
    return _leftImageView;
}
- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc]init];
        _middleImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
        [_middleImageView addGestureRecognizer:gesture];
    }
    return _middleImageView;
}
- (UIImageView *)ringhtImageView {
    if (!_ringhtImageView) {
        _ringhtImageView = [[UIImageView alloc]init];
    }
    return _ringhtImageView;
}

- (MKPageControlView *)pageControlView {
    if (!_pageControlView) {
        _pageControlView = [[MKPageControlView alloc]init];
        _pageControlView.delegate = self;
    }
    return _pageControlView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor redColor];
    }
    return _titleLabel;
}
@end
