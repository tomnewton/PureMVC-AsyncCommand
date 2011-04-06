//
//  AsyncMacroCommand.h
//
//  Created by Thomas Newton on 05/04/2011.
//

#import "Notifier.h"
#import "IAsyncCommand.h"
#import "INotifier.h"

@interface AsyncMacroCommand : Notifier<IAsyncCommand, AsyncCommandDelegate> {

	id<AsyncCommandDelegate>		onCompleteDelgate;
	
@private
	
	id<INotification>				_note;
	
	NSMutableArray*					_subCommands;
}

@property(nonatomic, retain, setter=setOnCompleteDelegate) id<AsyncCommandDelegate> onCompleteDelegate;

-(void)addSubCommand:(Class)commandClassRef;
-(void)initializeAsyncMacroCommand;
-(void)nextCommand;

@end
