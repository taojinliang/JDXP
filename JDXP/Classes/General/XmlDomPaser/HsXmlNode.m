//
//  HsXmlNode.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/7/28.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "HsXmlNode.h"
#import "HsXmlDomPaser.h"
#import "NSStringAdditions.h"

@implementation HsXmlNode

@synthesize tagName;
@synthesize tagValue;

@synthesize nodeType;
@synthesize nodeParent;

@synthesize errorInfo;

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@=%@", tagName, tagValue];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tagName = @"";
        tagValue = nil;
        nodeType = HsXmlNodeTypeUnkonw;
        self.nodeParent = nil;
        dicNodes = [NSMutableDictionary dictionaryWithCapacity:10] ;
        dicElements = [NSMutableDictionary dictionaryWithCapacity:10] ;
        dicAttributes = [NSMutableDictionary dictionaryWithCapacity:10] ;
        dicTexts = [NSMutableDictionary dictionaryWithCapacity:10] ;
        
        listNodes = [NSMutableArray arrayWithCapacity:10] ;
        listElements = [NSMutableArray arrayWithCapacity:10] ;
        listAttributes = [NSMutableArray arrayWithCapacity:10] ;
        listTexts = [NSMutableArray arrayWithCapacity:10] ;
        
        self.errorInfo = [NSException exceptionWithName:@"No Occur Exception"
                                                 reason:@"finish init without any operation"
                                               userInfo:nil];
    }
    return self;
}

- (id)initAttributeWithName:(NSString *)name WithValue:(NSString *)value
{
    self = [self init];
    if (self)
    {
        self.tagName = name;
        tagValue = [NSString stringWithString:value] ;
        nodeType = HsXmlNodeTypeAttribute;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name WithType:(HsXmlNodeType)type
{
    self = [self init];
    if (self)
    {
        self.tagName = name;
        nodeType = type;
    }
    
    return self;
}



- (NSString *)tagValue
{
    if (self.nodeType != HsXmlNodeTypeAttribute)
    {
        return nil;
    }
    
    return tagValue;
}

#pragma mark -
#pragma mark deal with node function
- (BOOL)removeNodeWithName:(NSString *)nodeName WithType:(HsXmlNodeType)type FirstMatch:(BOOL)bFirstMatch
{
    if ([dicNodes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:@"there is nothing to remove"
                                               userInfo:nil];
        return NO;
    }
    
    if ([nodeName length] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:@"the removed node without a clear name"
                                               userInfo:nil];
        return NO;
    }
    
    NSMutableArray *couldRemoveList= [[NSMutableArray alloc] initWithCapacity:5] ;
    NSMutableArray *couldRemoveKeyList= [[NSMutableArray alloc] initWithCapacity:5] ;
    BOOL bFirstOne = YES;
    @try
    {
        NSString *tempName = nil;
        HsXmlNode *removedNode = nil;
        int	munAppend = 1;
        
        if (type == HsXmlNodeTypeUnkonw)
        {
            for (int i = 0; i < 3; i ++)
            {
                switch (i)
                {
                    case 0:
                        tempName = [nodeName stringByAppendingString:@"_elmt"];
                        break;
                    case 1:
                        tempName = [nodeName stringByAppendingString:@"_attr"];
                        break;
                    case 2:
                        tempName = [nodeName stringByAppendingString:@"_txt"];
                        break;
                    default:
                        tempName = [nodeName stringByAppendingString:@"_txt"];
                        break;
                }
                
                removedNode = [dicNodes valueForKey:tempName];
                if (removedNode != nil)
                {
                    [couldRemoveList addObject:removedNode];
                    [couldRemoveKeyList addObject:tempName];
                }
                else
                    break;
                
                munAppend = 1;
                while (YES)
                {
                    tempName = [tempName stringByAppendingFormat:@"_%d",munAppend];
                    removedNode = [dicNodes valueForKey:tempName];
                    if (removedNode != nil)
                    {
                        [couldRemoveList addObject:removedNode];
                        [couldRemoveKeyList addObject:tempName];
                    }
                    else
                    {
                        break;
                    }
                    munAppend++;
                }
            }
        }
        else
        {
            switch (type)
            {
                case HsXmlNodeTypeElement:
                    tempName = [nodeName stringByAppendingString:@"_elmt"];
                    break;
                case HsXmlNodeTypeAttribute:
                    tempName = [nodeName stringByAppendingString:@"_attr"];
                    break;
                case HsXmlNodeTypeText:
                    tempName = [nodeName stringByAppendingString:@"_txt"];
                    break;
                default:
                    tempName = [nodeName stringByAppendingString:@"_txt"];
                    break;
            }
            removedNode = [dicNodes valueForKey:tempName];
            if (removedNode != nil)
            {
                [couldRemoveList addObject:removedNode];
                [couldRemoveKeyList addObject:tempName];
            }
            
            munAppend = 1;
            while (YES)
            {
                tempName = [tempName stringByAppendingFormat:@"_%d",munAppend];
                removedNode = [dicNodes valueForKey:tempName];
                if (removedNode != nil)
                {
                    [couldRemoveList addObject:removedNode];
                    [couldRemoveKeyList addObject:tempName];
                }
                else
                {
                    break;
                }
                munAppend++;
            }
        }
        
        if ([couldRemoveList count] == 0)
        {
            self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                     reason:[NSString stringWithFormat:@"could not found such a node to remove with name [%@] type [%d]",nodeName,type]
                                                   userInfo:nil];
            return NO;
        }
        
        int removeIndex = 0;
        for (removedNode in couldRemoveList)
        {
            tempName = (NSString *)[couldRemoveKeyList objectAtIndex:removeIndex];
            switch (removedNode.nodeType)
            {
                case HsXmlNodeTypeElement:
                    [dicNodes setValue:nil forKey:tempName];
                    [dicElements setValue:nil forKey:tempName];
                    [listNodes removeObject:removedNode];
                    [listElements removeObject:removedNode];
                    break;
                case HsXmlNodeTypeAttribute:
                    [dicNodes setValue:nil forKey:tempName];
                    [dicAttributes setValue:nil forKey:tempName];
                    [listNodes removeObject:removedNode];
                    [listAttributes removeObject:removedNode];
                    break;
                default:
                    [dicNodes setValue:nil forKey:tempName];
                    [dicTexts setValue:nil forKey:tempName];
                    [listNodes removeObject:removedNode];
                    [listTexts removeObject:removedNode];
                    break;
            }
            
            if (bFirstMatch && bFirstOne)
            {
                break;
            }
            bFirstOne = NO;
            removeIndex++;
        }
        
    }
    @catch (NSException * e)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:[NSString stringWithFormat:@"%@,%@",[e name],[e reason]]
                                               userInfo:nil];
        return NO;
    }
    @finally {
        //		[couldRemoveKeyList release];
        //		[couldRemoveList release];
    }
    
    return YES;
}

- (NSArray *)getAllNodeWithName:(NSString *)nodeName WithType:(HsXmlNodeType)type
{
    if ([dicNodes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"there is nothing to get"
                                               userInfo:nil];
        return nil;
    }
    
    if ([nodeName length] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"the wanted node without a clear name"
                                               userInfo:nil];
        return nil;
    }
    
    NSMutableArray *returnList= [[NSMutableArray alloc] initWithCapacity:5] ;
    @try
    {
        NSString *tempName = nil;
        HsXmlNode *tempNode = nil;
        int	munAppend = 1;
        
        if (type == HsXmlNodeTypeUnkonw)
        {
            for (int i = 0; i < 3; i ++)
            {
                switch (i)
                {
                    case 0:
                        tempName = [nodeName stringByAppendingString:@"_elmt"];
                        break;
                    case 1:
                        tempName = [nodeName stringByAppendingString:@"_attr"];
                        break;
                    case 2:
                        tempName = [nodeName stringByAppendingString:@"_txt"];
                        break;
                    default:
                        tempName = [nodeName stringByAppendingString:@"_txt"];
                        break;
                }
                
                tempNode = [dicNodes valueForKey:tempName];
                if (tempNode != nil)
                {
                    [returnList addObject:tempNode];
                }
                else
                    break;
                
                munAppend = 1;
                while (YES)
                {
                    tempName = [tempName stringByAppendingFormat:@"_%d",munAppend];
                    tempNode = [dicNodes valueForKey:tempName];
                    if (tempNode != nil)
                    {
                        [returnList addObject:tempNode];
                    }
                    else
                    {
                        break;
                    }
                    munAppend++;
                }
            }
        }
        else
        {
            switch (type)
            {
                case HsXmlNodeTypeElement:
                    tempName = [nodeName stringByAppendingString:@"_elmt"];
                    break;
                case HsXmlNodeTypeAttribute:
                    tempName = [nodeName stringByAppendingString:@"_attr"];
                    break;
                case HsXmlNodeTypeText:
                    tempName = [nodeName stringByAppendingString:@"_txt"];
                    break;
                default:
                    tempName = [nodeName stringByAppendingString:@"_txt"];
                    break;
            }
            tempNode = [dicNodes valueForKey:tempName];
            if (tempNode != nil)
            {
                [returnList addObject:tempNode];
            }
            
            munAppend = 1;
            while (YES)
            {
                tempName = [tempName stringByAppendingFormat:@"_%d",munAppend];
                tempNode = [dicNodes valueForKey:tempName];
                if (tempNode != nil)
                {
                    [returnList addObject:tempNode];
                }
                else
                {
                    break;
                }
                munAppend++;
            }
        }
        
        if ([returnList count] == 0)
        {
            self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                     reason:[NSString stringWithFormat:@"could not found such a node to remove with name [%@] type [%d]",nodeName,type]
                                                   userInfo:nil];
            return nil;
        }
    }
    @catch (NSException * e)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:[NSString stringWithFormat:@"%@,%@",[e name],[e reason]]
                                               userInfo:nil];
        return nil;
    }
    @finally {
        //[returnList autorelease];
    }
    
    return returnList;
}

- (HsXmlNode *)getNodeWithName:(NSString *)nodeName WithType:(HsXmlNodeType)type
{
    NSArray *array = [self getAllNodeWithName:nodeName WithType:type];
    
    if ([array count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:[NSString stringWithFormat:@"could not found such a node with name [%@]",nodeName]
                                               userInfo:nil];
        return nil;
    }
    HsXmlNode *returnNode = [array objectAtIndex:0];
    
    if (type != HsXmlNodeTypeUnkonw && returnNode.nodeType != type)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:[NSString stringWithFormat:@"the node with name [%@] has a wrong type [%d] which should be [%d]",nodeName,returnNode.nodeType,type]
                                               userInfo:nil];
        return nil;
    }
    return returnNode;
}

- (BOOL)addNode:(HsXmlNode *)node
{
    //不是Element不能加入子节点
    if (nodeType != HsXmlNodeTypeElement)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception"
                                                 reason:@"insert to a node with type not like HsXmlNodeTypeElement"
                                               userInfo:nil];
        return NO;
    }
    
    NSMutableString *tempString = [[NSMutableString alloc]initWithString: node.tagName] ;
    //加入的节点没有名称,不能添加
    if ([tempString length] < 1)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception"
                                                 reason:@"the inserted node without a clear name"
                                               userInfo:nil];
        return NO;
    }
    //类型区分排除同名节点的存储影响
    switch (node.nodeType)
    {
        case HsXmlNodeTypeElement:
            [tempString appendString:@"_elmt"];
            break;
        case HsXmlNodeTypeAttribute:
            [tempString appendString:@"_attr"];
            break;
        default:
            [tempString appendString:@"_txt"];
            break;
    }
    
    @try
    {
        node.nodeParent = self;
        
        int numAppend = 1;
        //排除同名同类型节点造成的存储问题
        while ([dicNodes valueForKey:tempString] != nil)
        {
            [tempString appendFormat:@"_%d",numAppend];
            numAppend++;
        }
        
        switch (node.nodeType)
        {
            case HsXmlNodeTypeElement:
                [dicNodes setValue:node forKey:tempString];
                [dicElements setValue:node forKey:tempString];
                [listNodes addObject:node];
                [listElements addObject:node];
                break;
            case HsXmlNodeTypeAttribute:
                [dicNodes setValue:node forKey:tempString];
                [dicAttributes setValue:node forKey:tempString];
                [listNodes addObject:node];
                [listAttributes addObject:node];
                break;
            default:
                [dicNodes setValue:node forKey:tempString];
                [dicTexts setValue:node forKey:tempString];
                [listNodes addObject:node];
                [listTexts addObject:node];
                break;
        }
    }
    @catch (NSException * e)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception"
                                                 reason:[NSString stringWithFormat:@"%@,%@",[e name],[e reason]]
                                               userInfo:nil];
        return NO;
    }
    //[tempString release];
    return YES;
}

- (BOOL)removeALLNodeWithName:(NSString *)nodeName
{
    return [self removeNodeWithName:nodeName WithType:HsXmlNodeTypeUnkonw FirstMatch:NO];
}

- (BOOL)removeNodeWithName:(NSString *)nodeName
{
    return [self removeNodeWithName:nodeName WithType:HsXmlNodeTypeUnkonw FirstMatch:YES];
}

- (HsXmlNode *)getNodeWithName:(NSString *)nodeName
{
    return [self getNodeWithName:nodeName WithType:HsXmlNodeTypeUnkonw];
}

- (NSArray *)getALLNodes
{
    return [NSArray arrayWithArray:listNodes];
}

#pragma mark -
#pragma mark deal with element node function
- (BOOL)addElementNode:(HsXmlNode *)element
{
    if (element.nodeType != HsXmlNodeTypeElement)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception"
                                                 reason:@"the added element with type not like HsXmlNodeTypeElement"
                                               userInfo:nil];
        return NO;
    }
    
    return [self addNode:element];
}

- (BOOL)removeALLElementWithName:(NSString *)elementName
{
    if ([dicElements count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:@"there is no element to remove"
                                               userInfo:nil];
        return NO;
    }
    
    return [self removeNodeWithName:elementName WithType:HsXmlNodeTypeElement FirstMatch:NO];
}

- (BOOL)removeElementWithName:(NSString *)elementName
{
    if ([dicElements count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:@"there is no element to remove"
                                               userInfo:nil];
        return NO;
    }
    
    return [self removeNodeWithName:elementName WithType:HsXmlNodeTypeElement FirstMatch:YES];
}

- (HsXmlNode *)getElementWithName:(NSString *)elementName
{
    if ([dicElements count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"there is no element to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [self getNodeWithName:elementName WithType:HsXmlNodeTypeElement];
}

- (NSArray *)getAllElementWithName:(NSString *)elementName
{
    if ([dicElements count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"there is no element to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [self getAllNodeWithName:elementName WithType:HsXmlNodeTypeElement];
}

- (NSArray *)getALLElements
{
    if ([dicElements count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"there is no element to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [NSArray arrayWithArray:listElements];
}

#pragma mark -
#pragma mark deal with attribute node function
//input a dictionary,Keys are the names of attributes, and values are attribute values.
- (BOOL)addAttributes:(NSDictionary *)attributeMaps
{
    NSArray *keyArray = [attributeMaps allKeys];
    NSString *tempKey = nil,*tempValue = nil;
    for (tempKey in keyArray)
    {
        tempValue = [attributeMaps valueForKey:tempKey];
        HsXmlNode *attr = [[HsXmlNode alloc] initAttributeWithName:tempKey WithValue:tempValue] ;
        
        if (![self addAttributeNode:attr])
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)addAttributeNode:(HsXmlNode *)attribute
{
    if (attribute.nodeType != HsXmlNodeTypeAttribute)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception"
                                                 reason:@"the added attribute with type not like HsXmlNodeTypeAttribute"
                                               userInfo:nil];
        return NO;
    }
    
    return [self addNode:attribute];
}

- (BOOL)removeAttributeWithName:(NSString *)attributeName
{
    if ([dicAttributes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:@"there is no attribute to remove"
                                               userInfo:nil];
        return NO;
    }
    
    return [self removeNodeWithName:attributeName WithType:HsXmlNodeTypeAttribute FirstMatch:YES];
}

- (BOOL)removeALLAttributeWithName:(NSString *)attributeName
{
    if ([dicAttributes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception"
                                                 reason:@"there is no attribute to remove"
                                               userInfo:nil];
        return NO;
    }
    
    return [self removeNodeWithName:attributeName WithType:HsXmlNodeTypeAttribute FirstMatch:NO];
}

- (HsXmlNode *)getAttributeWithName:(NSString *)attributeName
{
    if ([dicAttributes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"there is no attribute to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [self getNodeWithName:attributeName WithType:HsXmlNodeTypeAttribute];
}

- (NSArray *)getAllAttributeWithName:(NSString *)attributeName
{
    if ([dicAttributes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception"
                                                 reason:@"there is no element to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [self getAllNodeWithName:attributeName WithType:HsXmlNodeTypeAttribute];
}

- (NSString *)getAttributeValueWithName:(NSString *)attributeName
{
    NSString *tempString = nil;
    HsXmlNode *tempNode = [self getAttributeWithName:attributeName];
    if (tempNode!=nil) {
        tempString = [NSString stringWithString:tempNode.tagValue];
    }
    return tempString;
}

- (NSArray *)getALLAttributes
{
    if ([dicAttributes count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception" 
                                                 reason:@"there is no attribute to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [NSArray arrayWithArray:listAttributes];
}

#pragma mark -
#pragma mark deal with text node function
- (BOOL)addTextNode:(HsXmlNode *)text
{
    if (text.nodeType != HsXmlNodeTypeText)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception" 
                                                 reason:@"the added text with type not like HsXmlNodeTypeText"
                                               userInfo:nil];
        return NO;
    }
    
    return [self addNode:text];
}

- (BOOL)removeTextWithName:(NSString *)textName
{
    if ([dicTexts count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception" 
                                                 reason:@"there is no text to remove"
                                               userInfo:nil];
        return NO;
    }
    
    return [self removeNodeWithName:textName WithType:HsXmlNodeTypeText FirstMatch:YES];
}

- (BOOL)removeALLTextWithName:(NSString *)textName
{
    if ([dicTexts count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"remove failed Exception" 
                                                 reason:@"there is no text to remove"
                                               userInfo:nil];
        return NO;
    }
    
    return [self removeNodeWithName:textName WithType:HsXmlNodeTypeText FirstMatch:NO];
}

- (HsXmlNode *)getTextWithName:(NSString *)textName
{
    if ([dicTexts count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception" 
                                                 reason:@"there is no text to get"
                                               userInfo:nil];
        return nil;
    }
    
    return [self getNodeWithName:textName WithType:HsXmlNodeTypeText];
}

//below function deal with TextNode just like NSString
- (BOOL)addText:(NSString *)text
{
    if ([text length] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"insert failed Exception" 
                                                 reason:@"add textnode without a clear text"
                                               userInfo:nil];
        return NO;
    }
    
    HsXmlNode *tempTextNode = [[HsXmlNode alloc] initWithName:text WithType:HsXmlNodeTypeText] ;
    return [self addTextNode:tempTextNode];
}

- (NSString *)getTextStringWithName:(NSString *)textName
{
    HsXmlNode *tempTextNode = nil;
    
    tempTextNode = [self getTextWithName:textName];
    if (tempTextNode == nil)
    {
        return nil;
    }
    
    return tempTextNode.tagName;
}

- (NSArray *)getALLTexts
{
    if ([dicTexts count] == 0)
    {
        self.errorInfo = [NSException exceptionWithName:@"get failed Exception" 
                                                 reason:@"there is no text to get"
                                               userInfo:nil];
        return nil;
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:5] ;
    HsXmlNode *tempTextNode = nil;
    for (tempTextNode in listTexts)
    {
        if (tempTextNode.nodeType != HsXmlNodeTypeText)
            continue;
        else
        {
            [returnArray addObject:tempTextNode];
        }
        
    }
    
    return returnArray;
}

#pragma mark -
#pragma mark get XML String function
- (NSString *)fullXmlString
{
    NSString *returnString = nil;
    NSArray	*tempArray = nil;
    HsXmlNode *tempNode = nil;
    
    if (self.nodeType == HsXmlNodeTypeText)
    {
        returnString = [NSString stringWithFormat:@"%@\n",self.tagName];
    }
    else if(self.nodeType == HsXmlNodeTypeAttribute)
    {
        returnString = [NSString stringWithFormat:@"%@=\"%@\"",self.tagName,self.tagValue];
    }
    else if (self.nodeType == HsXmlNodeTypeElement)
    {
        returnString = [NSString stringWithFormat:@"<%@",self.tagName];
        //没有子节点和文本子节点,使用当行收尾方式
        if ([dicElements count]+[dicTexts count] == 0)
        {
            tempArray = [NSArray arrayWithArray:listAttributes];
            for (int i = 0; i < [tempArray count]; i++)
            {
                tempNode = (HsXmlNode *)[tempArray objectAtIndex:i];
                returnString = [returnString stringByAppendingFormat:@" %@",[tempNode fullXmlString]];
            }
            
            returnString = [returnString stringByAppendingString:@" />\n"];
        }
        else
        {
            tempArray = [NSArray arrayWithArray:listAttributes];
            for (int i = 0; i < [tempArray count]; i++)
            {
                tempNode = (HsXmlNode *)[tempArray objectAtIndex:i];
                returnString = [returnString stringByAppendingFormat:@" %@",[tempNode fullXmlString]];
            }
            
            returnString = [returnString stringByAppendingString:@" >\n"];
            
            tempArray = [NSArray arrayWithArray:listNodes];
            for (int i = 0; i < [tempArray count]; i++)
            {
                tempNode = (HsXmlNode *)[tempArray objectAtIndex:i];
                if (tempNode.nodeType == HsXmlNodeTypeAttribute)
                    continue;
                
                returnString = [returnString stringByAppendingString:[tempNode fullXmlString]];
            }
            
            returnString = [returnString stringByAppendingFormat:@"</%@>\n",self.tagName];
        }
    }
    return returnString;
}

+ (HsXmlNode *) rootNodeWithString: (NSString*)string 
{
    NSData *dataBuff = [string dataUsingEncoding:NSUTF8StringEncoding];
    HsXmlDomPaser *parser = [[HsXmlDomPaser alloc] initWithData:dataBuff] ;
    HsXmlNode* rootNode = [parser root];
    return rootNode;
}

+ (HsXmlNode *) rootNodeWithFilePath:(NSString *)filePath
{
    @try {
        NSString *absolutefilePath = [NSString appPathWithFilePath:filePath];
        
        NSMutableData *dataBuff = [NSMutableData dataWithContentsOfFile:absolutefilePath];
        if ([dataBuff length] == 0)
        {
            NSException *exception = [NSException exceptionWithName:@"Error Open file"
                                                             reason:[NSString stringWithFormat:@"Could not find file:[%@]",absolutefilePath]  userInfo:nil];
            @throw exception;	
        }
        HsXmlDomPaser *parser = [[HsXmlDomPaser alloc] initWithData:dataBuff] ;
        HsXmlNode* rootNode = [parser root];
        //[parser release];
        
        if(rootNode != nil)
        {	
            return rootNode;
        }
        else
        {
            @throw rootNode.errorInfo;	
        }
    }
    @catch (NSException * e) {
#ifdef TRACE_LOG
        DLog(@"%@", [e name]);
        DLog(@"%@",[e reason]);
#endif
    }
    @finally {
        //free(pResults);
    }
    
    return nil;
}
@end

