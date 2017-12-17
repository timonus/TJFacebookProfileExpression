//
//  TJFacebookProfileExpressionController.m
//  Quotidian
//
//  Created by Tim Johnsen on 12/6/17.
//

#import "TJFacebookProfileExpressionController.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation TJFacebookProfileExpressionController

+ (BOOL)canSetProfile
{
    NSAssert([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"LSApplicationQueriesSchemes"] containsObject:@"fb-profile-expression-platform"], @"You must add \"fb-profile-expression-platform\" to your info.plist's value for \"LSApplicationQueriesSchemes\"");
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-profile-expression-platform://"]];
}

+ (void)setProfileImage:(UIImage *const)image
{
    [self setProfileImageData:UIImageJPEGRepresentation(image, 1.0)];
}

+ (void)setProfileImageData:(NSData *const)imageData
{
    [self setProfileData:imageData type:@"com.facebook.image"];
}

+ (void)setProfileVideo:(NSString *const)videoPath
{
    // Using NSDataReadingMappedIfSafe to avoid loading the whole video into memory when hash is created in +setProfileData:type:
    // https://stackoverflow.com/a/7672637/3943258
    [self setProfileData:[NSData dataWithContentsOfFile:videoPath
                                                options:NSDataReadingMappedIfSafe
                                                  error:nil] type:@"com.facebook.video"];
}

+ (void)setProfileData:(NSData *const)data type:(NSString *const)type
{
    NSString *const facebookAppIdentifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookAppID"];
    NSAssert(facebookAppIdentifier.length > 0, @"FacebookAppID must be specified in the app's info plist in order to use %@", NSStringFromClass([self class]));
    if (facebookAppIdentifier.length > 0) {
        [[UIPasteboard generalPasteboard] setData:data forPasteboardType:type];
        NSURLComponents *const components = [[NSURLComponents alloc] initWithString:@"fb-profile-expression-platform://profile"];
        
        // Compute MD5 hash of the data.
        const char *bytes = data.bytes;
        unsigned char *hashBytes = malloc(CC_MD5_DIGEST_LENGTH * sizeof(unsigned char));
        CC_MD5(bytes, (CC_LONG)data.length, hashBytes);
        NSMutableString *const attachmentHash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [attachmentHash appendFormat:@"%02x", hashBytes[i]];
        }
        free(hashBytes);
        
        components.queryItems = @[[NSURLQueryItem queryItemWithName:@"profile" value:@"1"],
                                  [NSURLQueryItem queryItemWithName:@"attachment_type" value:type],
                                  [NSURLQueryItem queryItemWithName:@"app_id" value:facebookAppIdentifier],
                                  [NSURLQueryItem queryItemWithName:@"attachment_hash" value:attachmentHash]];
        NSURL *const url = components.URL;
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
