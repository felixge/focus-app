#import <Foundation/Foundation.h>


@interface BackdropWindow : NSWindow {
	SEL mouseClickSelector;
	id delegate;
}

@property(assign) id delegate;
@property (assign) SEL mouseClickSelector;


- (id)initWithScreen:(NSScreen *)screen;

@end
