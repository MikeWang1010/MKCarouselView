//
//  MKPageControlView.m
//  MKCarouselView
//
//  Created by MikeWang on 2017/7/10.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#define kMargin 5.
#define kImageViewWH 8.
#import "MKPageControlView.h"
#import "UIImage+MKUIImage.h"

@interface  MKPageControlView ()

@property (nonatomic, strong) NSMutableArray *pageImageViewArray;
@property (nonatomic, strong) UIImageView *currentImageView;


@end

@implementation MKPageControlView


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat starX = (self.frame.size.width -  kImageViewWH * self.pageImageViewArray.count -  kMargin * self.pageImageViewArray.count - 1) * 0.5;
    for (NSInteger i = 0; i < self.pageImageViewArray.count; i++) {
        UIView *imageView = self.pageImageViewArray[i];
        imageView.frame = CGRectMake(starX + (kMargin + kImageViewWH) * i, (self.frame.size.height - kImageViewWH) * 0.5,kImageViewWH ,kImageViewWH);
    }
}

#pragma mark - 点击改变当前选中的圆点颜色
- (void)imageViewClick:(UITapGestureRecognizer *)gesture {
    UIImage *oldImage = [self.currentImageView.image changeImageWithColor:[UIColor grayColor]];
    self.currentImageView.image = oldImage;
    
    self.currentImageView = (UIImageView *)gesture.view;
    UIImage *currentImage = [self.currentImageView.image changeImageWithColor:[UIColor blueColor]];
    self.currentImageView.image = currentImage;
    if ([self.delegate respondsToSelector:@selector(pageControlView:didChangeWithIndex:)]) {
        [self.delegate pageControlView:self didChangeWithIndex:self.currentImageView.tag];
    }
}

#pragma mark - 根据传过来的数量生成圆点
- (void)setupSubView {
    if (self.pageCount > 0) {
        for (NSInteger i = 0; i < self.pageCount; i++) {
            UIGraphicsBeginImageContext(CGSizeMake(kImageViewWH, kImageViewWH));
            UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kImageViewWH, kImageViewWH) cornerRadius:kImageViewWH * 0.5];
            if (i == 0){
                [[UIColor blueColor]set];
            }else {
                [[UIColor grayColor]set];
            }
            [path3 fill];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
            [imageView addGestureRecognizer:gesture];
            [self.pageImageViewArray addObject:imageView];
            [self addSubview:imageView];
            UIGraphicsEndImageContext();
        }
    }
    [self setNeedsDisplay];
}

#pragma mark - 根据传过来的数量生成圆点
- (void)setPageCount:(NSInteger)pageCount {
    _pageCount = pageCount;
    [self setupSubView];
}

#pragma mark - 设置当前选中的圆点颜色
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (currentIndex < self.pageImageViewArray.count) {
        if (self.currentImageView){
            UIImage *oldImage = [self.currentImageView.image changeImageWithColor:[UIColor grayColor]];
            self.currentImageView.image = oldImage;
        }
        self.currentImageView = self.pageImageViewArray[currentIndex];;
        UIImage *currentImage = [self.currentImageView.image changeImageWithColor:[UIColor blueColor]];
        self.currentImageView.image = currentImage;
    }
}

- (NSMutableArray *)pageImageViewArray {
    if (!_pageImageViewArray) {
        _pageImageViewArray = [NSMutableArray array];
    }
    return _pageImageViewArray;
}


@end
