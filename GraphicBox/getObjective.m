//
//  getObjective.m
//  GraphicBox
//
//  Created by Alessandro Marconi on 10/07/2018.
//  Copyright © 2018 Alessandro Marconi. All rights reserved.
//

#import "GraphicBox-Bridging-Header.h"

@implementation getObjective

- (void) getMethod
{
    NSDictionary *headers = @{ @"x-auth-header": @"fb2f56fde81f21926fc0b5b74702f71da9f152efa7b5587a308984b71c9acac7fd44da05583ab06d57d29794f59fc475d9f2d132cbc6e29c421f11330a30a613" };

    NSData *postData = [[NSData alloc] initWithData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://rekrutacja.backendzs.pl/note/"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}
@end
