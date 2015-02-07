//
//  IAWPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 06/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <CloudantSync.h>

#import "IAWPersistenceDatastore.h"

#import "CDTDatastore+IAWPersistenceDatastoreProtocol.h"

#import "IAWLog.h"



#define IAWPERSISTENCEDATASTORE_MANAGERDIRECTORY    @"cloudant-sync-datastore"
#define IAWPERSISTENCEDATASTORE_DATASTORENAME       @"answers"

#define IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_NAME    @"cloudantAnswersDatabaseURL"
#define IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_EXT     @"plist"
#define IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_URLKEY  @"url"



@interface IAWPersistenceDatastore () <CDTReplicatorDelegate>

@property (strong, nonatomic, readonly) CDTDatastore *cloudantDatastore;
@property (strong, nonatomic, readonly) CDTReplicator *pushReplicatorOrNil;

@end



@implementation IAWPersistenceDatastore

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if (self)
    {
        CDTDatastoreManager *manager = [IAWPersistenceDatastore datastoreManager];
        
        _cloudantDatastore = [IAWPersistenceDatastore datastoreWithManager:manager];
        
        NSURL *cloudantDatabaseURL = [IAWPersistenceDatastore cloudantDatabaseURL];
        if (cloudantDatabaseURL)
        {
            _pushReplicatorOrNil = [IAWPersistenceDatastore pushReplicatorWithManager:manager
                                                                               source:_cloudantDatastore
                                                                               target:cloudantDatabaseURL];
            _pushReplicatorOrNil.delegate = self;
        }
        else
        {
            IAWLogWarn(@"URL for Cloudant database not informed. Data won't be replicated");
        }
    }
    
    return self;
}


#pragma mark - CDTReplicatorDelegate methods
- (void)replicatorDidChangeState:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replicator: %@", replicator);
}

- (void)replicatorDidChangeProgress:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replicator: %@", replicator);
}

- (void)replicatorDidComplete:(CDTReplicator *)replicator
{
    IAWLogDebug(@"Replicator: %@", replicator);
}

- (void)replicatorDidError:(CDTReplicator *)replicator info:(NSError *)info
{
    IAWLogDebug(@"Replicator: %@. Info: %@", replicator, info);
}


#pragma mark - IAWPersistenceDatastoreProtocol methods
- (BOOL)createDocument:(id<IAWPersistenceDocumentProtocol>)document
                 error:(NSError **)error
{
    BOOL success = [self.cloudantDatastore createDocument:document error:error];
    if (success && self.pushReplicatorOrNil)
    {
        NSError *replicatorError = nil;
        if (![self.pushReplicatorOrNil startWithError:&replicatorError])
        {
            IAWLogWarn(@"Replication not started: %@", replicatorError);
        }
    }
    
    return success;
}

- (NSArray *)allDocuments
{
    return [self.cloudantDatastore allDocuments];
}


#pragma mark - Public class methods
+ (instancetype)datastore
{
    return [[[self class] alloc] init];
}


#pragma mark - Private class methods
+ (CDTDatastoreManager *)datastoreManager
{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    NSArray *allURLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [allURLs lastObject];
    
    NSURL *managerURL = [documentsURL URLByAppendingPathComponent:IAWPERSISTENCEDATASTORE_MANAGERDIRECTORY];
    NSString *managerPath = [managerURL path];
    
    NSError *error = nil;
    CDTDatastoreManager *manager = [[CDTDatastoreManager alloc] initWithDirectory:managerPath error:&error];
    NSAssert(manager, @"Datastore manager not created: %@", error);
    
    return manager;
}

+ (CDTDatastore *)datastoreWithManager:(CDTDatastoreManager *)manager
{
    NSError *error = nil;
    CDTDatastore *datastore = [manager datastoreNamed:IAWPERSISTENCEDATASTORE_DATASTORENAME error:&error];
    NSAssert(datastore, @"Datastore not created: %@", error);
    
    return datastore;
}

+ (NSURL *)cloudantDatabaseURL
{
    NSString *path = [[NSBundle mainBundle] pathForResource:IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_NAME
                                                     ofType:IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_EXT];
    if (!path)
    {
        IAWLogWarn(@"File %@.%@ not found",
                   IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_NAME, IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_EXT);
        
        return nil;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!dic)
    {
        IAWLogWarn(@"File %@.%@ can not be parsed to a dictionary",
                   IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_NAME, IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_EXT);
        
        return nil;
    }
    
    NSString *value = [dic valueForKey:IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_URLKEY];
    if (!value)
    {
        IAWLogWarn(@"Key %@ not found in dictionary %@", IAWPERSISTENCEDATASTORE_CLOUDANTURLFILE_URLKEY, dic);
        
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:value];
    if (!url)
    {
        IAWLogWarn(@"%@ is not a valid URL", value);
        
        return nil;
    }
    
    return url;
}

+ (CDTReplicator *)pushReplicatorWithManager:(CDTDatastoreManager *)manager
                                      source:(CDTDatastore *)datastore
                                      target:(NSURL *)remoteDatabaseURL
{
    CDTReplicatorFactory *replicatorFactory = [[CDTReplicatorFactory alloc] initWithDatastoreManager:manager];
    
    CDTPushReplication *pushReplication = [CDTPushReplication replicationWithSource:datastore
                                                                             target:remoteDatabaseURL];
    
    NSError *error = nil;
    CDTReplicator *replicator = [replicatorFactory oneWay:pushReplication error:&error];
    NSAssert(replicator, @"Replicator not created");
    
    return replicator;
}

@end
