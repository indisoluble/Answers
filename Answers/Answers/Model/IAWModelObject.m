//
//  IAWModelObject.m
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

#import "IAWModelObject.h"

#import "IAWModelObject+ErrorBuilder.h"

#import "IAWLog.h"



NSString * const kIAWModelObjectKeyType = @"object_type";



@interface IAWModelObject ()

@property (strong, nonatomic, readonly) NSString *objectType;

@end



@implementation IAWModelObject

#pragma mark - Synthesize properties
- (NSString *)objectType
{
    NSDictionary *dic = [self.document dictionary];
    
    return dic[kIAWModelObjectKeyType];
}


#pragma mark - Init object
- (id)init
{
    return [self initWithDocument:nil];
}

- (id)initWithDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
{
    self = [super init];
    if (self)
    {
        if (!document)
        {
            self = nil;
        }
        else
        {
            _document = document;
        }
    }
    
    return self;
}


#pragma mark - Public class methods
+ (instancetype)objectWithDocument:(id<IAWPersistenceDatastoreDocumentProtocol>)document
{
    return [[[self class] alloc] initWithDocument:document];
}

+ (instancetype)createObjectWithType:(NSString *)type
                                data:(NSDictionary *)data
                         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                               error:(NSError **)error
{
    NSDictionary *dictionary = [IAWModelObject dictionaryWithObjectType:type
                                                                   data:data
                                                                  error:error];
    if (!dictionary)
    {
        return nil;
    }
    
    id<IAWPersistenceDatastoreDocumentProtocol> document = [datastore createDocumentWithDictionary:dictionary
                                                                                             error:error];
    if (!document)
    {
        return nil;
    }
    
    return [[[self class] alloc] initWithDocument:document];
}

+ (instancetype)replaceObject:(IAWModelObject *)object
                    usingData:(NSDictionary *)data
                  inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                        error:(NSError **)error
{
    NSDictionary *dictionary = [IAWModelObject dictionaryWithObjectType:object.objectType
                                                                   data:data
                                                                  error:error];
    if (!dictionary)
    {
        return nil;
    }
    
    id<IAWPersistenceDatastoreDocumentProtocol> document = [datastore replaceDocument:object.document
                                                                       withDictionary:dictionary
                                                                                error:error];
    if (!document)
    {
        return nil;
    }
    
    return [[[self class] alloc] initWithDocument:document];
}

+ (BOOL)deleteObject:(IAWModelObject *)object
         inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
               error:(NSError **)error
{
    if (!object)
    {
        IAWLogError(@"Object not informed. Abort");
        
        return NO;
    }
    
    return [datastore deleteDocument:object.document error:error];
}

+ (IAWModelObject_deleteObjectList_resultType)deleteObjectList:(NSArray *)objects
                                                   inDatastore:(id<IAWPersistenceDatastoreProtocol>)datastore
                                                         error:(NSError **)error
{
    if (!objects)
    {
        IAWLogError(@"List not informed. Abort");
        
        return IAWModelObject_deleteObjectList_resultType_noObjectDeleted;
    }
    
    NSMutableArray *documents = [NSMutableArray arrayWithCapacity:[objects count]];
    for (IAWModelObject *oneObject in objects)
    {
        [documents addObject:oneObject.document];
    }
    
    IAWModelObject_deleteObjectList_resultType result = IAWModelObject_deleteObjectList_resultType_noObjectDeleted;
    switch ([datastore deleteDocumentList:documents error:error])
    {
        case IAWPersistenceDatastore_deleteDocumentList_resultType_success:
        {
            result = IAWModelObject_deleteObjectList_resultType_success;
            
            break;
        }
        case IAWPersistenceDatastore_deleteDocumentList_resultType_someDocumentsDeleted:
        {
            result = IAWModelObject_deleteObjectList_resultType_someObjectsDeleted;
            
            break;
        }
        case IAWPersistenceDatastore_deleteDocumentList_resultType_noDocumentDeleted:
        default:
        {
            result = IAWModelObject_deleteObjectList_resultType_noObjectDeleted;
            
            break;
        }
    }
    
    return result;
}

+ (NSSet *)indexableFieldnames
{
    return [NSSet setWithObject:kIAWModelObjectKeyType];
}

+ (id<NSFastEnumeration>)allObjectsWithType:(NSString *)type
                             inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    NSDictionary *dictionaryOrNil = [IAWModelObject dictionaryWithObjectType:type];
    if (!dictionaryOrNil)
    {
        IAWLogError(@"Type <%@> is not valid", type);
        
        return nil;
    }
    
    NSError *error = nil;
    id<NSFastEnumeration> result = [indexManager queryWithDictionary:dictionaryOrNil error:&error];
    if (!result)
    {
        IAWLogError(@"No objects retrived with dictionary %@: %@", dictionaryOrNil, error);
    }
    
    return result;
}

+ (id<NSFastEnumeration>)allObjectsWithType:(NSString *)type
                                       data:(NSDictionary *)data
                             inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    NSDictionary *dictionaryOrNil = [IAWModelObject dictionaryWithObjectType:type
                                                                        data:data
                                                                       error:nil];
    if (!dictionaryOrNil)
    {
        IAWLogError(@"Type <%@> is not valid", type);
        
        return nil;
    }
    
    NSError *error = nil;
    id<NSFastEnumeration> result = [indexManager queryWithDictionary:dictionaryOrNil error:&error];
    if (!result)
    {
        IAWLogError(@"No objects retrived with dictionary %@: %@", dictionaryOrNil, error);
    }
    
    return result;
}

+ (NSUInteger)countObjectsWithType:(NSString *)type
                              data:(NSDictionary *)data
                    inIndexManager:(id<IAWPersistenceDatastoreIndexManagerProtocol>)indexManager
{
    id<NSFastEnumeration> allObjectsOrNil = [IAWModelObject allObjectsWithType:type
                                                                          data:data
                                                                inIndexManager:indexManager];
    if (!allObjectsOrNil)
    {
        return 0;
    }
    
    NSUInteger counter = 0;
    for (__unused id oneObject in allObjectsOrNil)
    {
        counter++;
    }
    
    return counter;
}


#pragma mark - Private class methods
+ (NSDictionary *)dictionaryWithObjectType:(NSString *)type
                                      data:(NSDictionary *)data
                                     error:(NSError **)error
{
    if (!data)
    {
        if (error)
        {
            *error = [IAWModelObject errorNoDataProvided];
        }
        
        return nil;
    }
    
    if ([data objectForKey:kIAWModelObjectKeyType])
    {
        if (error)
        {
            *error = [IAWModelObject errorDataNotValid];
        }
        
        return nil;
    }
    
    NSMutableDictionary *dictionary = [IAWModelObject dictionaryWithObjectType:type];
    if (!dictionary)
    {
        if (error)
        {
            *error = [IAWModelObject errorObjectTypeNotValid];
        }
        
        return nil;
    }
    
    [dictionary addEntriesFromDictionary:data];
    
    return dictionary;
}

+ (NSMutableDictionary *)dictionaryWithObjectType:(NSString *)type
{
    NSString *normalizedType = [IAWModelObject normalizeType:type];
    if (!normalizedType)
    {
        return nil;
    }
    
    return [NSMutableDictionary dictionaryWithObject:normalizedType forKey:kIAWModelObjectKeyType];
}

+ (NSString *)normalizeType:(NSString *)type
{
    NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedTypeOrNil = (type ? [type stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] : nil);
    
    return (trimmedTypeOrNil && ([trimmedTypeOrNil length] > 0) ? trimmedTypeOrNil : nil);
}

@end
