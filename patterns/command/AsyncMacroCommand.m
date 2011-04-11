//
//  AsyncMacroCommand.m
//
//  Created by Thomas Newton on 05/04/2011.
//

#import "AsyncMacroCommand.h"
#import "AsyncCommand.h"
#import "SimpleCommand.h"
#import "Notification.h"

@implementation AsyncMacroCommand


@synthesize onCompleteDelegate;


-(id)init{

	if ( self = [super init] ){
	
		_subCommands = [[NSMutableArray alloc] init];
		_executedCommands = [[NSMutableArray alloc] init];
		[self initializeAsyncMacroCommand];
		
		return self;
	}
	
	return nil;
}


//in your subclass - add subcommands via [self addSubcommand:[CommandClass class]];
-(void)initializeAsyncMacroCommand{
}



-(void)setOnCompleteDelegate:(id)del{

	[onCompleteDelgate release];
	onCompleteDelegate = [del retain];
	
}


-(void)addSubCommand:(Class)commandClassRef{
	
	NSValue *command = [NSValue valueWithNonretainedObject:commandClassRef];
	[_subCommands addObject:command];
}


-(void)execute:(id <INotification>)notification{

	_note = [(Notification*)notification retain];
	[self nextCommand];
	
}


-(void)nextCommand
{
	if ( _currentCommand != nil ){
	
		[_executedCommands addObject:_currentCommand];
		_currentCommand = nil;
	}
	

	if ( _subCommands.count > 0 )
	{
		//get the next command...
		NSValue *next = [_subCommands objectAtIndex:0];
		[_subCommands removeObjectAtIndex:0];
		Class commandClassRef = [next nonretainedObjectValue];
		
		//create an instance.
		id<ICommand>commandInstance = [[commandClassRef alloc] init];
		
		
		BOOL isAsync = [(SimpleCommand*)commandInstance isKindOfClass:[AsyncCommand class]];
		
		if ( isAsync )  //if it is an async command set the onComplete delegate ( which should call this method again )
		{
			[(AsyncCommand*)commandInstance setOnCompleteDelegate:self];
			_currentCommand = commandInstance;
		}
		

		//execute the note
		[commandInstance execute:_note];
		
		//if it wasn't an async command, move on.
		if( !isAsync )
		{
			[(NSObject*)commandInstance release];
			[self nextCommand];
		}
	}
	else 
	{
		
		// if the onComplete is nil, do nothing otherwise, call the delegate back to say you're finished.
		if ( self.onCompleteDelegate != nil )
		{
			[self.onCompleteDelegate commandComplete];
		}
		
		[(Notification*)_note release];
		_note = nil;
		self.onCompleteDelegate = nil;
		[self clearExecutedAsyncCommands];
	}

	
}


-(void)commandComplete{
	
	[self nextCommand];
}


-(void)commandComplete:(id<INotification>)newNote{

	[(Notification*)_note release];
	_note = [(NSObject*)newNote retain];
	
	[self commandComplete];
}




-(void)clearExecutedAsyncCommands{
	
	//NSLog(@"Executed Commands to be cleaned up = %d", _executedCommands.count);
	
	for ( int i = _executedCommands.count-1 ; i >= 0 ; i-- ){
	
		AsyncCommand* command = [_executedCommands objectAtIndex:i];
		//NSLog(@"command named %@ now has retain count %d",[command class],[command retainCount]);
		[_executedCommands removeObjectAtIndex:i];
		[command release];
		
	}

	
	
}

-(void)dealloc{
	[_subCommands release];
	[_executedCommands release];
	[super dealloc];
}


@end
