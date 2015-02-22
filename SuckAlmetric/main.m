//
//  main.m
//  SuckAlmetric
//
//  Created by Yosnier on 20/02/15.
//  Copyright (c) 2015 YOS. All rights reserved.
//

#import <Foundation/Foundation.h>




int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory
                                          inDomains:NSUserDomainMask] lastObject];
        NSError *err = nil;
        NSString *fileContents = [NSString stringWithContentsOfURL:[url URLByAppendingPathComponent:@"DOIs.csv"]
                                                          encoding:NSUTF8StringEncoding
                                                             error:&err];
        
        NSArray *rows = [fileContents componentsSeparatedByString:@"\n"];
        
        NSMutableArray *colDI = [NSMutableArray array];
        
        for (NSString *row in rows) {
            
            NSArray* columns = [row componentsSeparatedByString:@","];
            NSString *doi = columns[0];
            [colDI addObject:doi];
        }
        
        
        NSLog(@" Count DOIs: %lu",[colDI count]) ;
        NSString *cadena = [[NSString alloc]init];
        
        int count = 0;
        
        for (NSString *doi in colDI) {
            
            count = count +1;
            
            NSURL *urlApi = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.altmetric.com/v1/doi/%@", doi]];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:urlApi];
            NSURLResponse *response = [[NSURLResponse alloc] init];
            NSError *err;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
            
            NSString* json = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
            
            
            if ([json isEqualToString:@"Not Found"]) {
                NSLog(@"DOI not fount");
            } else {
                cadena = [cadena stringByAppendingString:[NSString stringWithFormat:@"\nDoi:%i ----------\n %@", count,json]];
                
                NSLog(@"Cadena: %@",cadena);
            }
            
            
            NSLog(@"Doi:%i",count);
        }
        
        NSLog(@"fichero : %@",cadena);
        
        NSURL *urlResult = [[fileManager URLsForDirectory:NSDocumentDirectory
                                          inDomains:NSUserDomainMask] lastObject];
        
        urlResult = [url URLByAppendingPathComponent:@"WOSAlmetric.json"];
        
        BOOL rc = NO;
        rc = [cadena writeToURL:urlResult
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:&err];
        
        
        return 0;
    }
    
}
