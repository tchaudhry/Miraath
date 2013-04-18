//
//  UIImage+Block.m
//  Miraath
//
//  Created by Tanwir Chaudhry on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import "UIImage+Block.h"

@implementation UIImage (Block)
+ (UIImage *)imageWithSize:(CGSize)size block:(void(^)(CGContextRef))block
{
    return [[self class] imageWithSize:size opaque:NO scale:.0f block:block];
}

+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque block:(void (^)(CGContextRef))block
{
    return [[self class] imageWithSize:size opaque:opaque scale:.0f block:block];
}

+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale block:(void (^)(CGContextRef))block
{
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (block) block(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)resizableImageWithSize:(CGSize)size capInsets:(UIEdgeInsets)capInsets block:(void(^)(CGContextRef))block
{
    UIImage *image = [[self class] imageWithSize:size block:block];
    return [image resizableImageWithCapInsets:capInsets];
}

@end
