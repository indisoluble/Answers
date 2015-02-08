//
//  IAWPersistenceDatastoreSyncJobProtocol.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)(void);



@protocol IAWPersistenceDatastoreSyncJobProtocol <NSObject>

- (void)startWithCompletionHandler:(iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)completionHandler;

@end
