

#import "XMLHandler.h"


@implementation XMLHandler
@synthesize delegate;

- (void)parseXMLFileAt:(NSString*)strPath{

//    DLog(@"strPath : %@", strPath);
	_parser=[[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strPath]];
	_parser.delegate=self;
		_epubContent=[[EpubContent alloc] init];
    _itemdictionary=[[NSMutableDictionary alloc] init];
    _spinearray=[[NSMutableArray alloc] init];
	[_parser parse];
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	DLog(@"Error Occured : %@",[parseError description]);

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
//	DLog(@"elementName : %@", elementName);
//	DLog(@"namespaceURI : %@", namespaceURI);
//	DLog(@"qName : %@", qName);    
//    DLog(@"attributeDict : %@", attributeDict);
	if ([elementName isEqualToString:@"rootfile"]) {
		
		_rootPath=[attributeDict valueForKey:@"full-path"];
		if ((delegate!=nil)&&([delegate respondsToSelector:@selector(foundRootPath:)])) {
//			DLog(@"_rootPath : %@", _rootPath);
			[delegate foundRootPath:_rootPath];
		}
	}
	
//	if ([elementName isEqualToString:@"package"]){
//	
//		_epubContent=[[EpubContent alloc] init];
//	}
//	
//	if ([elementName isEqualToString:@"manifest"]) {
//		
//		_itemdictionary=[[NSMutableDictionary alloc] init];
//	}
	
	if ([elementName isEqualToString:@"item"]) {
		
		[_itemdictionary setValue:[attributeDict valueForKey:@"href"] forKey:[attributeDict valueForKey:@"id"]];
	}
	
//	if ([elementName isEqualToString:@"spine"]) {
//		
//		_spinearray=[[NSMutableArray alloc] init];
//	}
	
	if ([elementName isEqualToString:@"itemref"]) {
		
		[_spinearray addObject:[attributeDict valueForKey:@"idref"]];
	}
    
    if ([elementName isEqualToString:@"meta"]) {
        if ([[attributeDict objectForKey:@"name"] isEqualToString:@"cover"] == TRUE) {
//            DLog(@"cover : %@", [attributeDict objectForKey:@"content"]);
            [_itemdictionary setValue:[attributeDict valueForKey:@"content"] forKey:@"COVERIMAGE"];
//            DLog(@"_itemdictionary : %@", _itemdictionary);
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
//	DLog(@"elementName : %@", elementName);
//	DLog(@"namespaceURI : %@", namespaceURI);
//	DLog(@"qName : %@", qName);    
    if ([elementName isEqualToString:@"manifest"]) {
//        DLog(@"_itemdictionary : %@", _itemdictionary);        
        _epubContent._manifest=_itemdictionary;
    }
    if ([elementName isEqualToString:@"spine"]) {
        
        _epubContent._spine=_spinearray;
    }

    if ([elementName isEqualToString:@"package"]) {
    
        if ((delegate!=nil)&&([delegate respondsToSelector:@selector(finishedParsing:)])) {
            
            [delegate finishedParsing:_epubContent];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	

}
@end
