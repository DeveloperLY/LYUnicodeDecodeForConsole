//
//  LYUnicodeDecodeForConsole.h
//  LYUnicodeDecodeForConsole
//
//  Created by LY on 16/8/8.
//  Copyright © 2016年 GeekYL. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LYUnicodeDecodeForConsole : NSObject

@property (nonatomic, strong, readonly) NSBundle* bundle;

+ (instancetype)sharedPlugin;

- (instancetype)initWithBundle:(NSBundle *)plugin;

+ (NSString *)convertUnicode:(NSString*)content;

@end