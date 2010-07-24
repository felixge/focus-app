#import "FocusAppDelegate.h"

@implementation FocusAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	backdrops = [[NSMutableArray alloc] init];
	for (NSScreen *screen in [NSScreen screens]) {
		BackdropWindow *backdrop = [[BackdropWindow alloc] initWithScreen:screen];
		backdrop.delegate = self;
		[backdrops addObject:backdrop];
	}
	[self focus];


	[self bindHotkeyWithCode:48 modifiers:cmdKey+optionKey action:@selector(focus)];
	[self bindHotkeyWithCode:36 modifiers:cmdKey+optionKey action:@selector(clear)];
	[self bindHotkeyWithCode:36 modifiers:cmdKey+controlKey action:@selector(refocus)];
}

- (void)bindHotkeyWithCode:(NSInteger)keyCode modifiers:(NSUInteger)modifiers action:(SEL)action
{
	PTHotKey *hotkey = [[PTHotKey alloc]
						initWithIdentifier:nil
						keyCombo:[PTKeyCombo keyComboWithKeyCode:keyCode modifiers:modifiers]];
	[hotkey setTarget:self];
	[hotkey setAction:action];
	[[PTHotKeyCenter sharedCenter] registerHotKey:hotkey];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[self refocus];
}

- (void)refocus
{
	[self clear];
	[self activateActiveApp];
}

- (void)focus
{
	[self captureActiveApp];
	[self refocus];
}

- (void)captureActiveApp
{
	// I know what you think ... why isn't he using some native Cocoa API's? Well it turns out Cocoa is not meant
	// for writing apps that control other apps. So as dirty as this looks, afaik it is the "cleanest" way to
	// to do the window focus juggling I'm trying to achieve here.
	NSAppleScript *as = [[NSAppleScript alloc] initWithSource:@"path to frontmost application as string"];
	NSString *path = [[as executeAndReturnError:nil] stringValue];
	
	NSRange textRange = [path rangeOfString:@"Focus.app"];
	if(textRange.location == NSNotFound) {
		activeApp = path;
		[activeApp retain];
	}	
}

- (void)activateActiveApp
{
	if (!activeApp) {
		return;
	}

	// see comment in: captureActiveApp
	NSString *script = [NSString stringWithFormat:
						@"set front_app to (\"%@\")\ntell application front_app\nactivate\nend tell\n",
						activeApp
						];
	NSAppleScript *as =	[[NSAppleScript alloc] initWithSource:script];
	[as executeAndReturnError:nil];
}

- (void)clear
{	
	for (BackdropWindow *backdrop in backdrops) {
		[backdrop makeKeyAndOrderFront:NSApp];
	}

	// see comment in: captureActiveApp
	NSString *script = [NSString stringWithFormat:
						@"set front_app to (\"Focus.app\")\ntell application front_app\nactivate\nend tell\n",
						activeApp
						];
	NSAppleScript *as =	[[NSAppleScript alloc] initWithSource:script];
	[as executeAndReturnError:nil];
}

@end
