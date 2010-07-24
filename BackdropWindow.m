#import "BackdropWindow.h"


@implementation BackdropWindow

@synthesize mouseClickSelector, delegate;

- (id)initWithScreen:(NSScreen *)screen
{
	NSRect frame = [screen frame];
	[self initWithContentRect:frame
					styleMask:NSBorderlessWindowMask
					  backing:NSBackingStoreBuffered
						defer:NO];
	[self setBackgroundColor:[NSColor blackColor]];

	return self;
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[delegate performSelector:@selector(mouseUp:) withObject:theEvent];
}

@end
