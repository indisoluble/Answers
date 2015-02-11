//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastore.h"

#import "IAWPersistenceDatastoreSyncJob.h"

#import "IAWCloudantSyncDatabaseURL.h"
#import "IAWCloudantSyncDatastoreFactory.h"
#import "IAWCloudantSyncReplicatorFactory.h"
#import "CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.h"

#import "IAWPersistenceDatastoreReplicatorFactoryDummy.h"



@interface IAWPersistenceDatastore ()

@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreLocalStorageProtocol> localStorage;
@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreReplicatorFactoryProtocol> replicatorFactory;
@property (strong, nonatomic, readonly) IAWPersistenceDatastoreSyncManager *syncManager;

@end



@implementation IAWPersistenceDatastore

#pragma mark - Init object
- (id)init
{
    CDTDatastoreManager *cloudantDatastoreManager = [IAWCloudantSyncDatastoreFactory datastoreManager];
    NSURL *cloudantURLOrNil = [IAWCloudantSyncDatabaseURL cloudantDatabaseURLOrNil];
    
    CDTDatastore *oneLocalStorage = [IAWCloudantSyncDatastoreFactory datastoreWithManager:cloudantDatastoreManager];
    
    id<IAWPersistenceDatastoreReplicatorFactoryProtocol> oneReplicatorFactory = nil;
    if (cloudantURLOrNil)
    {
        CDTReplicatorFactory *cloudantFactory = [IAWCloudantSyncDatastoreFactory replicatorFactoryWithManager:cloudantDatastoreManager];
        
        oneReplicatorFactory = [IAWCloudantSyncReplicatorFactory factoryWithCloudantFactory:cloudantFactory
                                                                                  datastore:oneLocalStorage
                                                                                        url:cloudantURLOrNil];
    }
    else
    {
        oneReplicatorFactory = [IAWPersistenceDatastoreReplicatorFactoryDummy factory];
    }
    
    IAWPersistenceDatastoreSyncManager *oneSyncManager = [IAWPersistenceDatastoreSyncManager synchronizationManager];
    IAWPersistenceDatastoreNotificationCenter *oneNotifCenter = [IAWPersistenceDatastoreNotificationCenter notificationCenter];
    
    return [self initWithLocalStorage:oneLocalStorage
                    replicatorFactory:oneReplicatorFactory
                          syncManager:oneSyncManager
                   notificationCenter:oneNotifCenter];
}

- (id)initWithLocalStorage:(id<IAWPersistenceDatastoreLocalStorageProtocol>)localStorage
         replicatorFactory:(id<IAWPersistenceDatastoreReplicatorFactoryProtocol>)replicatorFactory
               syncManager:(IAWPersistenceDatastoreSyncManager *)syncManager
        notificationCenter:(IAWPersistenceDatastoreNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self)
    {
        if (!localStorage || !replicatorFactory || !syncManager || !notificationCenter)
        {
            self = nil;
        }
        else
        {
            _localStorage = localStorage;
            _replicatorFactory = replicatorFactory;
            _syncManager = syncManager;
            _notificationCenter = notificationCenter;
        }
    }
    
    return self;
}


#pragma mark - Public methods
- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document error:(NSError **)error
{
    BOOL success = [self.localStorage createDocument:document error:error];
    if (success)
    {
        [self.notificationCenter postDidCreateDocumentNotificationWithSender:self];
        
        [self pushDocuments];
    }
    
    return success;
}

- (void)refreshDocuments
{
    [self pullDocuments];
}

- (NSArray *)allDocuments
{
    return [self.localStorage allDocuments];
}


#pragma mark - Private methods
- (void)pushDocuments
{
    id<IAWPersistenceDatastoreReplicatorProtocol> replicator = [self.replicatorFactory pushReplicator];
    
    IAWPersistenceDatastoreSyncJob *syncJob = [IAWPersistenceDatastoreSyncJob syncJobWithReplicator:replicator];
    
    [self.syncManager queueSynchronizationJob:syncJob];
}

- (void)pullDocuments
{
    __weak IAWPersistenceDatastore *weakSelf = self;
    iawPersistenceDatastoreReplicatorCompletionHandlerType block= ^(BOOL success, NSError *error)
    {
        __strong IAWPersistenceDatastore *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.notificationCenter postDidRefreshDocumentsNotificationWithSender:strongSelf];
        }
    };
    
    id<IAWPersistenceDatastoreReplicatorProtocol> replicator = [self.replicatorFactory pullReplicatorWithCompletionHandler:block];
    
    IAWPersistenceDatastoreSyncJob *syncJob = [IAWPersistenceDatastoreSyncJob syncJobWithReplicator:replicator];
    
    [self.syncManager queueSynchronizationJob:syncJob];
}


#pragma mark - Public class methods
+ (instancetype)datastore
{
    return [[[self class] alloc] init];
}

@end
