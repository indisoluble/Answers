//
//  IAWModelQuestion+NSDictionary.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 11/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import "IAWModelQuestion.h"



@interface IAWModelQuestion (NSDictionary)

- (NSDictionary *)dictionary;

+ (instancetype)questionWithDictionary:(NSDictionary *)dictionary;

@end
