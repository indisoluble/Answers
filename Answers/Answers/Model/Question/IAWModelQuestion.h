//
//  IAWModelQuestion.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAWModelObject.h"



@interface IAWModelQuestion : IAWModelObject

@property (strong, nonatomic, readonly) NSString *questionText;

+ (NSDictionary *)dictionaryWithQuestionText:(NSString *)text;

@end
