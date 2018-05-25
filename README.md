# TJFacebookProfileExpression

**NOTE: It appears that the profile expression SDK is no longer supported, so this project won't function properly.**

This project is an open source alternative to Facebook's [Profile Expression Kit](https://developers.facebook.com/products/profile-expression-kit), which doesn't seem to be available on their developer portal anymore. It allows you to launch the Facebook app and prompt the user to set their profile photo or video to content from your app.

## Installation

1. Configure the [Facebook Core iOS SDK](https://developers.facebook.com/docs/ios/componentsdks) in your app. (Most importantly for TJFacebookProfileExpression, add your app's Facebook identifier as `FacebookAppID` to your info plist).
2. Add `fb-profile-expression-platform` to your info plist's `LSApplicationQueriesSchemes` array.
3. Include the `TJFacebookProfileExpressionController` `.h` and `.m` files in your project and import `TJFacebookProfileExpressionController.h` wherever you need.

## Usage

- Call `+canSetProfile` to see if the user's Facebook profile can be set.
- Call `+setProfileImage:` or `+setProfileImageData:` to set the user's profile photo.
- Call `+setProfileVideo:` to set the user's profile video.