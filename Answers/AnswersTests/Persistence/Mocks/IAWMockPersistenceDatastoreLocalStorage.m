//
//  IAWMockPersistenceDatastoreLocalStorage.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 19/04/2015.
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

#import "IAWMockPersistenceDatastoreLocalStorage.h"



@interface IAWMockPersistenceDatastoreLocalStorage ()

@end



@implementation IAWMockPersistenceDatastoreLocalStorage

#pragma mark - IAWPersistenceDatastoreLocalStorageProtocol methods
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    if (!self.resultCreateDocument && error)
    {
        *error = self.resultCreateDocumentError;
    }
    
    return self.resultCreateDocument;
}

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error
{
    if (!self.resultReplaceDocument && error)
    {
        *error = self.resultReplaceDocumentError;
    }
    
    return self.resultReplaceDocument;
}

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error
{
    if (!self.resultDeleteDocument && error)
    {
        *error = self.resultDeleteDocumentError;
    }
    
    return self.resultDeleteDocument;
}

- (IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType)deleteDocumentList:(NSArray *)documents
                                                                                  error:(NSError **)error
{
    if ((self.resultDeleteDocumentList != IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_success) &&
        error)
    {
        *error = self.resultDeleteDocumentListError;
    }
    
    return self.resultDeleteDocumentList;
}

@end
