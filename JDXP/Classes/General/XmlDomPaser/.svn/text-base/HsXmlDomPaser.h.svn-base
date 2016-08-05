//
//  HsXmlDomPaser.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/7/28.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsXmlNode.h"

@interface HsXmlDomPaser: NSObject
<NSXMLParserDelegate>
{
    HsXmlNode		*root;
    NSData			*data;
    
    NSXMLParser		*m_parser;
    HsXmlNode		*curElement;
    
    BOOL			bReadingText;
    NSMutableString		*TextBuffer;
}

@property (nonatomic, readonly)HsXmlNode	*root;
@property (nonatomic, retain)NSMutableString		*TextBuffer;

- (id)initWithData:(NSData *)xmldata;

@end

