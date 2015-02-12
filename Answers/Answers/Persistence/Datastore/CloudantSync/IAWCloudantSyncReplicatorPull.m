//
//  IAWCloudantSyncReplicatorPull.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 09/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWCloudantSyncReplicatorPull.h"

#import "IAWLog.h"



@interface IAWCloudantSyncReplicatorPull () <CDTReplicatorDelegate>

@property (strong, nonatomic, readonly) CDTReplicator *replicator;
@property (copy, nonatomic, readonly) iawCloudantSyncReplicatorPullCompletionHandlerBlockType completionHandler;

@end



@implementation IAWCloudantSyncReplicatorPull

#pragma mark - Synthesize properties
@synthesize delegate = _delegate;


#pragma mark - Init object
- (id)init
{
    return [self initWithFactory:nil source:nil target:nil completionHandler:nil];
}

- (id)initWithFactory:(CDTReplicatorFactory *)replicatorFactory
               source:(CDTDatastore *)datastore
               target:(NSURL *)remoteDatabaseURL
    completionHandler:(iawCloudantSyncReplicatorPullCompletionHandlerBlockType)completionHandler
{
    self = [super init];
    if (self)
    {
        CDTReplicator *thisReplicator = [IAWCloudantSyncReplicatorPull pullReplicatorWithFactory:replicatorFactory
                                                                                          source:remoteDatabaseURL
                                                                                          target:datastore];
        if (!thisReplicator || !completionHandler)
        {
            self = nil;
        }
        else
        {
            _replicator = thisReplicator;
            _replicator.delegate = self;
            
            _completionHandler = [completionHandler copy];
        }
    }
    
    return self;
}


#pragma mark - CDTReplicatorDelegate methods
- (void)replicatorDidComplete:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replication completed");
    
    [self notifyOnMainThreadReplicatorDidFinishWithSuccess:YES error:nil];
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogError(@"Replication failed: %@", info);
    
    [self notifyOnMainThreadReplicatorDidFinishWithSuccess:NO error:info];
}


#pragma mark - IAWPersistenceDatastoreReplicatorProtocol methods
- (BOOL)startWithError:(NSError **)error
{
    IAWLogDebug(@"Replicator started");
    
    NSError *thisError = nil;
    BOOL success = [self.replicator startWithError:&thisError];
    if (!success)
    {
        iawCloudantSyncReplicatorPullCompletionHandlerBlockType thisCompletionHandler = self.completionHandler;
        [IAWCloudantSyncReplicatorPull dispatchBlockToMainThread:^{
            thisCompletionHandler(NO, thisError);
        }];
        
        if (error)
        {
            *error = thisError;
        }
    }
    
    return success;
}


#pragma mark - Private methods
- (void)notifyOnMainThreadReplicatorDidFinishWithSuccess:(BOOL)success error:(NSError *)error
{
    __weak IAWCloudantSyncReplicatorPull *weakSelf = self;
    [IAWCloudantSyncReplicatorPull dispatchBlockToMainThread:^{
        __strong IAWCloudantSyncReplicatorPull *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf notifyReplicatorDidFinishWithSuccess:success error:error];
        }
    }];
}

- (void)notifyReplicatorDidFinishWithSuccess:(BOOL)success error:(NSError *)error
{
    if (self.delegate)
    {
        [self.delegate datastoreReplicatorDidFinish:self];
    }
    
    self.completionHandler(success, error);
}


#pragma mark - Public class methods
+ (instancetype)replicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                               source:(CDTDatastore *)datastore
                               target:(NSURL *)remoteDatabaseURL
                    completionHandler:(iawCloudantSyncReplicatorPullCompletionHandlerBlockType)completionHandler
{
    return [[[self class] alloc] initWithFactory:replicatorFactory
                                          source:datastore
                                          target:remoteDatabaseURL
                               completionHandler:completionHandler];
}


#pragma mark - Private class methods
+ (CDTReplicator *)pullReplicatorWithFactory:(CDTReplicatorFactory *)replicatorFactory
                                      source:(NSURL *)remoteDatabaseURL
                                      target:(CDTDatastore *)datastore
{
    if (!replicatorFactory || !datastore || !remoteDatabaseURL)
    {
        IAWLogError(@"All parameters are mandatory");
        
        return nil;
    }
    
    CDTPullReplication *pullReplication = [CDTPullReplication replicationWithSource:remoteDatabaseURL
                                                                             target:datastore];
    
    NSError *error = nil;
    CDTReplicator *replicator = [replicatorFactory oneWay:pullReplication error:&error];
    if (!replicator)
    {
        IAWLogError(@"Replicator not created: %@", error);
    }
    
    return replicator;
}

+ (void)dispatchBlockToMainThread:(void(^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@end
