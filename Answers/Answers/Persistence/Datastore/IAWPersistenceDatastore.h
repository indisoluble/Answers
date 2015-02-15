//
//  IAWPersistenceDatastore.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWPersistenceDatastoreProtocol.h"

#import "IAWPersistenceDatastoreLocalStorageProtocol.h"
#import "IAWPersistenceDatastoreIndexManagerProtocol.h"
#import "IAWPersistenceDatastoreReplicatorFactoryProtocol.h"
#import "IAWPersistenceDatastoreSyncManager.h"
#import "IAWPersistenceDatastoreNotificationCenter.h"



@interface IAWPersistenceDatastore : NSObject <IAWPersistenceDatastoreProtocol>

@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreIndexManagerProtocol> indexManager;
@property (strong, nonatomic, readonly) IAWPersistenceDatastoreNotificationCenter *notificationCenter;

- (id)initWithLocalStorage:(id<IAWPersistenceDatastoreLocalStorageProtocol>)localStorage
              indexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
         replicatorFactory:(id<IAWPersistenceDatastoreReplicatorFactoryProtocol>)replicatorFactory
               syncManager:(IAWPersistenceDatastoreSyncManager *)syncManager
        notificationCenter:(IAWPersistenceDatastoreNotificationCenter *)notificationCenter;

@end
