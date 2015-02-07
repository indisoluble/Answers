//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastore.h"

#import "IAWCloudantSyncDatabaseURL.h"
#import "IAWCloudantSyncDatastoreFactory.h"
#import "IAWCloudantSyncReplicatorFactory.h"

#import "IAWLog.h"

#import "CDTDatastore+IAWPersistenceDatastoreProtocol.h"



@interface IAWPersistenceDatastore () <CDTReplicatorDelegate>

@property (strong, nonatomic, readonly) CDTDatastoreManager *cloudantManager;
@property (strong, nonatomic, readonly) CDTDatastore *cloudantDatastore;
@property (strong, nonatomic, readonly) NSURL *cloudantURLOrNil;

@property (strong, nonatomic) NSMutableArray *replicators;

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
        
        _replicators = [NSMutableArray array];
    }
    
    return self;
}


#pragma mark - CDTReplicatorDelegate methods
- (void)replicatorDidComplete:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replicator: %@", replicator);
    
    replicator.delegate = nil;
    
    __weak IAWPersistenceDatastore *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong IAWPersistenceDatastore *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.replicators removeObject:replicator];
        }
    });
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogDebug(@"Replicator: %@. Info: %@", replicator, info);
    
    replicator.delegate = nil;
    
    __weak IAWPersistenceDatastore *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong IAWPersistenceDatastore *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.replicators removeObject:replicator];
        }
    });
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
    
    CDTReplicator *replicator = [IAWCloudantSyncReplicatorFactory pushReplicatorWithManager:self.cloudantManager
                                                                                     source:self.cloudantDatastore
                                                                                     target:self.cloudantURLOrNil];
    replicator.delegate = self;
    
    NSError *error = nil;
    if ([replicator startWithError:&error])
    {
        [self.replicators addObject:replicator];
    }
    else
    {
        IAWLogWarn(@"Replication not started: %@", error);
    }
}


#pragma mark - Public class methods
+ (instancetype)datastore
{
    return [[[self class] alloc] init];
}

@end
