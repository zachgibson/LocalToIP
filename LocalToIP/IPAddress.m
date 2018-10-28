//
//  IPAddress.m
//  LocalToIP
//
//  Created by Zachary Gibson on 10/28/18.
//  Copyright © 2018 Zach Gibson. All rights reserved.
//

#import "IPAddress.h"

typedef NS_ENUM(NSUInteger, AddressType) {
    AddressTypeBoth     = 0,
    AddressTypeIPv4     = 1,
    AddressTypeIPv6     = 2
};

@implementation IPAddress

#pragma mark - Helper Methods:

+ (NSDictionary *) _interfaceAddressesForFamily:(AddressType)family {
    
    NSMutableDictionary *interfaceInfo = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces;
    
    if ( (0 == getifaddrs(&interfaces)) ) {
        
        struct ifaddrs *interface;
        
        for ( interface=interfaces; interface != NULL; interface=interface->ifa_next ) {
            
            if ( (interface->ifa_flags & IFF_UP) && !(interface->ifa_flags & IFF_LOOPBACK) ) {
                
                const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
                
                if ( addr && addr->sin_family == PF_INET ) {
                    
                    if ( (family == AddressTypeBoth) || (family == AddressTypeIPv4) ) {
                        char ip4Address[INET_ADDRSTRLEN];
                        inet_ntop( addr->sin_family, &(addr->sin_addr), ip4Address, INET_ADDRSTRLEN );
                        
                        [interfaceInfo setObject:[NSString stringWithUTF8String:interface->ifa_name]
                                          forKey:[NSString stringWithUTF8String:ip4Address]];
                        
                    } } else if ( addr && addr->sin_family == PF_INET6 ) {
                        
                        if ( (family == AddressTypeBoth) || (family == AddressTypeIPv6) ) {
                            char ip6Address[INET6_ADDRSTRLEN];
                            inet_ntop( addr->sin_family, &(addr->sin_addr), ip6Address, INET6_ADDRSTRLEN );
                            
                            [interfaceInfo setObject:[NSString stringWithUTF8String:interface->ifa_name]
                                              forKey:[NSString stringWithUTF8String:ip6Address]];
                        } }
            }
            
        } freeifaddrs( interfaces );
        
    } return [NSDictionary dictionaryWithDictionary:interfaceInfo];
}

#pragma mark - Class Methods:

+ (NSDictionary *) interfaceIP4Addresses { return [self _interfaceAddressesForFamily:AddressTypeIPv4]; }
+ (NSDictionary *) interfaceIP6Addresses { return [self _interfaceAddressesForFamily:AddressTypeIPv6]; }
+ (NSDictionary *) interfaceIPAddresses  { return [self _interfaceAddressesForFamily:AddressTypeBoth]; }

@end
