//
//  IAWCloudantSyncDatastoreFactory.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
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

#import "IAWCloudantSyncDatastoreFactory.h"



#define IAWCLOUDANTSYNCDATASTOREFACTORY_MANAGERDIRECTORY    @"cloudant-sync-datastore"
#define IAWCLOUDANTSYNCDATASTOREFACTORY_DATASTORENAME       @"answers"



@interface IAWCloudantSyncDatastoreFactory ()

@end



@implementation IAWCloudantSyncDatastoreFactory

#pragma mark - Public class methods
+ (CDTDatastoreManager *)datastoreManager
{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    NSArray *allURLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [allURLs lastObject];
    
    NSURL *managerURL = [documentsURL URLByAppendingPathComponent:IAWCLOUDANTSYNCDATASTOREFACTORY_MANAGERDIRECTORY];
    NSString *managerPath = [managerURL path];
    
    NSError *error = nil;
    CDTDatastoreManager *manager = [[CDTDatastoreManager alloc] initWithDirectory:managerPath error:&error];
    NSAssert(manager, @"Datastore manager not created: %@", error);
    
    return manager;
}

+ (CDTDatastore *)datastoreWithManager:(CDTDatastoreManager *)manager
{
    NSError *error = nil;
    CDTDatastore *datastore = [manager datastoreNamed:IAWCLOUDANTSYNCDATASTOREFACTORY_DATASTORENAME error:&error];
    NSAssert(datastore, @"Datastore not created: %@", error);
    
    return datastore;
}

+ (CDTReplicatorFactory *)replicatorFactoryWithManager:(CDTDatastoreManager *)manager
{
    return [[CDTReplicatorFactory alloc] initWithDatastoreManager:manager];
}

@end
