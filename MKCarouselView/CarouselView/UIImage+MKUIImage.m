//
//  UIImage+MKUIImage.m
//  MKCarouselView
//
//  Created by MikeWang on 2017/7/10.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import "UIImage+MKUIImage.h"

@implementation UIImage (MKUIImage)

//改变图片颜色
- (UIImage *)changeImageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
