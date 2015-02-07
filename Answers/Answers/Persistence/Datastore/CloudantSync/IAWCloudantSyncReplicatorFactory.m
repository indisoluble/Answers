//
//  IAWCloudantSyncReplicatorFactory.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWCloudantSyncReplicatorFactory.h"



@interface IAWCloudantSyncReplicatorFactory ()

@end



@implementation IAWCloudantSyncReplicatorFactory

#pragma mark - Public class methods
+ (CDTReplicator *)pushReplicatorWithManager:(CDTDatastoreManager *)manager
                                      source:(CDTDatastore *)datastore
                                      target:(NSURL *)remoteDatabaseURL
{
    CDTReplicatorFactory *replicatorFactory = [[CDTReplicatorFactory alloc] initWithDatastoreManager:manager];
    
    CDTPushReplication *pushReplication = [CDTPushReplication replicationWithSource:datastore
                                                                             target:remoteDatabaseURL];
    
    NSError *error = nil;
    CDTReplicator *replicator = [replicatorFactory oneWay:pushReplication error:&error];
    NSAssert(replicator, @"Replicator not created");
    
    return replicator;
}

@end
