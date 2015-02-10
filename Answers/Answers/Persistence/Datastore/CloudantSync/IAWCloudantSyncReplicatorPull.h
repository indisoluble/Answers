//
//  IAWCloudantSyncReplicatorPull.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 09/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudantSync.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



typedef void (^iawCloudantSyncReplicatorPullCompletionHandlerBlockType)(BOOL success, NSError *error);



@interface IAWCloudantSyncReplicatorPull : NSObject <IAWPersistenceDatastoreReplicatorProtocol>

- (id)initWithFactory:(CDTReplicatorFactory *)replicatorFactory
               source:(CDTDatastore *)datastore
               target:(NSURL *)remoteDatabaseURL
    completionHandler:(iawCloudantSyncReplicatorPullCompletionHandlerBlockType)completionHandler;

+ (instancetype)replicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL
                    completionHandler:(iawCloudantSyncReplicatorPullCompletionHandlerBlockType)completionHandler;

@end
