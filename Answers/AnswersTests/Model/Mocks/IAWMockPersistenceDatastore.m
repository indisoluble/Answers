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
@property (strong, nonatomic) NSDictionary *dictionaryForCreatedDocument;

@property (assign, nonatomic) BOOL didReplaceDocument;
@property (strong, nonatomic) NSDictionary *dictionaryForReplacedDocument;

@property (assign, nonatomic) BOOL didDeleteDocument;

@property (assign, nonatomic) BOOL didRefreshDocuments;

@end



@implementation IAWMockPersistenceDatastore

#pragma mark - Init object
- (id)init
{
    self = [super init];
    if (self)
    {
        _didCreateDocument = NO;
        _didReplaceDocument = NO;
        _didDeleteDocument = NO;
        _didRefreshDocuments = NO;
        
        _resultReplaceDocument = nil;
        _resultReplaceDocumentError = nil;
        
        _resultCreateDocument = nil;
        _resultCreateDocumentError = nil;
        
        _resultDeleteDocument = NO;
        _resultDeleteDocumentError = nil;
    }
    
    return self;
}

#pragma mark - IAWPersistenceDatastoreProtocol methods
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    self.didCreateDocument = YES;
    
    self.dictionaryForCreatedDocument = dictionary;
    
    if (!self.resultCreateDocument && error)
    {
        *error = self.resultCreateDocumentError;
    }
    
    return self.resultCreateDocument;
}

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error;
{
    self.didReplaceDocument = YES;
    
    self.dictionaryForReplacedDocument = dictionary;
    
    if (!self.resultReplaceDocument && error)
    {
        *error = self.resultReplaceDocumentError;
    }
    
    return self.resultReplaceDocument;
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

@end
