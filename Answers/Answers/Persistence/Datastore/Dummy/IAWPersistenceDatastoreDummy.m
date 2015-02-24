//
//  IAWPersistenceDatastoreDummy.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 24/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastoreDummy.h"



NSString * const kIAWPersistenceDatastoreDummyErrorDomain = @"kIAWPersistenceDatastoreDummyErrorDomain";
NSInteger const kIAWPersistenceDatastoreDummyErrorCode = 1;



@interface IAWPersistenceDatastoreDummy ()

@end



@implementation IAWPersistenceDatastoreDummy

#pragma mark - IAWPersistenceDatastoreProtocol methods
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    if (error)
    {
        *error = [IAWPersistenceDatastoreDummy dummyError];
    }
    
    return nil;
}

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error
{
    if (error)
    {
        *error = [IAWPersistenceDatastoreDummy dummyError];
    }
    
    return nil;
}

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error
{
    if (error)
    {
        *error = [IAWPersistenceDatastoreDummy dummyError];
    }
    
    return NO;
}

- (void)refreshDocuments
{
    // Do nothing
}


#pragma mark - Public class methods
+ (instancetype)datastore
{
    return [[[self class] alloc] init];
}


#pragma mark - Private class methods
+ (NSError *)dummyError
{
    return [NSError errorWithDomain:kIAWPersistenceDatastoreDummyErrorDomain
                               code:kIAWPersistenceDatastoreDummyErrorCode
                           userInfo:nil];
}

@end
