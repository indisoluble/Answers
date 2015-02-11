//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastore.h"

#import "IAWPersistenceDatastoreSyncJob.h"
#import "IAWPersistenceDatastoreReplicatorFactoryDummy.h"

#import "IAWCloudantSyncDatabaseURL.h"
#import "IAWCloudantSyncDatastoreFactory.h"
#import "IAWCloudantSyncReplicatorFactory.h"
#import "CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.h"



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
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    id<IAWPersistenceDatastoreDocumentProtocol> doc = [self.localStorage createDocumentWithDictionary:dictionary
                                                                                                error:error];
    if (doc)
    {
        [self pushChanges];
        
        [self.notificationCenter postDidCreateDocumentNotificationWithSender:self];
    }
    
    return doc;
}

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error
{
    BOOL success = [self.localStorage deleteDocument:document error:error];
    if (success)
    {
        [self pushChanges];
        
        [self.notificationCenter postDidDeleteDocumentNotificationWithSender:self];
    }
    
    return success;
}

- (void)refreshDocuments
{
    [self pullChanges];
}

- (NSArray *)allDocuments
{
    return [self.localStorage allDocuments];
}


#pragma mark - Private methods
- (void)pushChanges
{
    id<IAWPersistenceDatastoreReplicatorProtocol> replicator = [self.replicatorFactory pushReplicator];
    
    IAWPersistenceDatastoreSyncJob *syncJob = [IAWPersistenceDatastoreSyncJob syncJobWithReplicator:replicator];
    
    [self.syncManager queueSynchronizationJob:syncJob];
}

- (void)pullChanges
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
