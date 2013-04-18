//
//  UIImage+Block.h
//  Miraath
//
//  Created by Tanwir Chaudhry on 18/04/2013.
//  Copyright (c) 2013 Jonathan Flintham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Block)

+ (UIImage *)imageWithSize:(CGSize)size block:(void(^)(CGContextRef))block;
+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque block:(void (^)(CGContextRef))block;
+ (UIImage *)imageWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale block:(void (^)(CGContextRef))block;

+ (UIImage *)resizableImageWithSize:(CGSize)size capInsets:(UIEdgeInsets)capInsets block:(void(^)(CGContextRef))block;


@end
