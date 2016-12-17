//
//  Note.m
//  dox
//
//  Created by Ray Wenderlich on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize noteContent;
@synthesize noteDataContent;

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    
    if ([contents length] > 0) 
    {
        self.noteContent = [[NSString alloc] initWithBytes:[contents bytes] 
                                                    length:[contents length] 
                                                  encoding:NSUTF8StringEncoding];
        
        
        self.noteDataContent = [[NSData alloc] initWithBytes:[contents bytes] length:[contents length]];
    
    } 
    else 
    {
        self.noteContent = @"Empty"; // When the note is created we assign some default content
    }

    //NSLog(@"\n self.noteDataContent = %@",self.noteDataContent);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" 
                                                        object:self];        
    
    return YES;
    
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError 
{
    
    if ([self.noteDataContent length] == 0) 
    {
        
        //self.noteDataContent = [NSData data]
        //self.noteContent = @"Empty";
    }

    return self.noteDataContent;
           

    
    /*
    return [NSData dataWithBytes:[self.noteContent UTF8String] 
                          length:[self.noteContent length]];
    */ 
    
}

@end
