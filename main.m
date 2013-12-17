//
//  main.m
//  Parse
//

#import <Foundation/Foundation.h>
//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#import "NSString+QuoteFix.h"
#import "NSString+Contains.h"
#import "CHCSVParser.h"

@interface CSV: NSObject {
@public
    NSMutableArray *sourceReturnArray;
    NSMutableArray *coversReturnArray;
    NSMutableArray *metadataReturnArray;
}

- (NSArray *)arrayFromCSV:(NSString *)csv returnArray:(NSArray *)returnArray format:(NSArray *)format ignoreHeader:(BOOL)ignore;

@end


@implementation CSV

-(id) init {
    if (self = [super init])
    {
        sourceReturnArray = [NSMutableArray array];
        coversReturnArray = [NSMutableArray array];
        metadataReturnArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)arrayFromCSV:(NSString *)path returnArray:(NSMutableArray *)returnArray format:(NSArray *)format ignoreHeader:(BOOL)ignore {
    NSArray *dataRows = [NSArray arrayWithContentsOfCSVFile:path];
    NSInteger expectedRowComponents = [[dataRows objectAtIndex:0] count];
    if ([format count] > expectedRowComponents) {
        // more format keys than components
        return nil;
    }
    for ( NSInteger i = 0; i < [dataRows count]; i++ ) {
        if (i == 0 && ignore)
            // ignore first line in csv, "header"
            continue;
        NSArray *rowComponents = [dataRows objectAtIndex:i];
        if ( [rowComponents count] != expectedRowComponents )
            continue;
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
        for ( NSInteger j = 0; j < [format count]; j++ ) {
            if ( [format objectAtIndex:j] != [NSNull null] ) {
                [tmpDict setObject:[rowComponents objectAtIndex:j] forKey:[format objectAtIndex:j]];
            }
        }
        [returnArray addObject:tmpDict];
    }
    return returnArray;
}

@end

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        CSV *dataSource = [[CSV alloc] init];
        
        // Setup source CSV and format
        NSString *sourceCSVPATH = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"releases/source-32x.txt"];
        
        NSArray *sourceFormat = @[ @"releaseID",
                                   @"romID",
                                   @"releaseTitleName",
                                   @"regionLocalizedID",
                                   @"TEMPregionLocalizedName",
                                   @"TEMPsystemShortName",
                                   @"TEMPsystemName",
                                   @"releaseCoverFront",
                                   @"releaseCoverBack",
                                   @"releaseCoverCart",
                                   @"releaseCoverDisc",
                                   @"releaseDescription",
                                   @"releaseDeveloper",
                                   @"releasePublisher",
                                   @"releaseGenre",
                                   @"releaseDate",
                                   @"releaseReferenceURL",
                                   ];
        
        [dataSource arrayFromCSV:sourceCSVPATH returnArray:dataSource->sourceReturnArray format:sourceFormat ignoreHeader:YES];
        
        
        // Setup covers CSV and format
        NSString *coversCSVPATH = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"covers/32X.csv"];
        
        NSArray *coversFormat = @[ @"Title",
                                   @"CoverRegionName",
                                   @"CoverType",
                                   @"CoverURL"
                                   ];
        
        [dataSource arrayFromCSV:coversCSVPATH returnArray:dataSource->coversReturnArray format:coversFormat ignoreHeader:YES];
        
        // Setup metadata CSV and format
        NSString *metadataCSVPATH = [[@(__FILE__) stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"metadata/32X.csv"];
        
        NSArray *metadataFormat = @[ @"Title",
                                     @"Genres",
                                     @"Description",
                                     @"GameFAQs_Reader_Rating",
                                     @"GameFAQs_Rating",
                                     @"MetaCritics_MetaScore",
                                     @"Developer",
                                     @"ReleaseDate",
                                     @"ReferenceURL"
                                    ];
        
        [dataSource arrayFromCSV:metadataCSVPATH returnArray:dataSource->metadataReturnArray format:metadataFormat ignoreHeader:YES];
        
        //NSLog(@"%@", [dataSource->sourceReturnArray objectAtIndex:2]);
        //NSLog(@"%@", [dataSource->coversReturnArray objectAtIndex:2]);
        //NSLog(@"%@", [dataSource->metadataReturnArray objectAtIndex:2]);
        
        NSLog(@"\"romID\";\"releaseTitleName\";\"regionLocalizedID\";\"TEMPregionLocalizedName\";\"TEMPsystemShortName\";\"TEMPsystemName\";\"releaseCoverFront\";\"releaseCoverBack\";\"releaseCoverCart\";\"releaseCoverDisc\";\"releaseDescription\";\"releaseDeveloper\";\"releasePublisher\";\"releaseGenre\";\"releaseDate\";\"releaseReferenceURL\"");
          
        // Loop through the source array and compare array and look for matches
        BOOL matchFound = NO;
        int matchCounter = 0;
        int printCounter = 0;
        NSString *boxFront, *boxBack, *cart, *disc, *description, *developer, *publisher, *genre, *releaseDate, *referenceURL;
        for (NSDictionary *games in dataSource->sourceReturnArray) {
            //NSLog(@"%@", [games valueForKeyPath:@"releaseTitleName"]);
            boxFront = @"NULL";
            boxBack = @"NULL";
            cart = @"NULL";
            disc = @"NULL";
            description = @"NULL";
            developer = @"NULL";
            publisher = @"NULL";
            genre = @"NULL";
            releaseDate = @"NULL";
            referenceURL = @"NULL";
            
            for (NSDictionary *covers in dataSource->coversReturnArray) {
                //NSLog(@"%@", [covers valueForKeyPath:@"Title"]);
                
                
                // Did we find an Exact Match "title" between source and compare arrays?
                if (//[[[games valueForKeyPath:@"releaseTitleName"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]]
                     
                     //isEqualToString:
                     
                     //[[covers valueForKeyPath:@"Title"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]]])
                     //[[[[covers valueForKeyPath:@"CoverRegionName"] componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""] containsString:[[[games valueForKeyPath:@"releaseTitleName"] componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""]])
                    
                    // Remove all non-alphanumeric chars and make lowercase as to increase matches
                    [[[[covers valueForKeyPath:@"CoverRegionName"] componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""] containsString:[[[games valueForKeyPath:@"releaseTitleName"] componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""] options:NSCaseInsensitiveSearch])
                    {
                        matchFound = YES;
                        
                        // Match metadata
                        for (NSDictionary *metadata in dataSource->metadataReturnArray)
                        {
                            if ([[[[metadata valueForKeyPath:@"Title"] componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""] containsString:[[[games valueForKeyPath:@"releaseTitleName"] componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""] options:NSCaseInsensitiveSearch])
                            {
                                genre = [[metadata valueForKeyPath:@"Genres"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"Genres"];
                                description = [[metadata valueForKeyPath:@"Description"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"Description"];
                                developer = [[metadata valueForKeyPath:@"Developer"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"Developer"];
                                releaseDate = [[[[metadata valueForKeyPath:@"ReleaseDate"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"ReleaseDate"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                referenceURL = [[metadata valueForKeyPath:@"ReferenceURL"] isEqualToString:@"\"\""] ? @"NULL" : [metadata valueForKeyPath:@"ReferenceURL"];
                                //genre = [metadata valueForKeyPath:@"Genres"];
                                //description = [metadata valueForKeyPath:@"Description"];
                                //developer = [metadata valueForKeyPath:@"Developer"];
                                //releaseDate = [metadata valueForKeyPath:@"ReleaseDate"];
                                //referenceURL = [metadata valueForKeyPath:@"ReferenceURL"];
                                break;
                            }
                        }
                        
                        // USA region
                        if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"USA\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(US, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                        // Europe region
                        else if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Europe\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(EU, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                        // Japan region
                        else if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Japan\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(JP, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                        // Asia region
                        else if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Asia\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(AS, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                        // Australia region
                        else if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Australia\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(AU, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                        // Brazil region
                        else if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Brazil\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(SA, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                        // Korea region
                        else if ([[games valueForKeyPath:@"TEMPregionLocalizedName"] isEqualToString:@"\"Brazil\""] && [[covers valueForKeyPath:@"CoverRegionName"] containsString:@"(KO, "])
                        {
                            // get the front cover
                            if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Front\""])
                            {
                                boxFront = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxFront);
                                //break;
                                continue;
                            }
                            // get the back cover
                            else if ([[covers valueForKeyPath:@"CoverType"] isEqualToString:@"\"Box Back\""])
                            {
                                boxBack = [[covers valueForKeyPath:@"CoverURL"] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
                                //NSLog(@"%@",boxBack);
                            }
                            
                            NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                                  [games valueForKeyPath:@"romID"],
                                  [games valueForKeyPath:@"releaseTitleName"],
                                  [games valueForKeyPath:@"regionLocalizedID"],
                                  [games valueForKeyPath:@"TEMPregionLocalizedName"],
                                  [games valueForKeyPath:@"TEMPsystemShortName"],
                                  [games valueForKeyPath:@"TEMPsystemName"],
                                  boxFront,
                                  boxBack,
                                  cart,
                                  disc,
                                  description,
                                  developer,
                                  publisher,
                                  genre,
                                  releaseDate,
                                  referenceURL
                                  );
                            matchCounter++;
                            printCounter++;
                            break;
                        }
                    }
                else
                    matchFound = NO;
                
            } // for-loop covers
            
            // No "Exact Match" so print the release anyway
            if (!matchFound)
            {
                NSLog(@"%@;%@;%@;%@;%@;%@;\"%@\";\"%@\";%@;%@;%@;%@;%@;%@;%@;%@",
                      [games valueForKeyPath:@"romID"],
                      [games valueForKeyPath:@"releaseTitleName"],
                      [games valueForKeyPath:@"regionLocalizedID"],
                      [games valueForKeyPath:@"TEMPregionLocalizedName"],
                      [games valueForKeyPath:@"TEMPsystemShortName"],
                      [games valueForKeyPath:@"TEMPsystemName"],
                      boxFront,
                      boxBack,
                      cart,
                      disc,
                      description,
                      developer,
                      publisher,
                      genre,
                      releaseDate,
                      referenceURL
                      );
                printCounter++;
            }
            
            
        } // for-loop games
        
        NSLog(@"Cover Matches (this number is wrong): %d", matchCounter);
        NSLog(@"Releases: %lu", (unsigned long)[dataSource->sourceReturnArray count]);
        NSLog(@"Printed:  %d", printCounter);
    }
    return 0;
}
