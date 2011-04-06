//
//  AsyncCommand.h
//
//  Created by Thomas Newton on 05/04/2011.
//

#import "SimpleCommand.h"
#import "IAsyncCommand.h"

@interface AsyncCommand : SimpleCommand<IAsyncCommand> {

	id<AsyncCommandDelegate> asyncMacroCommand;
	
}

@property(nonatomic, retain, setter=setOnCompleteDelegate) id<AsyncCommandDelegate> asyncMacroCommand;

@end
