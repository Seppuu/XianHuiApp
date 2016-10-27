//
//  UIColor+DD .swift
//  DingDong
//
//  Created by Seppuu on 16/3/9.
//  Copyright © 2016年 seppuu. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     导航栏背景色.
     */
    class func navBarColor() -> UIColor {
        return UIColor(red: 200.3/255.0, green: 170.2/255.0, blue: 122.5/255.0, alpha: 1.0)
    }
    
    
    /**
     view背景色
     */
    class func ddViewBackGroundColor() -> UIColor {
        return UIColor(red: 238.1/255.0, green: 239.9/255.0, blue: 245.2/255.0, alpha: 1.0)
    }
    
    /**
     遮罩颜色
     */
    class func ddTintViewColor() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.339358836206897)
    }
    
    
    class func ddCellAccessoryImageViewTintColor() -> UIColor {
        return UIColor.lightGray
    }
    
    /**
     基础蓝色
     */
    class func ddBasicBlueColor() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 118.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    
    class func ddCellSeparatorColor() -> UIColor {
        return UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    
    //MARK: 录音-相册
    class func ddCellBorderColor() -> UIColor {
        return UIColor ( red: 0.0, green: 0.4627, blue: 1.0, alpha: 1.0 )
    }
    
    
    /**
     时间刻度数字颜色
     */
    class func ddRulerLabelColor() -> UIColor {
        return UIColor(red: 168.7/255.0, green: 172.9/255.0, blue: 203.9/255.0, alpha: 1.0)
    }
    
    
    /**
     波形图基本色
     */
    class func ddWaveDefaultColor() -> UIColor {
        return UIColor(red: 191.2/255.0, green: 204.0/255.0, blue: 219.2/255.0, alpha: 1.0)
    }
    /**
     波形图被播放过的颜色
     */
    class func ddWavePlayedColor() -> UIColor {
        return UIColor (red: 255.0/255.0, green: 188.2/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    /**
     录音波形图剪切时,在剪切范围内的颜色
     */
    class func ddWaveTrimmedColor() -> UIColor {
        return UIColor ( red: 0.9874, green: 0.4227, blue: 0.4851, alpha: 1.0 )
    }
    
    /**
     录音波形图剪切时,提示有时刻点在其中的颜色
     */
    class func ddWaveAttachedColor() -> UIColor {
        return UIColor ( red: 1.0, green: 0.7171, blue: 0.0, alpha: 1.0 )
    }
    
    /**
     录音波形图剪切时,提示有文本框时刻点的颜色
     */
    class func ddWaveWithTextTimeColor() -> UIColor {
        return UIColor ( red: 0.3247, green: 0.9932, blue: 0.2525, alpha: 1.0 )
    }
    
    /**
     录音波形图剪切时,提示有图片时刻点的颜色
     */
    class func ddWaveWithImageTimeColor() -> UIColor {
        
        return UIColor ( red: 0.7321, green: 0.2534, blue: 1.0, alpha: 1.0 )
        
    }
    
    
    //MARK: TextView Color
    /**
     文本框背景色
     */
    class func ddTextViewBackColor() -> UIColor {
        
        return UIColor ( red: 0.9406, green: 0.9264, blue: 0.9167, alpha: 1.0 )
        
    }
    
    /**
     文本框边框颜色
     */
    class func ddTextViewBoardColor() -> UIColor {
        
        return UIColor ( red: 1.0, green: 0.7725, blue: 0.8547, alpha: 1.0 )
        
    }
    
    /**
     文本框边框高亮颜色
     */
    class func ddTextViewHighLightColor() -> UIColor {
        
        return UIColor (red: 0.9772, green: 0.7073, blue: 0.0013, alpha: 1.0 )
        
    }
    
    
    /**
     文本编辑框按钮未选中颜色
     */
    class func ddTextEditButtonDeHighLightColor() -> UIColor {
        
        return UIColor ( red: 0.5029, green: 0.5008, blue: 0.5051, alpha: 1.0 )
        
    }
    
    /**
     文本编辑框按钮选中颜色
     */
    class func ddTextEditButtonHighLightColor() -> UIColor {
        
        return UIColor ( red: 0.2952, green: 0.6428, blue: 0.9888, alpha: 1.0 )
        
    }
    
    
    
    /**
     文本编辑栏"颜色"按钮背景色
     */
    class func ddTextEditColorButtonBackColor() -> UIColor {
        
        return UIColor ( red: 0.9264, green: 0.9263, blue: 0.9263, alpha: 1.0 )
        
    }
    
    
    /**
     文本编辑栏所有按钮背景颜色
     */
    class func ddTextEditButtonsBackColor() -> UIColor {
        
        return UIColor ( red: 0.8494, green: 0.8494, blue: 0.8494, alpha: 1.0 )
        
    }
    
    
    class func yepNavgationBarTitleColor() -> UIColor {
        return UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1.0)
    }
    
    
}

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
    
    class func DDRedTextColor() -> UIColor {
        return UIColor ( red: 0.871, green: 0.1177, blue: 0.1881, alpha: 1.0 )
    }
    
    class func DDBlueTextColor() -> UIColor {
        return UIColor ( red: 0.1551, green: 0.392, blue: 0.8671, alpha: 1.0 )
    }
    
    class func DDYellowTextColor() -> UIColor {
        return UIColor ( red: 0.991, green: 0.7971, blue: 0.2134, alpha: 1.0 )
    }
    
    class func DDGreenTextColor() -> UIColor {
        return UIColor ( red: 0.2163, green: 0.6077, blue: 0.2895, alpha: 1.0 )
    }
    
    
}
