//
//  HsXmlNode.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/7/28.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum HsXmlNodeType {
    HsXmlNodeTypeUnkonw,
    HsXmlNodeTypeElement,
    HsXmlNodeTypeAttribute,
    HsXmlNodeTypeText,
} HsXmlNodeType;

@interface HsXmlNode : NSObject
{
    NSString				*tagName;
    //attribute的属性值
    NSString				*tagValue;
    HsXmlNodeType			nodeType;
    
    __unsafe_unretained	HsXmlNode				*nodeParent;
    NSMutableDictionary		*dicNodes;
    NSMutableDictionary		*dicElements;
    NSMutableDictionary		*dicAttributes;
    NSMutableDictionary		*dicTexts;
    
    NSMutableArray			*listNodes;
    NSMutableArray			*listElements;
    NSMutableArray			*listAttributes;
    NSMutableArray			*listTexts;
    
    NSException				*errorInfo;
}

@property (nonatomic, retain)NSString				*tagName;
@property (nonatomic, retain, readonly)NSString		*tagValue;
@property (readonly, assign) HsXmlNodeType			nodeType;
@property (nonatomic, assign)HsXmlNode				*nodeParent;

@property (nonatomic, retain)NSException			*errorInfo;

- (id)initWithName:(NSString *)name WithType:(HsXmlNodeType)type;
- (id)initAttributeWithName:(NSString *)name WithValue:(NSString *)value;

//- (BOOL)addNode:(HsXmlNode *)node;
//- (BOOL)removeNodeWithName:(NSString *)nodeName;
- (HsXmlNode *)getNodeWithName:(NSString *)nodeName;
- (NSArray *)getALLNodes;

- (BOOL)addElementNode:(HsXmlNode *)element;
- (BOOL)removeElementWithName:(NSString *)elementName;
- (BOOL)removeALLElementWithName:(NSString *)elementName;
- (HsXmlNode *)getElementWithName:(NSString *)elementName;
- (NSArray *)getAllElementWithName:(NSString *)elementName;
- (NSArray *)getALLElements;

- (BOOL)addAttributeNode:(HsXmlNode *)attribute;
//input a dictionary,Keys are the names of attributes, and values are attribute values.
- (BOOL)addAttributes:(NSDictionary *)attributeMaps;
- (BOOL)removeAttributeWithName:(NSString *)attributeName;
- (BOOL)removeALLAttributeWithName:(NSString *)attributeName;
- (HsXmlNode *)getAttributeWithName:(NSString *)attributeName;
- (NSArray *)getAllAttributeWithName:(NSString *)attributeName;
- (NSString *)getAttributeValueWithName:(NSString *)attributeName;
- (NSArray *)getALLAttributes;

- (BOOL)addTextNode:(HsXmlNode *)text;
- (BOOL)removeTextWithName:(NSString *)textName;
- (BOOL)removeALLTextWithName:(NSString *)textName;
- (HsXmlNode *)getTextWithName:(NSString *)textName;
//below function deal with TextNode just like NSString
- (BOOL)addText:(NSString *)text;
- (NSString *)getTextStringWithName:(NSString *)textName;
- (NSArray *)getALLTexts;

- (NSString *)fullXmlString;

+ (HsXmlNode *) rootNodeWithString: (NSString*)string;
+ (HsXmlNode *) rootNodeWithFilePath:(NSString *)filePath;
@end

