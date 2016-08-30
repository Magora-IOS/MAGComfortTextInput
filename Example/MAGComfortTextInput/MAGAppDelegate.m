//
//  MAGAppDelegate.m
//  MAGComfortTextInput
//
//  Created by Denis Matveev on 08/26/2016.
//  Copyright (c) 2016 Denis Matveev. All rights reserved.
//

#import "MAGAppDelegate.h"
#import "ViewInputController.h"
#import "MAGKeyboardInfo.h"

@implementation MAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewInputController *mainVC = [[ViewInputController alloc] initWithNibName:@"ViewInputController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    nc.view.frame = self.window.bounds;
    mainVC.view.frame = nc.view.bounds;
    self.window.rootViewController = nc;
    [[MAGKeyboardInfo sharedInstance] prepareKeyboardWithMainWindow:self.window];
    [self.window makeKeyAndVisible];
    
//    [KeyboardInfo sharedKeyboardInfo];
    
    return YES;
}

@end
