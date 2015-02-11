//
//  IAWPersistenceDatastoreSyncJob.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



typedef void (^iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)(void);



@interface IAWPersistenceDatastoreSyncJob : NSObject

- (id)initWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator;

- (void)startWithCompletionHandler:(iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)completionHandler;

+ (instancetype)syncJobWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator;

@end
