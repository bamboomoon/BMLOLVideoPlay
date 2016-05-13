//
//  volAndLumView.swift
//  BMLOLVideo
//
//  Created by donglei on 16/5/13.
//  Copyright © 2016年 donglei. All rights reserved.
//
// 音量和亮度调节视图

import UIKit

class volAndLumView: UIView {
    
    internal var volSlider = UISlider() //控制声音
   internal var lumSlider = UISlider() //控制亮度
    
    let leftRightMargin:CGFloat = 20.0
    let topMargin:CGFloat = 50.0


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.5
        self.changeVolView(frame)
        self.changeLightView(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //改变声音的视图 --- 包括 slder 声音图标
    func changeVolView(viewFrame:CGRect) ->  Void{
        //低音量图标
        let lowVolImage = UIImageView.init(image: UIImage.init(named: "fullplayer_voice_low"))
        lowVolImage.frame = CGRectMake(leftRightMargin,topMargin , 22 , 22)
        self.addSubview(lowVolImage)
        
        
        //声音 slider
        volSlider.frame = CGRectMake(lowVolImage.frame.maxX + leftRightMargin,topMargin , viewFrame.size.width - leftRightMargin * 4 - 2 * 22 , 22)
        volSlider.maximumValue = 1.0
        volSlider.addTarget(ViewController(), action: #selector(ViewController.changeVolume), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(volSlider)
        
        //高音量图标
        let hightVolImage = UIImageView.init(image: UIImage.init(named: "fullplayer_voice_high"))
        hightVolImage.frame = CGRectMake(volSlider.frame.maxX + leftRightMargin,topMargin , 22 , 22)
        self.addSubview(hightVolImage)
    }
    
    
    func changeLightView(viewFrame:CGRect) ->  Void{
        let  lightY = topMargin * 2  + 22
        //低高度图标
        let lowLightImage = UIImageView.init(image: UIImage.init(named:"fullplayer_light_low"))
        lowLightImage.frame = CGRectMake(leftRightMargin,lightY  , 22 , 22)
        self.addSubview(lowLightImage)
        
        
        //亮度 slider
        lumSlider.frame = CGRectMake(lowLightImage.frame.maxX + leftRightMargin,lightY , viewFrame.size.width - leftRightMargin * 4 - 2 * 22 , 22)
        lumSlider.addTarget(self, action: #selector(volAndLumView.changeLight), forControlEvents: UIControlEvents.TouchUpInside)
        lumSlider.maximumValue = 1.0
        self.addSubview(lumSlider)
        
        //高亮度图标
        let hightLightImage = UIImageView.init(image: UIImage.init(named: "fullplayer_light_high"))
        hightLightImage.frame = CGRectMake(lumSlider.frame.maxX + leftRightMargin,lightY , 22 , 22)
        self.addSubview(hightLightImage)
    }
    
    
   //改变亮度
    func changeLight() -> Void {
        UIScreen.mainScreen().brightness = CGFloat(self.lumSlider.value)
    }
    
    
    
}
