//
//  IAWPersistenceDatastore+IAWModel.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWPersistenceDatastore+IAWModel.h"

#import "IAWPersistence.h"

#import "IAWModelObject.h"



@implementation IAWPersistenceDatastore (IAWModel)

#pragma mark - Public class methods
+ (instancetype)datastore
{
    NSSet *fieldnames = [IAWModelObject indexableFieldnames];
    
    return [IAWPersistenceDatastore datastoreWithIndexesForFieldnames:fieldnames];
}

@end
