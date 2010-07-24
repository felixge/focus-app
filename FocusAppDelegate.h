#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "BackdropWindow.h"
#import "PTHotKey.h"
#import "PTHotKeyCenter.h"

@interface FocusAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
	NSMutableArray *backdrops;
	NSString *activeApp;
}

- (void)bindHotkeyWithCode:(NSInteger)keyCode modifiers:(NSUInteger)modifiers action:(SEL)action;
- (void)refocus;
- (void)focus;
- (void)clear;
- (void)captureActiveApp;
- (void)activateActiveApp;

@end
