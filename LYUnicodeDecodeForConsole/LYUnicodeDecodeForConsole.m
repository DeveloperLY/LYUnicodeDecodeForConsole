//
//  LYUnicodeDecodeForConsole.m
//  LYUnicodeDecodeForConsole
//
//  Created by LY on 16/8/8.
//  Copyright © 2016年 GeekYL. All rights reserved.
//

#import "LYUnicodeDecodeForConsole.h"
#import <objc/runtime.h>

static LYUnicodeDecodeForConsole *sharedPlugin;

static NSString *kUnicodeDecodeForConsoleItemEnableKey = @"kUnicodeDecodeForConsoleItemEnableKey";

static BOOL isOpenLYUnicodeDecode;

// IDEConsoleItem
@interface LYIDEConsoleItem : NSObject

- (id)initWithAdaptorType:(id)arg1 content:(id)arg2 kind:(int)arg3;

@end

static IMP IMP_IDEConsoleItem_initWithAdaptorType = nil;

@implementation LYIDEConsoleItem

- (id)initWithAdaptorType:(id)arg1 content:(id)arg2 kind:(int)arg3 {
    id (*execIMP)(id, SEL, id, id, int) = (void *)IMP_IDEConsoleItem_initWithAdaptorType;
    id item = execIMP(self, _cmd, arg1, arg2, arg3);
    if (isOpenLYUnicodeDecode) {
        NSString *logText = [item valueForKey:@"content"];
        NSString *resultText = [LYUnicodeDecodeForConsole convertUnicode:logText];
        [item setValue:resultText forKey:@"content"];
    }
    
    return item;
}

@end


@interface LYUnicodeDecodeForConsole ()

@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic, strong) NSMenuItem *unicodeDecodeForConsoleItem;

@end

@implementation LYUnicodeDecodeForConsole

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
        
        IMP_IDEConsoleItem_initWithAdaptorType = method_getImplementation(class_getInstanceMethod(NSClassFromString(@"IDEConsoleItem"), @selector(initWithAdaptorType:content:kind:)));
        method_setImplementation(class_getInstanceMethod(NSClassFromString(@"IDEConsoleItem"), @selector(initWithAdaptorType:content:kind:)), class_getMethodImplementation([LYIDEConsoleItem class], @selector(initWithAdaptorType:content:kind:)));
        
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
{
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenu *mainMenu = [NSApp mainMenu];
    if (!mainMenu) {
        return NO;
    }
    
    NSMenuItem *pluginsMenuItem = [mainMenu itemWithTitle:@"Plugins"];
    if (!pluginsMenuItem) {
        pluginsMenuItem = [[NSMenuItem alloc] init];
        pluginsMenuItem.title = @"Plugins";
        pluginsMenuItem.submenu = [[NSMenu alloc] initWithTitle:pluginsMenuItem.title];
        NSInteger windowIndex = [mainMenu indexOfItemWithTitle:@"Window"];
        [mainMenu insertItem:pluginsMenuItem atIndex:windowIndex];
    }
    if (pluginsMenuItem && !self.unicodeDecodeForConsoleItem) {
        self.unicodeDecodeForConsoleItem = [[NSMenuItem alloc] initWithTitle:@"LYUnicodeDecodeForConsole" action:@selector(unicodeDecodeItemAction:) keyEquivalent:@""];
        self.unicodeDecodeForConsoleItem.target = self;
        [pluginsMenuItem.submenu addItem:self.unicodeDecodeForConsoleItem];
        
        isOpenLYUnicodeDecode = [[NSUserDefaults standardUserDefaults] boolForKey:kUnicodeDecodeForConsoleItemEnableKey];
        isOpenLYUnicodeDecode = YES;
        if (isOpenLYUnicodeDecode) {
            self.unicodeDecodeForConsoleItem.state = NSOnState;
        } else {
            self.unicodeDecodeForConsoleItem.state = NSOnState;
        }
    }
    
    return YES;
}

// Sample Action, for menu item:
- (void)unicodeDecodeItemAction:(NSMenuItem *)menuItem {
    BOOL convertInConsoleEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kUnicodeDecodeForConsoleItemEnableKey];
    [[NSUserDefaults standardUserDefaults] setBool:!convertInConsoleEnable forKey:kUnicodeDecodeForConsoleItemEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    isOpenLYUnicodeDecode = !convertInConsoleEnable;
    if (isOpenLYUnicodeDecode) {
        self.unicodeDecodeForConsoleItem.state = NSOnState;
    } else {
        self.unicodeDecodeForConsoleItem.state = NSOffState;
    }
}

+ (NSString*)convertUnicode:(NSString *)content {
    NSMutableString *convertedString = [content mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}

@end
