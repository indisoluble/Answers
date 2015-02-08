//
//  IAWPersistenceDatastoreSyncJob.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 08/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreSyncJob.h"

#import "IAWLog.h"



@interface IAWPersistenceDatastoreSyncJob () <IAWPersistenceDatastoreReplicatorDelegate>

@property (strong, nonatomic) id<IAWPersistenceDatastoreReplicatorProtocol> replicator;

@property (copy, nonatomic) iawPersistenceDatastoreSyncJobCompletionHandlerBlockType completionHandler;

@property (assign, nonatomic) BOOL alreadyStarted;

@end



@implementation IAWPersistenceDatastoreSyncJob

#pragma mark - Init object
- (id)init
{
    return [self initWithReplicator:nil];
}

- (id)initWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator
{
    self = [super init];
    if (self)
    {
        if (!replicator)
        {
            self = nil;
        }
        else
        {
            _replicator = replicator;
            _replicator.delegate = self;
            
            _completionHandler = nil;
            
            _alreadyStarted = NO;
        }
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreReplicatorDelegate methods
- (void)datastoreReplicatorDidComplete:(id<IAWPersistenceDatastoreReplicatorProtocol>)repicator
{
    IAWLogDebug(@"Synchronization completed");
    
    [self notifySynchronizationFinishedOnMainThread];
}

- (void)datastoreReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)repicator
           didFailWithError:(NSError *)error
{
    IAWLogError(@"Synchronization failed: %@", error);
    
    [self notifySynchronizationFinishedOnMainThread];
}

#pragma mark - IAWPersistenceDatastoreSyncJobProtocol methods
- (void)startWithCompletionHandler:(iawPersistenceDatastoreSyncJobCompletionHandlerBlockType)completionHandler
{
    if (self.alreadyStarted)
    {
        IAWLogError(@"A replicator can not be re-used");
        
        [self notifySynchronizationFinishedOnMainThread];
        
        return;
    }
    
    self.alreadyStarted = YES;
    
    self.completionHandler = completionHandler;
    
    NSError *error = nil;
    if (![self.replicator startWithError:&error])
    {
        [self datastoreReplicator:self.replicator didFailWithError:error];
    }
}


#pragma mark - Private methods
- (void)notifySynchronizationFinishedOnMainThread
{
    iawPersistenceDatastoreSyncJobCompletionHandlerBlockType thisCompletionHandler = self.completionHandler;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        thisCompletionHandler();
    });
}


#pragma mark - Public class methods
+ (instancetype)syncJobWithReplicator:(id<IAWPersistenceDatastoreReplicatorProtocol>)replicator
{
    return [[[self class] alloc] initWithReplicator:replicator];
}

@end
