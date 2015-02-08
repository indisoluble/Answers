//
//  IAWCloudantSyncDatastoreFactory.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 07/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
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
