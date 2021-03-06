//
//  HsXmlDomPaser.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/7/28.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "HsXmlDomPaser.h"
#import "UtilsMacro.h"


@implementation HsXmlDomPaser
@synthesize root;
@synthesize TextBuffer;

- (void)dealloc
{
    m_parser.delegate = nil;
}

#pragma mark -
#pragma mark deal with node function
- (id)initWithData:(NSData *)xmldata
{
    self = [super init];
    if (self)
    {
        root = nil;
        data = xmldata ;
        m_parser = [[NSXMLParser alloc] initWithData:data];
        m_parser.delegate = self;	// TODO: for sdk reason there is a warning
        
        bReadingText = NO;
    }
    return self;
}

- (HsXmlNode *)root
{
    if (root == nil)
    {
        @try
        {
            [m_parser parse];
        }
        @catch (NSException * e)
        {
#ifdef TRACE_LOG
            DLog(@"HsXmlDomPaser parse root error [%@]",[e name]);
            DLog(@"[%@]",[e reason]);
#endif
        }
        @finally
        {
            
        }
    }
    return root ;
}

#pragma mark -
#pragma mark NSXMLParserDelegate function
- (void)parserDidStartDocument:(NSXMLParser *)parser
// sent when the parser begins parsing of the document.
{
    DLog( @"parser start");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
// sent when the parser has completed parsing. If this is encountered, the parse was successful.
{
    DLog(@"parser end");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, \
the elementName is 'radar:radar' and there is no qualifiedName.
{
    HsXmlNode *tempElement = nil;
    
    @try
    {
        //without a root element
        if (root == nil)
        {
            root = [[HsXmlNode alloc] initWithName:elementName WithType:HsXmlNodeTypeElement];
            curElement = root;
            
            //add attributes
            if (![root addAttributes:attributeDict])
            {
                @throw root.errorInfo;
            }
        }
        else
        {
            if (bReadingText)
            {
                [curElement addText:TextBuffer];
                bReadingText = NO;
            }
            
            tempElement = [[HsXmlNode alloc] initWithName:elementName WithType:HsXmlNodeTypeElement];
            //add attributes
            if (![tempElement addAttributes:attributeDict])
            {
                @throw tempElement.errorInfo;
            }
            
            //add element
            if ([curElement addElementNode:tempElement])
            {
                curElement = tempElement;
            }
            else
            {
                @throw curElement.errorInfo;
            }
            
        }
    }
    @catch (NSException * e)
    {
#ifdef TRACE_LOG
        DLog(@"HsXmlDomPaser parse didStartElement error [%@]",[e name]);
        DLog(@"[%@]",[e reason]);
#endif
        [parser abortParsing];
    }
    @finally
    {
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
// sent when an end tag is encountered. The various parameters are supplied as above.
{
    @try
    {
        if ([curElement.tagName compare:elementName] != NSOrderedSame)
        {
            NSException* myException = [NSException
                                        exceptionWithName:@"build Dom tree error"
                                        reason:@"endTagName and startTagName do not march up"
                                        userInfo:nil];
            @throw myException;
        }
        
        if (bReadingText)
        {
            [curElement addText:TextBuffer];
            bReadingText = NO;
        }
        
        if (curElement.nodeParent == nil && curElement == root)
        {
            DLog(@"HsXmlDomPaser parse should finished, nothing error.");
        }
        else
        {
            curElement = curElement.nodeParent;
        }
        
    }
    @catch (NSException * e)
    {
#ifdef TRACE_LOG
        DLog(@"HsXmlDomPaser parse didEndElement error [%@]",[e name]);
        DLog(@"[%@]",[e reason]);
#endif
        [parser abortParsing];
    }
    @finally
    {
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
// This returns the string of the characters encountered thus far. \
You may not necessarily get the longest character run. \
The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
{
    NSString *tempString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tempString length] == 0)
    {
        return;
    }
    
    if (bReadingText)
    {
        [TextBuffer appendString:tempString];
    }
    else
    {
        self.TextBuffer = [NSMutableString stringWithString:tempString];
        bReadingText = YES;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
// ...and this reports a fatal error to the delegate. The parser will stop parsing.
{
#ifdef TRACELOG
    DLog(@"HsXmlDomPaser parseErrorOccurred [%@]",parseError);
#endif
}

@end
