//
//  TKMacro.h
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/28.
//  Copyright © 2017年 beijing. All rights reserved.
//

#ifndef TKMacro_h
#define TKMacro_h
#ifdef DEBUG
#define TKLog(...) NSLog(__VA_ARGS__)
#else
#define TKLog(...) do { } while (0)
#endif

#import <UIKit/UIKit.h>

#define TKMainWindow  [UIApplication sharedApplication].keyWindow

//色值设置
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define UIColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:a])
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]


#define RGBACOLOR_PromptWhite       RGBCOLOR(249, 249, 249)
#define RGBACOLOR_PromptRed         RGBCOLOR(215, 0, 0)
#define RGBACOLOR_PromptYellow      RGBCOLOR(155, 136, 58)
#define RGBACOLOR_PromptYellowDeep  RGBCOLOR(206, 203, 48)
#define RGBACOLOR_PromptBlue        RGBCOLOR(78, 100, 196)

#define RGBACOLOR_teacherTextColor_Red      RGBCOLOR(208, 59, 7)
#define RGBACOLOR_studentTextColor_Yellow   RGBCOLOR(244, 209, 12)
#define RGBACOLOR_ClassBegin_RedDeep        RGBCOLOR(207,65, 21)
#define RGBACOLOR_ClassEnd_Red              RGBCOLOR(121, 69, 67)
#define RGBACOLOR_Title_White               RGBCOLOR(115, 115, 115)
#define RGBACOLOR_RAISEHAND_HOLD            RGBCOLOR(179, 38, 17)

#define RGBACOLOR_ClassBeginAndEnd          UIColorRGB(0xcf4014)
#define RGBACOLOR_muteAudio_Normal          UIColorRGB(0x784442)
#define RGBACOLOR_muteAudio_Select          UIColorRGB(0xd3585e)
#define RGBACOLOR_unMuteAudio_Normal        UIColorRGB(0x375b9e)
#define RGBACOLOR_unMuteAudio_Select        UIColorRGB(0x5068cd)
#define RGBACOLOR_RewardColor               UIColorRGB(0xda7c17)


#define TKFont(s) [UIFont fontWithName:@"PingFang-SC-Light" size:s]

//屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// 状态栏高度
#define StatusH 20
//导航栏高度
#define TKNavHeight 54
//屏幕比例，相对pad 1024 * 768
#define Proportion (ScreenH/768.0)

#define TITLE_FONT TKFont(16)
#define TEXT_FONT TKFont(14)
#define Name_FONT TKFont(15)

#define BUNDLE_NAME @ "Resources.bundle"

#define BUNDLE [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: BUNDLE_NAME]]

#define LOADIMAGE(name) [UIImage imageWithContentsOfFile:[[BUNDLE resourcePath] stringByAppendingPathComponent:name]]

#define LOADWAV(name) [[BUNDLE resourcePath] stringByAppendingPathComponent:name]

#define MTLocalized(s) [BUNDLE localizedStringForKey:s value:@"" table:nil]

#define IS_CH_SYMBOL(chr) ((int)(chr)>127)


#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10_0Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)

#define tk_weakify(var)   __weak typeof(var) weakSelf = var
#define tk_strongify(var) __strong typeof(var) strongSelf = var







#endif /* TKMacro_h */
