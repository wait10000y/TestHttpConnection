//
//  PSProfile.m
//  PaaS
//
//  Created by shiliang.wang on 14-1-17.
//  Copyright (c) 2014年 xor-media. All rights reserved.
//

#import "CommProfile.h"

#import "Common.h"

@implementation CommProfile

@synthesize uData;

static CommProfile *staticProfile;
+(CommProfile*)shareObject
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    staticProfile = [[CommProfile alloc] init];
  });
  return staticProfile;
}

- (id)init
{
  self = [super init];
  if (self) {
    uData = [NSUserDefaults standardUserDefaults];
    [self populateRegistrationDomain];
  }
  return self;
}
  // ================ apples =================
- (void)populateRegistrationDomain
{
  NSURL *settingsBundleURL = [[NSBundle mainBundle] URLForResource:@"Settings" withExtension:@"bundle"];
  
  NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
  [self loadDefaults:appDefaults fromSettingsPage:@"Root.plist" inSettingsBundleAtURL:settingsBundleURL];
  [uData registerDefaults:appDefaults];
  [uData synchronize];
  [self reloadAttribueValue:appDefaults];
}

-(void)reloadAttribueValue:(NSMutableDictionary*)appDefaults
{
  for (NSString* theKey in [appDefaults allKeys]) {
    [self setValue:[uData objectForKey:theKey] forKey:theKey];
  }
}

- (void)loadDefaults:(NSMutableDictionary*)appDefaults fromSettingsPage:(NSString*)plistName inSettingsBundleAtURL:(NSURL*)settingsBundleURL
{
    // Each page of settings is represented by a property-list file that follows
    // the Settings Application Schema:
    // <https://developer.apple.com/library/ios/#documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html>.
  
    // Create an NSDictionary from the plist file.
  NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfURL:[settingsBundleURL URLByAppendingPathComponent:plistName]];
  
  NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
  
  for (NSDictionary *prefItem in prefSpecifierArray){
    NSString *prefItemType = prefItem[@"Type"];
    NSString *prefItemKey = prefItem[@"Key"];
    NSString *prefItemDefaultValue = prefItem[@"DefaultValue"];
    
    if ([prefItemType isEqualToString:@"PSChildPaneSpecifier"]){
      NSString *prefItemFile = prefItem[@"File"];
      [self loadDefaults:appDefaults fromSettingsPage:prefItemFile inSettingsBundleAtURL:settingsBundleURL];
    }else if (prefItemKey != nil && prefItemDefaultValue != nil){
      [appDefaults setObject:prefItemDefaultValue forKey:prefItemKey];
    }
  }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DLog(@"profile NOkey for value %@\n",key);
  return;
}
  // ================ apples =================

-(void)setStringValue:(NSString *)theVaule forKey:(NSString *)theKey
{
  [self setObject:theVaule forKey:theKey];
}

-(void)setIntegerValue:(NSInteger)theVaule forKey:(NSString *)theKey
{
  [self setObject:[NSNumber numberWithInteger:theVaule] forKey:theKey];
}

-(void)setBoolValue:(BOOL)theVaule forKey:(NSString *)theKey
{
  [self setObject:[NSNumber numberWithBool:theVaule] forKey:theKey];
}

-(NSString *)stringValueForKey:(NSString *)theKey
{
  return [uData stringForKey:theKey];
}

-(BOOL)boolValueForKey:(NSString*)theKey
{
  return [uData boolForKey:theKey];
}
-(NSInteger)integerValueForKey:(NSString*)theKey
{
  return [uData integerForKey:theKey];
}


-(void)setObject:(id)theObj forKey:(NSString*)theKey
{
  [self setValue:theObj forKey:theKey];
  [uData setObject:theObj forKey:theKey];
}

-(void)synchronizeData
{
  [uData synchronize];
}

-(void)registerDefaults:(NSDictionary*)theVKs
{
  [uData registerDefaults:theVKs];
}

-(id)objectValueForKey:(NSString*)theKey
{
  return [uData objectForKey:theKey];
}


@end
