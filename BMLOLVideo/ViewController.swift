//
//  ViewController.swift
//  BMLOLVideo
//
//  Created by donglei on 16/5/12.
//  Copyright © 2016年 donglei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    var scrrenWidth : CGFloat! =  UIScreen.mainScreen().bounds.size.width
    var scrrenHeight : CGFloat! = UIScreen.mainScreen().bounds.size.height
    let topViewAndBottomViewWidth : CGFloat = 64.0
    
    
    
    let topView : UIView = UIView()
    let backBtn  = UIButton()  //上部视图中的返回按钮
    let setBtn = UIButton() //设置按钮
    
    
    
    let bottomView :UIView = UIView()
    let playOrPuseBtn = UIButton()
     let currentTimeLabel = UILabel()
    let toalTimeLabel = UILabel() //总时长
    let sliderView = UISlider() //滚动条
    
    var voview:volAndLumView!
    let VOLANDLUMWIDTH:CGFloat = 300.0
   
    
    
    var player : AVPlayer? //播放器
    var playItem :AVPlayerItem! //item
    
    var isHiddleView :Bool = false
    
    var timer:NSTimer?  //定时关闭上下视图
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.automaticallyAdjustsScrollViewInsets = false
        self.sliderView.addTarget(self, action: #selector(ViewController.dragSlider), forControlEvents: UIControlEvents.TouchUpInside)
    
        
        let url = NSURL(string:"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4")
        playItem = AVPlayerItem(URL:url!)
        
        
    
        playItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        
        player = AVPlayer(playerItem:playItem)
       
        weak var  replaceSelf = self
        //改变当前时间 和 进度条 每秒调用一次
        self.player?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue(), usingBlock: { (time :CMTime ) in
            //改变当前时间
            let currentSecond =    Int(time.seconds)
            let min = currentSecond / 60
            let second = currentSecond % 60
            replaceSelf!.currentTimeLabel.text = String.init(format: "%02d:%02d",min,second )
            
            //更新进度条
            replaceSelf!.sliderView.value = Float(time.seconds)
        })
        let playerLayer = AVPlayerLayer(player:player)
        playerLayer.frame = CGRectMake(0,0,scrrenHeight,scrrenWidth)
        playerLayer.videoGravity  = AVLayerVideoGravityResize
        self.view.layer.addSublayer(playerLayer)
        
        //上下控制面板
        self.crateTopView()
        self.createBottomView()
        

    
        /// 控制声音和亮度的视图
        let VOLANDLUMX:CGFloat = scrrenHeight - VOLANDLUMWIDTH
        voview = volAndLumView.init(frame: CGRectMake(VOLANDLUMX,0, 300, scrrenWidth))
        voview.hidden = true
        self.view.addSubview(voview)
        self.player?.play() //一进来就自动播放
        
         timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(ViewController.timeHiddenTopBottomView), userInfo: nil, repeats: false)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      //更新状态栏
       isHiddleView = !isHiddleView
       self.setNeedsStatusBarAppearanceUpdate()
    

        
        if voview.hidden == false { //声音视图已经显示
            voview.hidden = true
            
        }else {    //更新上下视图
            topView.hidden = !topView.hidden
            bottomView.hidden = !bottomView.hidden
        }
        
        if bottomView.hidden == false || voview.hidden == false{ //只要有一个没有隐藏，就开启计时器
             timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.timeHiddenTopBottomView), userInfo: nil, repeats: false)
        }
        

    }
    
   
//向右横屏
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeRight
    }
    //设置状态栏是否隐藏
    override func prefersStatusBarHidden() -> Bool {
        return isHiddleView
    }
    //设置状态栏颜色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
     //上部的视图
    func crateTopView() -> Void {
        topView.frame = CGRectMake(0, 0, scrrenHeight, topViewAndBottomViewWidth)
        topView.backgroundColor = UIColor.blackColor()
        topView.alpha = 0.7
//        topView.addObserver(self, forKeyPath: "hidden", options: NSKeyValueObservingOptions.New, context: nil)
        self.view.addSubview(topView)
       
        //返回按钮
        backBtn.frame = CGRectMake(20,20,44,44);
        backBtn.setBackgroundImage(UIImage.init(named: "fullplayer_icon_back"), forState: UIControlState.Normal)
        topView.addSubview(backBtn)
        
        
        //设置按钮
        setBtn.frame = CGRectMake(scrrenHeight - 20-44 ,20 , 44, 44)
        setBtn.setBackgroundImage(UIImage.init(named: "fullplayer_icon_setting"), forState: UIControlState.Normal)
        setBtn.addTarget(self, action: #selector(ViewController.setBtnClicked), forControlEvents: UIControlEvents.TouchDown) //设置按钮点击事件
        topView.addSubview(setBtn)
    }
    
    //下部的视图
    func createBottomView() -> Void {
        
        bottomView.frame = CGRectMake(0, scrrenWidth - topViewAndBottomViewWidth, scrrenHeight, topViewAndBottomViewWidth)
        bottomView.alpha = 0.7
        bottomView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(bottomView)
        
        
        //播放/暂停按钮
        playOrPuseBtn.frame = CGRectMake(20,10, 44, 44)
        playOrPuseBtn.setBackgroundImage(UIImage.init(named: "fullplayer_icon_play"), forState: UIControlState.Selected)
        playOrPuseBtn.setBackgroundImage(UIImage.init(named: "fullplayer_icon_pause"), forState: UIControlState.Normal)
        playOrPuseBtn.addTarget(self, action: #selector(ViewController.playOrPauseBtnClicked(_:)) , forControlEvents: UIControlEvents.TouchDown)
        bottomView.addSubview(playOrPuseBtn)
        
        //当前时间 label
        print(playOrPuseBtn.frame.maxX + 20,playOrPuseBtn.frame.origin.y)
        currentTimeLabel.frame = CGRectMake(playOrPuseBtn.frame.maxX + 20, playOrPuseBtn.frame.origin.y, 64, 44)
        currentTimeLabel.text = "00:00"
        currentTimeLabel.textColor = UIColor.whiteColor()
        bottomView.addSubview(currentTimeLabel)
        
        
        //进度滚动条
        sliderView.frame = CGRectMake(currentTimeLabel.frame.maxX,playOrPuseBtn.frame.origin.y ,scrrenHeight - 44 * 4 - 20 * 6 , 44)
        sliderView.value = 0.0
        sliderView.tintColor = UIColor.orangeColor()
        bottomView.addSubview(sliderView)
        
        //总时长 laebl
        toalTimeLabel.frame = CGRectMake(sliderView.frame.maxX + 20, playOrPuseBtn.frame.origin.y, 64, 44)
//        print(String.init(stringInterpolationSegment: self.player?.currentItem?.duration.seconds ),self.player?.currentItem?.duration.seconds)
        toalTimeLabel.text = "00:00"
        toalTimeLabel.textColor = UIColor.lightGrayColor()
        bottomView.addSubview(toalTimeLabel)
        
    }
    
    
    //设置按钮点击事件
    func setBtnClicked() -> Void {
        voview.hidden = !voview.hidden
        topView.hidden = true
        bottomView.hidden = true

    }
    
    //播放暂停按钮点击事件
    func playOrPauseBtnClicked(btn:UIButton) -> Void {
        if (self.player!.rate == 1.0) { //正在播放
            self.player?.pause()
           
        }else {
            self.player?.play()
        }
           btn.selected = !btn.selected
    }
    
    
    //设置播放总时间
    override func  observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            print(change?.keys)
            let  status  =  change!["new"]  as! Int
            if status == 1 {  //准备播放设置总时间
                
                let totalTime = Int((self.player?.currentItem?.duration.seconds)!)
                sliderView.maximumValue = Float((self.player?.currentItem?.duration.seconds)!)  //设置拖动条的最大值
                let min =   totalTime / 60  //分钟
                let second = totalTime % 60  //秒数
                toalTimeLabel.text = String.init(format: "%02d:%02d",min,second )
            }
        }
        
        
      

    }
    
//    deinit{
//        self.playItem.removeObserver(self, forKeyPath: "status")
//    }

    //快进/快退
    func dragSlider() -> Void {
        self.player?.seekToTime(CMTimeMake(Int64(self.sliderView.value), 1))
    }
    
    //改变声音
    func changeVolume() -> Void {
        self.player?.volume =    self.voview.volSlider.value
    }
    
    
    func timeHiddenTopBottomView() -> Void {
        print("隐藏")
        topView.hidden = true
        bottomView.hidden = true
        voview.hidden = true
        self.timer = nil
    }
}

