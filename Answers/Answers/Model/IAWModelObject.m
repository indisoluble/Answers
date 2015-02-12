//
//  IAWModelObject.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 12/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelObject.h"



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

@end
