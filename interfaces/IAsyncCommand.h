//
//  IAsyncCommand.h
//  
//  Created by Thomas Newton on 05/04/2011.


#import <Foundation/Foundation.h>
#import "ICommand.h"

@protocol AsyncCommandDelegate;


@protocol IAsyncCommand<ICommand>

-(void)setOnCompleteDelegate:(id<AsyncCommandDelegate>)del;
-(void)commandComplete;

@end


@protocol AsyncCommandDelegate<NSObject>

-(void)commandComplete;

@end