//
//  IAWModelObject+ErrorBuilder.m
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelObject+ErrorBuilder.h"



NSString * const kIAWModelObjectErrorDomain = @"kIAWModelObjectErrorDomain";



@implementation IAWModelObject (ErrorBuilder)

#pragma mark - Public class methods
+ (NSError *)errorObjectTypeNotValid
{
    return [NSError errorWithDomain:kIAWModelObjectErrorDomain
                               code:IAWModelObject_erroCodeType_objectTypeNotValid
                           userInfo:nil];
}

+ (NSError *)errorNoDataProvided
{
    return [NSError errorWithDomain:kIAWModelObjectErrorDomain
                               code:IAWModelObject_erroCodeType_noDataProvided
                           userInfo:nil];
}

+ (NSError *)errorDataNotValid
{
    return [NSError errorWithDomain:kIAWModelObjectErrorDomain
                               code:IAWModelObject_erroCodeType_dataNotValid
                           userInfo:nil];
}

@end
