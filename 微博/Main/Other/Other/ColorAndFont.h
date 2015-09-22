//
//  ColorAndFont.h
//  微博
//
//  Created by hjd on 15/9/18.
//  Copyright (c) 2015年 hjd. All rights reserved.
//

#ifndef ___ColorAndFont_h
#define ___ColorAndFont_h

//颜色设置
#define kHomeBg                 Color(241, 245, 247, 1)
#define kWordsColor             Color(0, 0, 0, 1)
#define kWordsDetailColor       Color(146, 146, 146, 1)
#define kWordsNameColor         Color(72, 108, 118, 1)

//字体设置
#pragma mark - FontSize
#define kMaxFontSize            20.f
#define kNavFontSize            17.f
#define kDefaultFontSize        16.f
#define kDetailFontSize         14.f
#define kSmallFontSize          12.f

//图片大小
#define kPicMargin              kMargin/4.f
#define kPicOriginal            kDeviceWidth
#define kPicBmiddle             (kDeviceWidth-2*kMargin-kPicMargin)/2.f
#define kPicThumbnail           (kDeviceWidth-2*kMargin-2*kPicMargin)/3.f

#endif
