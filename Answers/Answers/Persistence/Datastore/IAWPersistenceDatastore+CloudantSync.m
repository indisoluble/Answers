//
//  IAWPersistenceDatastore+CloudantSync.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
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

#import "IAWPersistenceDatastore+CloudantSync.h"

#import "IAWPersistenceDatastoreReplicatorFactoryDummy.h"

#import "IAWCloudantSyncDatabaseURL.h"
#import "IAWCloudantSyncDatastoreFactory.h"
#import "IAWCloudantSyncIndexManager.h"
#import "IAWCloudantSyncReplicatorFactory.h"
#import "CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.h"



@implementation IAWPersistenceDatastore (CloudantSync)

#pragma mark - Public class methods
+ (instancetype)datastoreWithIndexesForFieldnames:(NSSet *)fieldnames
{
    CDTDatastoreManager *cloudantDatastoreManager = [IAWCloudantSyncDatastoreFactory datastoreManager];
    NSURL *cloudantURLOrNil = [IAWCloudantSyncDatabaseURL cloudantDatabaseURLOrNil];
    
    CDTDatastore *oneLocalStorage = [IAWCloudantSyncDatastoreFactory datastoreWithManager:cloudantDatastoreManager];
    IAWCloudantSyncIndexManager *oneIndexManager = [IAWCloudantSyncIndexManager indexManagerWithIndexesForFieldNames:fieldnames
                                                                                                         inDatastore:oneLocalStorage];
    
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
    
    return [[[self class] alloc] initWithLocalStorage:oneLocalStorage
                                         indexManager:oneIndexManager
                                    replicatorFactory:oneReplicatorFactory
                                          syncManager:oneSyncManager
                                   notificationCenter:oneNotifCenter];
}

@end
