//
//  MKPageControlView.h
//  MKCarouselView
//
//  Created by MikeWang on 2017/7/10.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKPageControlView;

@protocol MKPageControlViewDelegate <NSObject>

@optional

- (void)pageControlView:(MKPageControlView *)view didChangeWithIndex:(NSInteger)current;

@end

@interface MKPageControlView : UIView

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id <MKPageControlViewDelegate> delegate;

@end
