//
//  MPXMLKit.h
//  MPXMLKit
//
//  Created by shenmo on 12/28/14.
//  Copyright (c) 2014 shenmo. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark DDXMLNode.h

#import <libxml/tree.h>

@class DDXMLDocument;

/**
 * Welcome to KissXML.
 *
 * The project page has documentation if you have questions.
 * https://github.com/robbiehanson/KissXML
 *
 * If you're new to the project you may wish to read the "Getting Started" wiki.
 * https://github.com/robbiehanson/KissXML/wiki/GettingStarted
 *
 * KissXML provides a drop-in replacement for Apple's NSXML class cluster.
 * The goal is to get the exact same behavior as the NSXML classes.
 *
 * For API Reference, see Apple's excellent documentation,
 * either via Xcode's Mac OS X documentation, or via the web:
 *
 * https://github.com/robbiehanson/KissXML/wiki/Reference
 **/

enum {
    DDXMLInvalidKind                = 0,
    DDXMLDocumentKind               = XML_DOCUMENT_NODE,
    DDXMLElementKind                = XML_ELEMENT_NODE,
    DDXMLAttributeKind              = XML_ATTRIBUTE_NODE,
    DDXMLNamespaceKind              = XML_NAMESPACE_DECL,
    DDXMLProcessingInstructionKind  = XML_PI_NODE,
    DDXMLCommentKind                = XML_COMMENT_NODE,
    DDXMLTextKind                   = XML_TEXT_NODE,
    DDXMLDTDKind                    = XML_DTD_NODE,
    DDXMLEntityDeclarationKind      = XML_ENTITY_DECL,
    DDXMLAttributeDeclarationKind   = XML_ATTRIBUTE_DECL,
    DDXMLElementDeclarationKind     = XML_ELEMENT_DECL,
    DDXMLNotationDeclarationKind    = XML_NOTATION_NODE
};
typedef NSUInteger DDXMLNodeKind;

enum {
    DDXMLNodeOptionsNone            = 0,
    DDXMLNodeExpandEmptyElement     = 1 << 1,
    DDXMLNodeCompactEmptyElement    = 1 << 2,
    DDXMLNodePrettyPrint            = 1 << 17,
};


//extern struct _xmlKind;


@interface DDXMLNode : NSObject <NSCopying>
{
    // Every DDXML object is simply a wrapper around an underlying libxml node
    struct _xmlKind *genericPtr;
    
    // Every libxml node resides somewhere within an xml tree heirarchy.
    // We cannot free the tree heirarchy until all referencing nodes have been released.
    // So all nodes retain a reference to the node that created them,
    // and when the last reference is released the tree gets freed.
    DDXMLNode *owner;
}

//- (id)initWithKind:(DDXMLNodeKind)kind;

//- (id)initWithKind:(DDXMLNodeKind)kind options:(NSUInteger)options;

//+ (id)document;

//+ (id)documentWithRootElement:(DDXMLElement *)element;

+ (id)elementWithName:(NSString *)name;

+ (id)elementWithName:(NSString *)name URI:(NSString *)URI;

+ (id)elementWithName:(NSString *)name stringValue:(NSString *)string;

+ (id)elementWithName:(NSString *)name children:(NSArray *)children attributes:(NSArray *)attributes;

+ (id)attributeWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)attributeWithName:(NSString *)name URI:(NSString *)URI stringValue:(NSString *)stringValue;

+ (id)namespaceWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)processingInstructionWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)commentWithStringValue:(NSString *)stringValue;

+ (id)textWithStringValue:(NSString *)stringValue;

//+ (id)DTDNodeWithXMLString:(NSString *)string;

#pragma mark --- Properties ---

- (DDXMLNodeKind)kind;

- (void)setName:(NSString *)name;
- (NSString *)name;

//- (void)setObjectValue:(id)value;
//- (id)objectValue;

- (void)setStringValue:(NSString *)string;
//- (void)setStringValue:(NSString *)string resolvingEntities:(BOOL)resolve;
- (NSString *)stringValue;

#pragma mark --- Tree Navigation ---

- (NSUInteger)index;

- (NSUInteger)level;

- (DDXMLDocument *)rootDocument;

- (DDXMLNode *)parent;
- (NSUInteger)childCount;
- (NSArray *)children;
- (DDXMLNode *)childAtIndex:(NSUInteger)index;

- (DDXMLNode *)previousSibling;
- (DDXMLNode *)nextSibling;

- (DDXMLNode *)previousNode;
- (DDXMLNode *)nextNode;

- (void)detach;

- (NSString *)XPath;

#pragma mark --- QNames ---

- (NSString *)localName;
- (NSString *)prefix;

- (void)setURI:(NSString *)URI;
- (NSString *)URI;

+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;
//+ (DDXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;

#pragma mark --- Output ---

- (NSString *)description;
- (NSString *)XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

#pragma mark --- XPath/XQuery ---

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery constants:(NSDictionary *)constants error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery error:(NSError **)error;

@end

#pragma mark DDXMLElement.h

@interface DDXMLElement : DDXMLNode
{
}

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name URI:(NSString *)URI;
- (id)initWithName:(NSString *)name stringValue:(NSString *)string;
- (id)initWithXMLString:(NSString *)string error:(NSError **)error;

#pragma mark --- Elements by name ---

- (NSArray *)elementsForName:(NSString *)name;
- (NSArray *)elementsForLocalName:(NSString *)localName URI:(NSString *)URI;

#pragma mark --- Attributes ---

- (void)addAttribute:(DDXMLNode *)attribute;
- (void)removeAttributeForName:(NSString *)name;
- (void)setAttributes:(NSArray *)attributes;
//- (void)setAttributesAsDictionary:(NSDictionary *)attributes;
- (NSArray *)attributes;
- (DDXMLNode *)attributeForName:(NSString *)name;
//- (DDXMLNode *)attributeForLocalName:(NSString *)localName URI:(NSString *)URI;

#pragma mark --- Namespaces ---

- (void)addNamespace:(DDXMLNode *)aNamespace;
- (void)removeNamespaceForPrefix:(NSString *)name;
- (void)setNamespaces:(NSArray *)namespaces;
- (NSArray *)namespaces;
- (DDXMLNode *)namespaceForPrefix:(NSString *)prefix;
- (DDXMLNode *)resolveNamespaceForName:(NSString *)name;
- (NSString *)resolvePrefixForNamespaceURI:(NSString *)namespaceURI;

#pragma mark --- Children ---

- (void)insertChild:(DDXMLNode *)child atIndex:(NSUInteger)index;
//- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)setChildren:(NSArray *)children;
- (void)addChild:(DDXMLNode *)child;
//- (void)replaceChildAtIndex:(NSUInteger)index withNode:(DDXMLNode *)node;
//- (void)normalizeAdjacentTextNodesPreservingCDATA:(BOOL)preserve;

@end

#pragma mark DDXMLDocument.h

enum {
    DDXMLDocumentXMLKind = 0,
    DDXMLDocumentXHTMLKind,
    DDXMLDocumentHTMLKind,
    DDXMLDocumentTextKind
};
typedef NSUInteger DDXMLDocumentContentKind;

@interface DDXMLDocument : DDXMLNode
{
}

- (id)initWithXMLString:(NSString *)string options:(NSUInteger)mask error:(NSError **)error;
//- (id)initWithContentsOfURL:(NSURL *)url options:(NSUInteger)mask error:(NSError **)error;
- (id)initWithData:(NSData *)data options:(NSUInteger)mask error:(NSError **)error;
//- (id)initWithRootElement:(DDXMLElement *)element;

//+ (Class)replacementClassForClass:(Class)cls;

//- (void)setCharacterEncoding:(NSString *)encoding; //primitive
//- (NSString *)characterEncoding; //primitive

//- (void)setVersion:(NSString *)version;
//- (NSString *)version;

//- (void)setStandalone:(BOOL)standalone;
//- (BOOL)isStandalone;

//- (void)setDocumentContentKind:(DDXMLDocumentContentKind)kind;
//- (DDXMLDocumentContentKind)documentContentKind;

//- (void)setMIMEType:(NSString *)MIMEType;
//- (NSString *)MIMEType;

//- (void)setDTD:(DDXMLDTD *)documentTypeDeclaration;
//- (DDXMLDTD *)DTD;

//- (void)setRootElement:(DDXMLNode *)root;
- (DDXMLElement *)rootElement;

//- (void)insertChild:(DDXMLNode *)child atIndex:(NSUInteger)index;

//- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index;

//- (void)removeChildAtIndex:(NSUInteger)index;

//- (void)setChildren:(NSArray *)children;

//- (void)addChild:(DDXMLNode *)child;

//- (void)replaceChildAtIndex:(NSUInteger)index withNode:(DDXMLNode *)node;

- (NSData *)XMLData;
- (NSData *)XMLDataWithOptions:(NSUInteger)options;

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;

//- (BOOL)validateAndReturnError:(NSError **)error;

@end

#pragma mark DDXML.h

#if TARGET_OS_IPHONE && 0 // Disabled by default

// Since KissXML is a drop in replacement for NSXML,
// it may be desireable (when writing cross-platform code to be used on both Mac OS X and iOS)
// to use the NSXML prefixes instead of the DDXML prefix.
//
// This way, on Mac OS X it uses NSXML, and on iOS it uses KissXML.

#ifndef NSXMLNode
#define NSXMLNode DDXMLNode
#endif
#ifndef NSXMLElement
#define NSXMLElement DDXMLElement
#endif
#ifndef NSXMLDocument
#define NSXMLDocument DDXMLDocument
#endif

#ifndef NSXMLInvalidKind
#define NSXMLInvalidKind DDXMLInvalidKind
#endif
#ifndef NSXMLDocumentKind
#define NSXMLDocumentKind DDXMLDocumentKind
#endif
#ifndef NSXMLElementKind
#define NSXMLElementKind DDXMLElementKind
#endif
#ifndef NSXMLAttributeKind
#define NSXMLAttributeKind DDXMLAttributeKind
#endif
#ifndef NSXMLNamespaceKind
#define NSXMLNamespaceKind DDXMLNamespaceKind
#endif
#ifndef NSXMLProcessingInstructionKind
#define NSXMLProcessingInstructionKind DDXMLProcessingInstructionKind
#endif
#ifndef NSXMLCommentKind
#define NSXMLCommentKind DDXMLCommentKind
#endif
#ifndef NSXMLTextKind
#define NSXMLTextKind DDXMLTextKind
#endif
#ifndef NSXMLDTDKind
#define NSXMLDTDKind DDXMLDTDKind
#endif
#ifndef NSXMLEntityDeclarationKind
#define NSXMLEntityDeclarationKind DDXMLEntityDeclarationKind
#endif
#ifndef NSXMLAttributeDeclarationKind
#define NSXMLAttributeDeclarationKind DDXMLAttributeDeclarationKind
#endif
#ifndef NSXMLElementDeclarationKind
#define NSXMLElementDeclarationKind DDXMLElementDeclarationKind
#endif
#ifndef NSXMLNotationDeclarationKind
#define NSXMLNotationDeclarationKind DDXMLNotationDeclarationKind
#endif

#ifndef NSXMLNodeOptionsNone
#define NSXMLNodeOptionsNone DDXMLNodeOptionsNone
#endif
#ifndef NSXMLNodeExpandEmptyElement
#define NSXMLNodeExpandEmptyElement DDXMLNodeExpandEmptyElement
#endif
#ifndef NSXMLNodeCompactEmptyElement
#define NSXMLNodeCompactEmptyElement DDXMLNodeCompactEmptyElement
#endif
#ifndef NSXMLNodePrettyPrint
#define NSXMLNodePrettyPrint DDXMLNodePrettyPrint
#endif

#endif // #if TARGET_OS_IPHONE

#if DEBUG
#define DDXML_DEBUG_MEMORY_ISSUES 0
#else
#define DDXML_DEBUG_MEMORY_ISSUES 0 // Don't change me!
#endif