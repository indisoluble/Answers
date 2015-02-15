//
//  IAWModelObject+ErrorBuilder.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 15/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelObject.h"



typedef enum {
    IAWModelObject_erroCodeType_objectTypeNotValid = 0,
    IAWModelObject_erroCodeType_noDataProvided,
    IAWModelObject_erroCodeType_dataNotValid
} IAWModelObject_erroCodeType;



extern NSString * const kIAWModelObjectErrorDomain;



@interface IAWModelObject (ErrorBuilder)

+ (NSError *)errorObjectTypeNotValid;
+ (NSError *)errorNoDataProvided;
+ (NSError *)errorDataNotValid;

@end
