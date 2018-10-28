//
//  IPAddress.h
//  LocalToIP
//
//  Created by Zachary Gibson on 10/28/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>

@interface IPAddress : NSHost

+ (NSDictionary *) interfaceIP4Addresses;
+ (NSDictionary *) interfaceIP6Addresses;
+ (NSDictionary *) interfaceIPAddresses;

@end
