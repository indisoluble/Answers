//
//  IAWModelObject.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 12/02/2015.
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

#import <Foundation/Foundation.h>

#import "IAWPersistence.h"



extern NSString * const kIAWModelObjectKeyType;



@interface IAWModelObject : NSObject

@property (strong, nonatomic, readonly) id<IAWPersistenceDatastoreDocumentProtocol> document;

- (id)initWithDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document;

+ (instancetype)objectWithDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document;

+ (instancetype)createObjectWithType:(NSString *)type
                                data:(NSDictionary *)data
                         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                               error:(NSError **)error;

+ (instancetype)replaceObject:(IAWModelObject *)object
                    usingData:(NSDictionary *)data
                  inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                        error:(NSError **)error;

+ (NSSet *)indexableFieldnames;

+ (id<NSFastEnumeration>)allObjectsWithType:(NSString *)type
                             inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager;
+ (id<NSFastEnumeration>)allObjectsWithType:(NSString *)type
                                       data:(NSDictionary *)data
                             inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager;

@end
