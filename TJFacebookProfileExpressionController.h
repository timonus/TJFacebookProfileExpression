//
//  TJFacebookProfileExpressionController.h
//  Quotidian
//
//  Created by Tim Johnsen on 12/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJFacebookProfileExpressionController : NSObject

+ (BOOL)canSetProfile;

+ (void)setProfileImage:(UIImage *const)image;
+ (void)setProfileImageData:(NSData *const)imageData;
+ (void)setProfileVideo:(NSString *const)videoPath;

@end

NS_ASSUME_NONNULL_END
