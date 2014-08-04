//
//  Tools.h
//  Translation
//
//  Created by monst on 13-12-16.
//  Copyright (c) 2013年 monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(custom)
{
    
}
- (BOOL)containtObject:(id)obj;
@end

@implementation NSString(custom)

- (BOOL)containtObject:(id)theObj
{
    for (NSInteger i = 0; i < self.length; i++)
    {
        id obj = [self substringWithRange:NSMakeRange(i, 1)];
        
        if ([theObj isEqual:obj])
        {
            return YES;
        }
    }
    return NO;
}
@end

