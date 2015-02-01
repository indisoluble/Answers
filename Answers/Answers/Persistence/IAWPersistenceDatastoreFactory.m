//
//  IAWPersistenceDatastoreFactory.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "IAWPersistenceDatastoreFactory.h"

#import "CDTDatastore+IAWPersistenceDatastoreProtocol.h"



#define IAWPERSISTENCEDATASTOREFACTORY_MANAGERDIRECTORY @"cloudant-sync-datastore"
#define IAWPERSISTENCEDATASTOREFACTORY_DATASTORENAME    @"answers"



@interface IAWPersistenceDatastoreFactory ()

@end



@implementation IAWPersistenceDatastoreFactory

#pragma mark - Public class methods
+ (id<IAWPersistenceDatastoreProtocol>)datastore
{
    CDTDatastoreManager *manager = [IAWPersistenceDatastoreFactory datastoreManager];
    
    CDTDatastore *datastore = nil;
    if (manager)
    {
        NSError *error = nil;
        datastore = [manager datastoreNamed:IAWPERSISTENCEDATASTOREFACTORY_DATASTORENAME error:&error];
        if (!datastore)
        {
            NSLog(@"Error: %@", error);
        }
    }
    
    return datastore;
}


#pragma mark - Private class methods
+ (CDTDatastoreManager *)datastoreManager
{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    NSArray *allURLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [allURLs lastObject];
    
    NSURL *managerURL = [documentsURL URLByAppendingPathComponent:IAWPERSISTENCEDATASTOREFACTORY_MANAGERDIRECTORY];
    NSString *managerPath = [managerURL path];
    
    NSError *error = nil;
    CDTDatastoreManager *manager = [[CDTDatastoreManager alloc] initWithDirectory:managerPath error:&error];
    if (!manager)
    {
        NSLog(@"Error: %@", error);
    }
    
    return manager;
}

@end
