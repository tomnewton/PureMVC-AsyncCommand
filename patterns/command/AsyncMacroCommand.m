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


-(void)execute:(id <INotification, NSObject>)notification{

	_note = [notification retain];
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
		id<ICommand,NSObject> commandInstance = [[commandClassRef alloc] init];
		
		
		//BOOL isAsync = [(SimpleCommand*)commandInstance isKindOfClass:[AsyncCommand class]];
		BOOL isAsync = [commandClassRef conformsToProtocol:@protocol(IAsyncCommand)];
		
		
		if ( isAsync )  //if it is an async command set the onComplete delegate ( which should call this method again )
		{
			[(id<IAsyncCommand>)commandInstance setOnCompleteDelegate:self];
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


-(void)commandComplete:(id<INotification, NSObject>)newNote{

	[_note release];
	_note = [newNote retain];
	
	[self commandComplete];
}




-(void)clearExecutedAsyncCommands{
	
	//NSLog(@"Executed Commands to be cleaned up = %d", _executedCommands.count);
	
	for ( int i = _executedCommands.count-1 ; i >= 0 ; i-- ){
	
		id<IAsyncCommand, NSObject> command = [_executedCommands objectAtIndex:i];
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
