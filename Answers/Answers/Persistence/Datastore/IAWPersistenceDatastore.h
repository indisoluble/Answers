//
//  IAWPersistenceDatastore.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreLocalStorageProtocol.h"
#import "IAWPersistenceDatastoreReplicatorFactoryProtocol.h"
#import "IAWPersistenceDatastoreSyncManager.h"
#import "IAWPersistenceDatastoreNotificationCenter.h"



@interface IAWPersistenceDatastore : NSObject

@property (strong, nonatomic, readonly) IAWPersistenceDatastoreNotificationCenter *notificationCenter;

- (id)initWithLocalStorage:(id<IAWPersistenceDatastoreLocalStorageProtocol>)localStorage
         replicatorFactory:(id<IAWPersistenceDatastoreReplicatorFactoryProtocol>)replicatorFactory
               syncManager:(IAWPersistenceDatastoreSyncManager *)syncManager
        notificationCenter:(IAWPersistenceDatastoreNotificationCenter *)notificationCenter;

- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document error:(NSError **)error;
- (void)refreshDocuments;
- (NSArray *)allDocuments;

+ (instancetype)datastore;

@end
