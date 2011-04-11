//
//  AsyncMacroCommand.h
//
//  Created by Thomas Newton on 05/04/2011.
//

#import "Notifier.h"
#import "IAsyncCommand.h"
#import "INotifier.h"
#import "AsyncCommand.h"

@interface AsyncMacroCommand : Notifier<IAsyncCommand, AsyncCommandDelegate> {

	id<AsyncCommandDelegate>		onCompleteDelgate;
	
@private
	
	id<INotification>				_note;
	id<ICommand>					_currentCommand;
	NSMutableArray*					_subCommands;
	NSMutableArray*					_executedCommands;
}

@property(nonatomic, retain, setter=setOnCompleteDelegate) id<AsyncCommandDelegate> onCompleteDelegate;

-(void)addSubCommand:(Class)commandClassRef;
-(void)initializeAsyncMacroCommand;
-(void)nextCommand;
-(void)clearExecutedAsyncCommands;

@end
