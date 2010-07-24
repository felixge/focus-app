#import <Foundation/Foundation.h>


@interface BackdropWindow : NSWindow {
	id delegate;
}

@property(assign) id delegate;


- (id)initWithScreen:(NSScreen *)screen;

@end
