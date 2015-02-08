//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastore.h"

#import "IAWPersistenceDatastoreSyncManager.h"

#import "IAWCloudantSyncDatabaseURL.h"
#import "IAWCloudantSyncDatastoreFactory.h"
#import "IAWCloudantSyncReplicatorPush.h"

#import "IAWLog.h"

#import "CDTDatastore+IAWPersistenceDatastoreProtocol.h"



@interface IAWPersistenceDatastore ()

@property (strong, nonatomic, readonly) CDTDatastoreManager *cloudantManager;
@property (strong, nonatomic, readonly) CDTDatastore *cloudantDatastore;

@property (strong, nonatomic, readonly) NSURL *cloudantURLOrNil;

@property (strong, nonatomic, readonly) IAWPersistenceDatastoreSyncManager *syncManager;

@end



@implementation IAWPersistenceDatastore

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if (self)
    {
        _cloudantManager = [IAWCloudantSyncDatastoreFactory datastoreManager];
        _cloudantDatastore = [IAWCloudantSyncDatastoreFactory datastoreWithManager:_cloudantManager];
        
        _cloudantURLOrNil = [IAWCloudantSyncDatabaseURL cloudantDatabaseURLOrNil];
        
        _syncManager = [IAWPersistenceDatastoreSyncManager synchronizationManager];
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreProtocol methods
- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error
{
    BOOL success = [self.cloudantDatastore createDocument:document error:error];
    if (success)
    {
        [self pushChangesToCloudantDatabase];
    }
    
    return success;
}

- (NSArray *)allDocuments
{
    return [self.cloudantDatastore allDocuments];
}


#pragma mark - Private methods
- (void)pushChangesToCloudantDatabase
{
    if (!self.cloudantURLOrNil)
    {
        IAWLogWarn(@"URL for Cloudant database not informed. Data can not replicated");
        
        return;
    }
    
    IAWCloudantSyncReplicatorPush *replicator = [IAWCloudantSyncReplicatorPush replicatorWithManager:self.cloudantManager
                                                                                              source:self.cloudantDatastore
                                                                                              target:self.cloudantURLOrNil];
    
    [self.syncManager queueSynchronizationJob:replicator];
}


#pragma mark - Public class methods
+ (instancetype)datastore
{
    return [[[self class] alloc] init];
}

@end
