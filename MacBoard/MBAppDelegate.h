//
//  MBAppDelegate.h
//  MacBoard
//
//  Created by C.W. Betts on 12/17/13.
//  Copyright (c) 2013 GNU Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSMenuItem *saveOnExitItem;

- (IBAction)loadNextGame:(id)sender;
- (IBAction)loadPreviousGame:(id)sender;
- (IBAction)reloadGame:(id)sender;
- (IBAction)loadNextPosition:(id)sender;
- (IBAction)loadPreviousPosition:(id)sender;
- (IBAction)reloadPosition:(id)sender;
- (IBAction)loadGame:(id)sender;
- (IBAction)loadPosition:(id)sender;
- (IBAction)saveGame:(id)sender;
- (IBAction)bugReport:(id)sender;
- (IBAction)showUserGuide:(id)sender;
- (IBAction)goToHomePage:(id)sender;
- (IBAction)goToNewsPage:(id)sender;
- (IBAction)saveOnExitToggle:(id)sender;

@end
