//
//  UIColor+SAMColors.m
//  HappyPoops
//
//  Created by Samuel Scherer on 9/10/20.
//  Copyright © 2020 SamuelScherer. All rights reserved.
//

#import "UIColor+SAMColors.h"

@implementation UIColor (UIColor_SAMColors)

+ (UIColor *)halfTransparentDarkColor {
    return [self colorWithWhite:0.25 alpha:0.5];
}
+ (UIColor *)mostlyOpaqueDarkColor {
    return [self colorWithWhite:0.25 alpha:0.85];
}

+ (UIColor *)mostlyClearWhiteColor {
    return [self colorWithWhite:1.0 alpha:0.25];
}

+ (UIColor *)mostlyOpaqueWhiteColor {
    return [self colorWithWhite:1.0 alpha:0.85];
}

@end
