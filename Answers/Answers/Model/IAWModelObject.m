//
//  IAWModelObject.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 12/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelObject.h"

#import "IAWModelObject+ErrorBuilder.h"



NSString * const kIAWModelObjectKeyType = @"type";



@interface IAWModelObject ()

@end



@implementation IAWModelObject

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
    
    id<IAWPersistenceDatastoreDocumentProtocol> document = [datastore createDocumentWithDictionary:dictionary
                                                                                             error:error];
    if (!document)
    {
        return nil;
    }
    
    return [[[self class] alloc] initWithDocument:document];
}


#pragma mark - Private class methods
+ (NSMutableDictionary *)dictionaryWithObjectType:(NSString *)type
{
    NSCharacterSet *whiteSpacesAndNewLines = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedTypeOrNil = (type ? [type stringByTrimmingCharactersInSet:whiteSpacesAndNewLines] : nil);
    
    NSMutableDictionary *dictionary = nil;
    if (trimmedTypeOrNil && ([trimmedTypeOrNil length] > 0))
    {
        dictionary = [NSMutableDictionary dictionaryWithObject:trimmedTypeOrNil
                                                        forKey:kIAWModelObjectKeyType];
    }
    
    return dictionary;
}

@end
