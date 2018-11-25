//
//  NSString+GQHEncrypt.m
//  Seed
//
//  Created by GuanQinghao on 25/01/2018.
//  Copyright © 2018 GuanQinghao. All rights reserved.
//

#import "NSString+GQHEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (GQHEncrypt)

// 不可逆(加密无解密)
+ (NSString *)qh_encryptMD5WithString:(NSString *)string {
    
    // 转换为UTF8字符串
    const char *cString = [string UTF8String];
    
    // 16位数组
    unsigned char cipher[CC_MD5_DIGEST_LENGTH];
    
    // 系统封装好的加密方法 将UTF8字符串转换成16进制数列(不可逆过程)
    CC_MD5(cString, (CC_LONG)strlen(cString), cipher);
    
    // 32位字符串
    NSMutableString *cipherString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    // 32位16进制字符串
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [cipherString appendFormat:@"%02x",cipher[i]];
    }
    return cipherString;
}

@end
