//
//  IAWCloudantSyncReplicatorPush.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudantSync.h>

#import "IAWPersistenceDatastoreReplicatorProtocol.h"



@interface IAWCloudantSyncReplicatorPush : NSObject <IAWPersistenceDatastoreReplicatorProtocol>

- (id)initWithManager:(CDTDatastoreManager *)manager
               source:(CDTDatastore *)datastore
               target:(NSURL *)remoteDatabaseURL;

+ (instancetype)replicatorWithManager:(CDTDatastoreManager *)manager
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL;

@end
