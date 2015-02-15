//
//  IAWMockPersistenceDatastore.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 14/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWMockPersistenceDatastore.h"



@interface IAWMockPersistenceDatastore ()

@property (assign, nonatomic) BOOL didCreateDocument;
@property (strong, nonatomic) NSDictionary *dictionaryForDocument;

@property (assign, nonatomic) BOOL didDeleteDocument;

@property (assign, nonatomic) BOOL didRefreshDocuments;

@property (assign, nonatomic) BOOL didGetAllDocuments;

@end



@implementation IAWMockPersistenceDatastore

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if (self)
    {
        _didCreateDocument = NO;
        _didDeleteDocument = NO;
        _didRefreshDocuments = NO;
        _didGetAllDocuments = NO;
        
        _resultCreateDocument = nil;
        _resultCreateDocumentError = nil;
        
        _resultDeleteDocument = NO;
        _resultDeleteDocumentError = nil;
        
        _resultGetAllDocuments = nil;
    }
    
    return self;
}

#pragma mark - IAWPersistenceDatastoreProtocol methods
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    self.didCreateDocument = YES;
    
    self.dictionaryForDocument = dictionary;
    
    if (!self.resultCreateDocument && error)
    {
        *error = self.resultCreateDocumentError;
    }
    
    return self.resultCreateDocument;
}

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error
{
    self.didDeleteDocument = YES;
    
    if (!self.resultDeleteDocument && error)
    {
        *error = self.resultDeleteDocumentError;
    }
    
    return self.resultDeleteDocument;
}

- (void)refreshDocuments
{
    self.didRefreshDocuments = YES;
}

- (NSArray *)allDocuments
{
    self.didGetAllDocuments = YES;
    
    return self.resultGetAllDocuments;
}

@end
