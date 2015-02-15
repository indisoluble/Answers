//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastore.h"

#import "IAWPersistenceDatastoreSyncJob.h"



@interface IAWPersistenceDatastore ()

@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreLocalStorageProtocol> localStorage;
@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreReplicatorFactoryProtocol> replicatorFactory;
@property (strong, nonatomic, readonly) IAWPersistenceDatastoreSyncManager *syncManager;

@end



@implementation IAWPersistenceDatastore

#pragma mark - Init object
- (id)init
{
    return [self initWithLocalStorage:nil
                         indexManager:nil
                    replicatorFactory:nil
                          syncManager:nil
                   notificationCenter:nil];
}

- (id)initWithLocalStorage:(id<IAWPersistenceDatastoreLocalStorageProtocol>)localStorage
              indexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
         replicatorFactory:(id<IAWPersistenceDatastoreReplicatorFactoryProtocol>)replicatorFactory
               syncManager:(IAWPersistenceDatastoreSyncManager *)syncManager
        notificationCenter:(IAWPersistenceDatastoreNotificationCenter *)notificationCenter
{
    self = [super init];
    if (self)
    {
        if (!localStorage || !indexManager || !replicatorFactory || !syncManager || !notificationCenter)
        {
            self = nil;
        }
        else
        {
            _localStorage = localStorage;
            _indexManager = indexManager;
            _replicatorFactory = replicatorFactory;
            _syncManager = syncManager;
            _notificationCenter = notificationCenter;
        }
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreProtocol methods
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

@end
