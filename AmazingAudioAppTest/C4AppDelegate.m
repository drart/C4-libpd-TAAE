//
//  C4AppDelegate.m
//  AmazingAudioAppTest
//
//  Created by Adam Tindale on 2013-07-10.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4AppDelegate.h"

#import "C4AssertionHandler.h"

@implementation C4AppDelegate 
										
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   	launchOptions = launchOptions;

    [C4View class];

    C4AssertionHandler* customAssertionHandler = [[C4AssertionHandler alloc] init];
	[[[NSThread currentThread] threadDictionary] setValue:customAssertionHandler forKey:NSAssertionHandlerKey];
	// NB: your windowing code goes here - e.g. self.window.rootViewController = self.viewController;

    application.statusBarHidden = YES;
    self.window = [[C4Window alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.workspace = [[C4WorkSpace alloc] initWithNibName:@"C4Canvas" bundle:nil];

    _window.rootViewController = self.workspace;
    /* don't ever do the following !
     self.canvasController.view = self.window;
     */

    [self.window makeKeyAndVisible];

    //strangely, if the following call to set the background color isn't made, then the view doesn't receive touch events...
    self.workspace.view.backgroundColor = [UIColor whiteColor];

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    [self.workspace setup];
    return YES;
}

+(void)initialize {
    //set these before everything else.
    [C4Control defaultStyle].alpha = 1.0f;
    [C4Control defaultStyle].animationDuration = 0.0f;
    [C4Control defaultStyle].animationDelay = 0.0f;
    [C4Control defaultStyle].animationOptions = BEGINCURRENT;
    [C4Control defaultStyle].backgroundColor = [UIColor clearColor];
    [C4Control defaultStyle].cornerRadius = 0.0f;
    [C4Control defaultStyle].layer.delegate = self;
    [C4Control defaultStyle].shadowColor = C4GREY;
    [C4Control defaultStyle].shadowOpacity = 0.0f;
    [C4Control defaultStyle].shadowOffset = CGSizeZero;
    [C4Control defaultStyle].repeatCount = 0;

    //Need to have this because the style property doesn't synthesize when setting default appearance
    NSDictionary *basicStyle = @{
    @"alpha":@([C4Control defaultStyle].alpha),
    @"animationDuration":@([C4Control defaultStyle].animationDuration),
    @"animationDelay":@([C4Control defaultStyle].animationDelay),
    @"animationOptions":@([C4Control defaultStyle].animationOptions),
    @"backgroundColor":[C4Control defaultStyle].backgroundColor,
    @"cornerRadius":@([C4Control defaultStyle].cornerRadius),
    @"shadowColor":[C4Control defaultStyle].shadowColor,
    @"shadowOpacity":@([C4Control defaultStyle].shadowOpacity),
    @"shadowOffset":[NSValue valueWithCGSize:[C4Control defaultStyle].shadowOffset],
    @"repeatCount":@([C4Control defaultStyle].repeatCount)
    };

    [C4Control defaultStyle].style = basicStyle;
    [C4ActivityIndicator defaultStyle].color = C4BLUE;

    [C4Button defaultStyle].style = basicStyle;
    [C4Button defaultStyle].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBluePattern@2x"]];

    [C4Label defaultStyle].style = basicStyle;
    [C4Label defaultStyle].textColor = C4GREY;
    [C4Label defaultStyle].highlightedTextColor = C4RED;
    [C4Label defaultStyle].backgroundColor = [UIColor clearColor];

    [C4Shape defaultStyle].style = basicStyle;
    [C4Shape defaultStyle].fillColor = C4GREY;
    [C4Shape defaultStyle].fillRule = FILLNORMAL;
    [C4Shape defaultStyle].lineCap = CAPBUTT;
    [C4Shape defaultStyle].lineDashPattern = nil;
    [C4Shape defaultStyle].lineDashPhase = 0.0f;
    [C4Shape defaultStyle].lineJoin = JOINMITER;
    [C4Shape defaultStyle].lineWidth = 5.0f;
    [C4Shape defaultStyle].miterLimit = 10.0f; //this doesn't like being set here...
    [C4Shape defaultStyle].strokeColor = C4BLUE;
    [C4Shape defaultStyle].strokeEnd = 1.0f;
    [C4Shape defaultStyle].strokeStart = 0.0f;

    [C4Slider defaultStyle].style = basicStyle;
    [C4Slider defaultStyle].thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBluePattern"]];
    [C4Slider defaultStyle].minimumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [C4Slider defaultStyle].maximumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];

    [C4Stepper defaultStyle].style = basicStyle;
    [C4Stepper defaultStyle].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [[C4Stepper defaultStyle] setDecrementImage:[C4Image imageNamed:@"decrementDisabled"] forState:DISABLED];
    [[C4Stepper defaultStyle] setDecrementImage:[C4Image imageNamed:@"decrementNormal"] forState:NORMAL];
    [[C4Stepper defaultStyle] setIncrementImage:[C4Image imageNamed:@"incrementDisabled"] forState:DISABLED];
    [[C4Stepper defaultStyle] setIncrementImage:[C4Image imageNamed:@"incrementNormal"] forState:NORMAL];

    [C4Switch defaultStyle].style = basicStyle;
    [C4Switch defaultStyle].onTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBluePattern"]];
    [C4Switch defaultStyle].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightRedPattern"]];
    [C4Switch defaultStyle].thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [[C4Switch defaultStyle] setOffImage:[C4Image imageNamed:@"switchOff"]];
    [[C4Switch defaultStyle] setOnImage:[C4Image imageNamed:@"switchOn"]];
						
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
    Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    */
}
											
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
    Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    */
}
									
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
    Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    */
}
										
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
    Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    */
}
								
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
    Called when the application is about to terminate.
    Save data if appropriate.
    See also applicationDidEnterBackground:.
    */
}
												
@end
