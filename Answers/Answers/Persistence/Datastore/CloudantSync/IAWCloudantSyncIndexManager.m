//
//  IAWCloudantSyncIndexManager.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWCloudantSyncIndexManager.h"

#import "CDTDocumentRevision+IAWPersistenceDatastoreDocumentProtocol.h"



@interface IAWCloudantSyncIndexManager ()

@property (strong, nonatomic, readonly) CDTIndexManager *indexManager;

@end



@implementation IAWCloudantSyncIndexManager

#pragma mark - Init object
- (id)init
{
    return [self initWithIndexesForFieldNames:nil inDatastore:nil];
}

- (id)initWithIndexesForFieldNames:(NSSet *)fieldnames
                       inDatastore:(CDTDatastore *)datastore;

{
    self = [super init];
    if (self)
    {
        if (!datastore || !fieldnames || ([fieldnames count] == 0))
        {
            self = nil;
        }
        else
        {
            _indexManager = [IAWCloudantSyncIndexManager indexManagerForDatastore:datastore
                                                         withIndexesForFieldnames:fieldnames];
        }
    }
    
    return self;
}


#pragma mark - IAWPersistenceDatastoreIndexManagerProtocol methods
- (id<NSFastEnumeration>)queryWithDictionary:(NSDictionary *)dictionary
                                       error:(NSError **)error
{
    // CDTDocumentRevisions returned conforms to IAWPersistenceDatastoreDocumentProtocol
    // thanks to category CDTDocumentRevision+IAWPersistenceDatastoreDocumentProtocol
    
    return [self.indexManager queryWithDictionary:dictionary error:error];
}


#pragma mark - Public class methods
+ (instancetype)indexManagerWithIndexesForFieldNames:(NSSet *)fieldnames
                                         inDatastore:(CDTDatastore *)datastore
{
    return [[[self class] alloc] initWithIndexesForFieldNames:fieldnames inDatastore:datastore];
}


#pragma mark - Private class methods
+ (CDTIndexManager *)indexManagerForDatastore:(CDTDatastore *)datastore
                     withIndexesForFieldnames:(NSSet *)fieldnames
{
    NSError *error = nil;
    CDTIndexManager *indexManager = [[CDTIndexManager alloc] initWithDatastore:datastore
                                                                         error:&error];
    NSAssert(indexManager, @"Index Manager not created: %@", error);
    
    for (NSString *oneFieldname in fieldnames)
    {
        NSAssert([indexManager ensureIndexedWithIndexName:oneFieldname fieldName:oneFieldname error:&error],
                 @"Index %@ not created: %@", oneFieldname, error);
    }
    
    return indexManager;
}

@end
