//
//  ViewController.swift
//  MyApp28
//
//  Created by user22 on 2017/10/3.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    var audio:AVAudioPlayer? = nil
    var isPrepare = false
    
    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pre
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(getNotify(_:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
        //
        let url = Bundle.main.url(forResource: "music", withExtension: "mp3")
        do {
        try AVAudioSession.sharedInstance().setCategory( AVAudioSessionCategoryPlayback)
            audio = try AVAudioPlayer(contentsOf: url!)
            if let _ = audio {
                if audio!.prepareToPlay() {
                    //audio?.play()
                    
                    slider.minimumValue = 0
                    slider.maximumValue = Float(audio!.duration)
                    slider.value = 0
                    
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){
                        (timer) in
                        self.ticker(timer: timer)
                    }
                    
                    isPrepare = true
                }else{
                    print("prepare failure")
                }
                
            }else{
                print("audio nil")
            }
            
        }catch{
            
        }
        
        
    }

    func ticker(timer: Timer) {
        if (audio?.isPlaying)! {
            self.slider.value =  Float(audio!.currentTime)
        }
    }
    
    
    @IBAction func skipTo(_ sender: Any) {
        
        if isPrepare {
            audio?.currentTime = TimeInterval(slider.value)
        }
        
    }
    
    @IBAction func playMusic(_ sender: Any) {
        if isPrepare && (!(audio?.isPlaying)!) {
            audio?.play()
        }
    }
    
    
    @IBAction func pauseMusic(_ sender: Any) {
        if isPrepare && (audio?.isPlaying)! {
            audio?.pause()
        }
    }
    
    // 中斷 or 恢復 被通知來此
    @objc func getNotify(_ sender : Notification){
        guard audio != nil else {return}
        
        let type = sender.userInfo?[AVAudioSessionInterruptionTypeKey] as! AVAudioSessionInterruptionType
        switch type {
        case .began:
            print("音樂被中斷開始")
        case .ended:
            print("音樂被中斷恢復")
            if isPrepare {
                audio?.play()
            }else{
                if (audio?.prepareToPlay())! {
                    audio?.play()
                }
            }
        }
        
        
        
    }
    
}

