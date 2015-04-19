//
//  CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 10/02/2015.
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

#import <CloudantSync.h>

#import "CDTDatastore+IAWPersistenceDatastoreLocalStorageProtocol.h"

#import "CDTDocumentRevision+IAWPersistenceDatastoreDocumentProtocol.h"



@implementation CDTDatastore (IAWPersistenceDatastoreLocalStorageProtocol)

#pragma mark - IAWPersistenceDatastoreLocalStorageProtocol methods
- (id<IAWPersistenceDatastoreDocumentProtocol>)createDocumentWithDictionary:(NSDictionary *)dictionary
                                                                      error:(NSError **)error
{
    CDTMutableDocumentRevision *revision = [CDTMutableDocumentRevision revision];
    revision.body = dictionary;
    
    CDTDocumentRevision *nextRevision = [self createDocumentFromRevision:revision error:error];
    
    return nextRevision;
}

- (id<IAWPersistenceDatastoreDocumentProtocol>)replaceDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                                                withDictionary:(NSDictionary *)dictionary
                                                         error:(NSError **)error
{
    NSAssert([document isKindOfClass:[CDTDocumentRevision class]], @"Unexpected class");
    
    CDTDocumentRevision *revision = (CDTDocumentRevision *)document;
    
    CDTMutableDocumentRevision *update = [revision mutableCopy];
    update.body = dictionary;
    
    CDTDocumentRevision *nextRevision = [self updateDocumentFromRevision:update error:error];
    
    return nextRevision;
}

- (BOOL)deleteDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
                 error:(NSError **)error
{
    NSAssert([document isKindOfClass:[CDTDocumentRevision class]], @"Unexpected class");
    
    CDTDocumentRevision *revision = (CDTDocumentRevision *)document;
    CDTDocumentRevision *nextRevision = [self deleteDocumentFromRevision:revision error:error];
    
    return (nextRevision != nil);
}

- (IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType)deleteDocumentList:(NSArray *)documents
                                                                                  error:(NSError **)error
{
    NSUInteger deletionCount = 0;
    
    for (id<IAWPersistenceDatastoreDocumentProtocol> oneDocument in documents)
    {
        if ([self deleteDocument:oneDocument error:error])
        {
            deletionCount++;
        }
        else
        {
            break;
        }
    }
    
    IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType result = IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_success;
    if (deletionCount != [documents count])
    {
        result = (deletionCount == 0 ?
                  IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_noDocumentDeleted :
                  IAWPersistenceDatastoreLocalStorage_deleteDocumentList_resultType_someDocumentsDeleted);
    }
    
    return result;
}

@end
