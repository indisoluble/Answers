//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
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

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error
{
    id<IAWPersistenceDatastoreDocumentProtocol> nextDoc = [self.localStorage replaceDocument:document
                                                                              withDictionary:dictionary
                                                                                       error:error];
    if (nextDoc)
    {
        [self pushChanges];
        
        [self.notificationCenter postDidReplaceDocumentNotificationWithSender:self];
    }
    
    return nextDoc;
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

- (IAWPersistenceDatastore_deleteDocumentList_resultType)deleteDocumentList:(NSArray *)documents
                                                                      error:(NSError **)error
{
    BOOL didDeleteDocuments = YES;
    IAWPersistenceDatastore_deleteDocumentList_resultType result = IAWPersistenceDatastore_deleteDocumentList_resultType_success;
    
    switch ([self.localStorage deleteDocumentList:documents error:error])
    {
        case IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_success:
        {
            result = IAWPersistenceDatastore_deleteDocumentList_resultType_success;
            
            break;
        }
        case IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_someDocumentsDeleted:
        {
            result = IAWPersistenceDatastore_deleteDocumentList_resultType_someDocumentsDeleted;
            
            break;
        }
        case IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_noDocumentDeleted:
        default:
        {
            didDeleteDocuments = NO;
            
            result = IAWPersistenceDatastore_deleteDocumentList_resultType_noDocumentDeleted;
            
            break;
        }
    }
    
    if (didDeleteDocuments)
    {
        [self pushChanges];
        
        [self.notificationCenter postDidDeleteDocumentListNotificationWithSender:self];
    }
    
    return result;
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
