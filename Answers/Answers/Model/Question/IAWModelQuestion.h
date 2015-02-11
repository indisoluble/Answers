//
//  IAWModelQuestion.h
//  Answers
//
//  Created by Enrique de la Torre (dev) on 01/02/2015.
//  Copyright (c) 2015 Enrique de la Torre. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface IAWModelQuestion : NSObject

@property (strong, nonatomic, readonly) NSString *questionText;

- (id)initWithQuestionText:(NSString *)text;

@end
