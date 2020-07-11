//
//  NSObject+CodableProperties.m
//  Weather_App
//
//  Created by user1 on 2017/10/19.
//  Copyright © 2017年 Yrocky. All rights reserved.
//

#import "NSObject+CodableProperties.h"
#import <objc/runtime.h>

@implementation NSObject (CodableProperties)

+ (NSDictionary *)codablePropertiesForClass
{
    unsigned int propertyCount;
    __autoreleasing NSMutableDictionary *codableProperties = [NSMutableDictionary dictionary];
    objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        //get property name
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        __autoreleasing NSString *key = @(propertyName);
        
        //get property type
        Class propertyClass = nil;
        char *typeEncoding = property_copyAttributeValue(property, "T");
        switch (typeEncoding[0])
        {
            case '@':
            {
                if (strlen(typeEncoding) >= 3)
                {
                    char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                    __autoreleasing NSString *name = @(className);
                    NSRange range = [name rangeOfString:@"<"];
                    if (range.location != NSNotFound)
                    {
                        name = [name substringToIndex:range.location];
                    }
                    propertyClass = NSClassFromString(name) ?: [NSObject class];
                    free(className);
                }
                break;
            }
            case 'c':
            case 'i':
            case 's':
            case 'l':
            case 'q':
            case 'C':
            case 'I':
            case 'S':
            case 'L':
            case 'Q':
            case 'f':
            case 'd':
            case 'B':
            {
                propertyClass = [NSNumber class];
                break;
            }
            case '{':
            {
                propertyClass = [NSValue class];
                break;
            }
        }
        free(typeEncoding);
        
        if (propertyClass)
        {
            //check if there is a backing ivar
            char *ivar = property_copyAttributeValue(property, "V");
            if (ivar)
            {
                //check if ivar has KVC-compliant name
                __autoreleasing NSString *ivarName = @(ivar);
                if ([ivarName isEqualToString:key] || [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                {
                    //no setter, but setValue:forKey: will still work
                    codableProperties[key] = propertyClass;
                }
                free(ivar);
            }
            else
            {
                //check if property is dynamic and readwrite
                char *dynamic = property_copyAttributeValue(property, "D");
                char *readonly = property_copyAttributeValue(property, "R");
                if (dynamic && !readonly)
                {
                    //no ivar, but setValue:forKey: will still work
                    codableProperties[key] = propertyClass;
                }
                free(dynamic);
                free(readonly);
            }
        }
    }
    
    free(properties);
    return codableProperties;
}

- (NSDictionary *)codableProperties
{
    __autoreleasing NSDictionary *codableProperties = objc_getAssociatedObject([self class], _cmd);
    if (!codableProperties)
    {
        codableProperties = [NSMutableDictionary dictionary];
        Class subclass = [self class];
        while (subclass != [NSObject class])
        {
            [(NSMutableDictionary *)codableProperties addEntriesFromDictionary:[subclass codablePropertiesForClass]];
            subclass = [subclass superclass];
        }
        codableProperties = [NSDictionary dictionaryWithDictionary:codableProperties];
        
        //make the association atomically so that we don't need to bother with an @synchronize
        objc_setAssociatedObject([self class], _cmd, codableProperties, OBJC_ASSOCIATION_RETAIN);
    }
    return codableProperties;
}

@end


@implementation NSObject (DebugTagName)

- (void)setDebugTagName:(NSString *)debugTagName{
    objc_setAssociatedObject([self class], _cmd, debugTagName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)debugTagName{
    return objc_getAssociatedObject([self class], @selector(setDebugTagName:));
}

- (NSString *) objectIdentifier{
    return [NSString stringWithFormat:@"%@:0x%0x",self.class.description ,(int)self];
}
@end

@implementation NSObject (MMRuntime)

+ (NSArray<NSString *> *)mm_getAllProperties{
    
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++){
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    // You must free the array with free().
    free(properties);
    
    return propertiesArray;
}

- (NSArray<NSString *> *)mm_getAllProperties{
    return [[self class] mm_getAllProperties];
}

+ (NSArray<NSString *> *) mm_getAllMethods{
    
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList([self class],&methodCount);
    NSMutableArray *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i = 0 ; i < methodCount ; i++) {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        int arguments = method_getNumberOfArguments(temp);
        const char* encoding =method_getTypeEncoding(temp);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
        [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
    }
    free(methodList);
    return methodsArray;
}

- (NSArray<NSString *> *) mm_getAllMethods{
    return [[self class] mm_getAllMethods];
}

+ (BOOL) mm_implementationMethod:(SEL)method{
    NSString * methodName = NSStringFromSelector(method);
    return [self mm_implementationMethodWith:methodName];
}
- (BOOL) mm_implementationMethod:(SEL)method{
    return [[self class] mm_implementationMethod:method];
}

+ (BOOL) mm_implementationMethodWith:(NSString *)methodName{
    return [[self mm_getAllMethods] containsObject:methodName];
}
- (BOOL) mm_implementationMethodWith:(NSString *)methodName{
    return [[self class] mm_implementationMethodWith:methodName];
}
@end
