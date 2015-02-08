//
//  IAWCloudantSyncReplicatorPush.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWCloudantSyncReplicatorPush.h"

#import "IAWLog.h"



@interface IAWCloudantSyncReplicatorPush () <CDTReplicatorDelegate>

@property (strong, nonatomic, readonly) CDTReplicator *replicator;

@end



@implementation IAWCloudantSyncReplicatorPush

#pragma mark - Synthesize properties
@synthesize delegate = _delegate;


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
        CDTReplicator *thisReplicator = [IAWCloudantSyncReplicatorPush pushReplicatorWithManager:manager
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
        }
    }
    
    return self;
}


#pragma mark - CDTReplicatorDelegate methods
- (void)replicatorDidComplete:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replication completed");
    
    if (self.delegate)
    {
        [self.delegate datastoreReplicatorDidComplete:self];
    }
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogError(@"Replication failed: %@", info);
    
    if (self.delegate)
    {
        [self.delegate datastoreReplicator:self didFailWithError:info];
    }
}


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    return [self.replicator startWithError:error];
}


#pragma mark - Public class methods
+ (instancetype)replicatorWithManager:(CDTDatastoreManager *)manager
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL
{
    return [[[self class] alloc] initWithManager:manager source:datastore target:remoteDatabaseURL];
}


#pragma mark - Private class methods
+ (CDTReplicator *)pushReplicatorWithManager:(CDTDatastoreManager *)manager
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
