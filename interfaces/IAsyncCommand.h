//
//  IAsyncCommand.h
//  
//  Created by Thomas Newton on 05/04/2011.


#import <Foundation/Foundation.h>
#import "ICommand.h"

@protocol AsyncCommandDelegate;


@protocol IAsyncCommand<ICommand>

@required
-(void)setOnCompleteDelegate:(id<AsyncCommandDelegate>)del;
-(void)commandComplete;

@optional
-(void)commandComplete:(id<INotification>)newNote;

@end


@protocol AsyncCommandDelegate<NSObject>

-(void)commandComplete;
-(void)commandComplete:(id<INotification>)newNote;

@end