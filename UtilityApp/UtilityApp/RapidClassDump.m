//
//  RapidClassDump.m
//  UtilityApp
//
//  Created by Radha on 11/11/16.
//  Copyright © 2016 iBase. All rights reserved.
//

#import "RapidClassDump.h"
#import <objc/runtime.h>

@implementation RapidClassDump

#pragma mark- Classes and Methods Dump
- (void)dumpAllClassesAndMethods
{
    NSLog(@"dumpAllClassesAndMethods called");
    
    //getting Class Names
    NSArray* classNames = [self getAllClasses];
    NSLog(@"Class Names Dump : %@",classNames);
    
    for (NSString *clsname in classNames)
    {
        NSLog(@"*******Method Names For %@****** \n\n\n",clsname);
        
        // Call for instance methods
        Class class = [NSClassFromString(clsname) class];
        if(class == NULL | class == nil | class== Nil)
            continue;
        NSLog(@"Instance Methods Dump : %@",[self getMethodsForClass:class]);
        
        // Call for class methods
        Class class1 = object_getClass(class);
        if(class1 == NULL | class1 == nil | class1== Nil)
            continue;
        NSLog(@"class Methods Dump : %@",[self getMethodsForClass:class1]);
        
        NSLog(@"*************************");
    }
}

- (NSArray*)getAllClasses
{
    NSLog(@"getAllClasses called");
    
    NSMutableArray *classeNames = [[NSMutableArray alloc] init];
    
    //Class *classes = objc_copyClassList( &numClasses);
    // QXDebugLog(@"objc_getClassList : %d",numClasses);
    //numClasses = sizeof(classes)/sizeof(Class);
    //QXDebugLog(@"class objs count : %lu",sizeof(classes));
    
    
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (__unsafe_unretained Class *) malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    for (int i = 0; i < numClasses; i++)
    {
        NSLog(@"Current Index %d",i);
        
        Class c = classes[i];
        if(c == NULL | c == nil | c== Nil)
            continue;
        
        NSBundle *b = [NSBundle bundleForClass:c];
        if (b == [NSBundle mainBundle])
        {
            const char* tempClass = class_getName(c);
            if(!tempClass)
                continue;
            NSString *name = [NSString stringWithFormat:@"%s", tempClass];
            NSLog(@"Class Name : %@",name);
            if(!name) continue;
            // NSString *name = [NSString stringWithUTF8String:class_getName(c)];
            //QXDebugLog(@"Class Name : %s", class_getName(c));
            [classeNames addObject:name];
        }
    }
    free(classes);
    return [classeNames copy];
}


- (NSMutableArray *)getMethodsForClass:(Class)clz
{
    NSLog(@"getMethodsForClass");
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(clz, &methodCount);
    NSMutableArray *listArray = [NSMutableArray new];
    // NSLog(@"Methods count = %d\n", methodCount);
    for (int i = 0; i < methodCount; i++) {
        if(methods[i] == NULL | methods[i] == nil | methods[i]== Nil)
            continue;
        NSString *methodName = NSStringFromSelector(method_getName(methods[i]));
        if(methodName)
            [listArray addObject:methodName];
    }
    free(methods);
    
    return listArray;
}

@end
