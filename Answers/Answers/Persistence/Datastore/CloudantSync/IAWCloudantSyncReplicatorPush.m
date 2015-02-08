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
    return [self initWithFactory:nil source:nil target:nil];
}

- (id)initWithFactory:(CDTReplicatorFactory *)replicatorFactory
               source:(CDTDatastore *)datastore
               target:(NSURL *)remoteDatabaseURL
{
    self = [super init];
    if (self)
    {
        CDTReplicator *thisReplicator = [IAWCloudantSyncReplicatorPush pushReplicatorWithFactory:replicatorFactory
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
        [self.delegate datastoreReplicatorDidFinish:self];
    }
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogError(@"Replication failed: %@", info);
    
    if (self.delegate)
    {
        [self.delegate datastoreReplicatorDidFinish:self];
    }
}


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    return [self.replicator startWithError:error];
}


#pragma mark - Public class methods
+ (instancetype)replicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL
{
    return [[[self class] alloc] initWithFactory:replicatorFactory source:datastore target:remoteDatabaseURL];
}


#pragma mark - Private class methods
+ (CDTReplicator *)pushReplicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                                      source:(CDTDatastore *)datastore
                                      target:(NSURL *)remoteDatabaseURL
{
    if (!replicatorFactory || !datastore || !remoteDatabaseURL)
    {
        IAWLogError(@"All parameters are mandatory");
        
        return nil;
    }
    
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
