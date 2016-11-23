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
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [self display];
    
    return YES;
}

- (void)display {
    ViewInputController *mainVC = [[ViewInputController alloc] initWithNibName:@"ViewInputController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    nc.view.frame = self.window.bounds;
    mainVC.view.frame = nc.view.bounds;
    self.window.rootViewController = nc;
    [[MAGKeyboardInfo sharedInstance] prepareKeyboardWithMainWindow:self.window];
    [self.window makeKeyAndVisible];
}


- (void)displayWithPush {
    UIViewController *vc = [UIViewController new];
    UIView *view = [UIView new];
    vc.view = view;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.view.frame = self.window.bounds;
    vc.view.frame = nc.view.bounds;
    self.window.rootViewController = nc;
    [[MAGKeyboardInfo sharedInstance] prepareKeyboardWithMainWindow:self.window];
    [self.window makeKeyAndVisible];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ViewInputController *mainVC = [[ViewInputController alloc] initWithNibName:@"ViewInputController" bundle:nil];
        [nc pushViewController:mainVC animated:YES];
    });

}

@end
