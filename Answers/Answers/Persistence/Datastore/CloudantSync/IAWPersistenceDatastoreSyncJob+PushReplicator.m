//
//  IAWPersistenceDatastoreSyncJob+PushReplicator.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreSyncJob+PushReplicator.h"

#import "IAWCloudantSyncReplicatorPush.h"



@implementation IAWPersistenceDatastoreSyncJob (PushReplicator)

#pragma mark - Public class methods
+ (instancetype)syncJobWithWithManager:(CDTDatastoreManager *)manager
                                source:(CDTDatastore *)datastore
                                target:(NSURL *)remoteDatabaseURL
{
    IAWCloudantSyncReplicatorPush *replicator = [IAWCloudantSyncReplicatorPush replicatorWithManager:manager
                                                                                              source:datastore
                                                                                              target:remoteDatabaseURL];
    
    return [IAWPersistenceDatastoreSyncJob syncJobWithReplicator:replicator];
}

@end
