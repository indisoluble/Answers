//
//  IAWPersistenceDatastore.h
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
