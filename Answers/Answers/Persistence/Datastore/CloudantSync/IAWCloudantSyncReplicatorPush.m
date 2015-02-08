//
//  IAWCloudantSyncReplicatorPush.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "IAWCloudantSyncReplicatorPush.h"

#import "IAWLog.h"



@interface IAWCloudantSyncReplicatorPush () <CDTReplicatorDelegate>

@property (strong, nonatomic, readonly) CDTReplicator *replicator;

@property (assign, nonatomic) BOOL alreadyStarted;

@property (copy, nonatomic) iawPersistenceDatastoreSyncJobCompletionHandlerBlockType completionHandler;

@end



@implementation IAWCloudantSyncReplicatorPush

#pragma mark - Init object
- (id)init
{
    return [self initWithManager:nil source:nil target:nil];
}

- (id)initWithManager:(CDTDatastoreManager *)manager
               source:(CDTDatastore *)datastore
               target:(NSURL *)remoteDatabaseURL
{
    self = [super init];
    if (self)
    {
        CDTReplicator *thisReplicator = [IAWCloudantSyncReplicatorPush puchReplicatorWithManager:manager
                                                                                          source:datastore
                                                                                          target:remoteDatabaseURL];
        if (!thisReplicator)
        {
            self = nil;
        }
        else
        {
            _replicator = thisReplicator;
            _replicator.delegate = self;
            
            _alreadyStarted = NO;
            
            _completionHandler = nil;
        }
    }
    
    return self;
}


#pragma mark - CDTReplicatorDelegate methods
- (void)replicatorDidComplete:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replication completed");
    
    [self notifyReplicationFinishedOnMainThread];
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogError(@"Replication failed: %@", info);
    
    [self notifyReplicationFinishedOnMainThread];
}


#pragma mark - IAWPersistenceDatastoreSyncJobProtocol methods
- (void)startWithCompletionHandler:(iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)completionHandler
{
    if (self.alreadyStarted)
    {
        IAWLogError(@"A replicator can not be re-used");
        
        [self notifyReplicationFinishedOnMainThread];
        
        return;
    }
    
    self.alreadyStarted = YES;
    
    self.completionHandler = completionHandler;
    
    NSError *error = nil;
    if (![self.replicator startWithError:&error])
    {
        [self replicatorDidError:self.replicator info:error];
    }
}


#pragma mark - Private methods
- (void)notifyReplicationFinishedOnMainThread
{
    iawPersistenceDatastoreSyncJobCompletionHandlerBlockType thisCompletionHandler = self.completionHandler;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        thisCompletionHandler();
    });
}


#pragma mark - Public class methods
+ (instancetype)replicatorWithManager:(CDTDatastoreManager *)manager
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL
{
    return [[[self class] alloc] initWithManager:manager source:datastore target:remoteDatabaseURL];
}


#pragma mark - Private class methods
+ (CDTReplicator *)puchReplicatorWithManager:(CDTDatastoreManager *)manager
                                      source:(CDTDatastore *)datastore
                                      target:(NSURL *)remoteDatabaseURL
{
    if (!manager || !datastore || !remoteDatabaseURL)
    {
        IAWLogError(@"All parameters are mandatory");
        
        return nil;
    }
    
    CDTReplicatorFactory *replicatorFactory = [[CDTReplicatorFactory alloc] initWithDatastoreManager:manager];
    
    CDTPushReplication *pushReplication = [CDTPushReplication replicationWithSource:datastore
                                                                             target:remoteDatabaseURL];
    
    NSError *error = nil;
    CDTReplicator *replicator = [replicatorFactory oneWay:pushReplication error:&error];
    if (!replicator)
    {
        IAWLogError(@"Replicator not created: %@", error);
    }
    
    return replicator;
}

@end
