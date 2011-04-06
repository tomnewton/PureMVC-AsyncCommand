//
//  AsyncCommand.m
//
//  Created by Thomas Newton on 05/04/2011.
//

#import "AsyncCommand.h"


@implementation AsyncCommand

@synthesize asyncMacroCommand;


-(void)setOnCompleteDelegate:(id <AsyncCommandDelegate>)del{

	[asyncMacroCommand release];
	asyncMacroCommand = [del retain];
}

-(void)commandComplete{

	[self.asyncMacroCommand commandComplete]; //notify the parent AsyncMacroCommand that you're finished.
	self.asyncMacroCommand = nil;
}


-(void)dealloc{

	self.asyncMacroCommand = nil;
	[super dealloc];
}


@end
