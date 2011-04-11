//
//  AsyncCommand.m
//
//  Created by Thomas Newton on 05/04/2011.
//

#import "AsyncCommand.h"


@implementation AsyncCommand

@synthesize onCompleteDelegate;



-(void)commandComplete{

	[self.onCompleteDelegate commandComplete]; //notify the parent AsyncMacroCommand that you're finished.
	
}

-(void)commandComplete:(id<INotification>)newNote{

	[self.onCompleteDelegate commandComplete:newNote];
}


-(void)dealloc{
	self.onCompleteDelegate = nil;
	[super dealloc];
}


@end
