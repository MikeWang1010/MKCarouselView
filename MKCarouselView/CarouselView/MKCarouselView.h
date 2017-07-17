//
//  MKCarouselView.h
//  MKCarouselView
//
//  Created by MikeWang on 2017/7/7.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKCarouselViewModel,MKCarouselView;
@protocol MKCarouselViewDelegate <NSObject>
@optional

- (void)carouselView:(MKCarouselView *)carouselView didActionWithIndex:(NSInteger)currentIndex;

@end

@interface MKCarouselView : UIView

@property (nonatomic, weak) id <MKCarouselViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray <MKCarouselViewModel *> *)dataArray;

@end
