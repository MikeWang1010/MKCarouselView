//
//  ViewController.m
//  MKCarouselView
//
//  Created by MikeWang on 2017/7/7.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import "ViewController.h"
#import "MKCarouselView.h"
#import "MKCarouselViewModel.h"

@interface ViewController ()<MKCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        MKCarouselViewModel *model = [[MKCarouselViewModel alloc]init];
        model.title = [NSString stringWithFormat:@"这是第%ld个图片",i + 1];
        model.iconName = [NSString stringWithFormat:@"%ld",i];
        [dataArray addObject:model];
    }

    MKCarouselView *carouseView = [[MKCarouselView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 150) dataArray:dataArray];
    carouseView.delegate = self;
    [self.view addSubview:carouseView];
}

- (void)carouselView:(MKCarouselView *)carouselView didActionWithIndex:(NSInteger)currentIndex {
    NSLog(@"点击了第%ld个",currentIndex + 1);
}
@end
