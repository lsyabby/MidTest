//
//  ViewController.swift
//  VideoPlayer_Abby
//
//  Created by 李思瑩 on 2018/4/27.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoUrlTextField: UITextField!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var volBtn: UIButton!
    @IBOutlet weak var fullScreenBtn: UIButton!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let url = URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4")!
//        let url = URL(string: videoUrlTextField.text!)!
//        player = AVPlayer(url: url)
//
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resize
//
//        videoView.layer.addSublayer(playerLayer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        playerLayer.frame = videoView.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        let url = URL(string: videoUrlTextField.text!)!
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
//        player.play()
    }
    
    
    @IBAction func playAction(_ sender: UIButton) {
        if playBtn.isSelected {
            player.pause()
        } else {
            player.play()
        }
        playBtn.isSelected = !playBtn.isSelected
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 10.0
        if newTime < (CMTimeGetSeconds(duration)-10.0) {
            let time = CMTimeMake(Int64(newTime*1000), 1000)
            player.seek(to: time)
        }
    }
    
    @IBAction func backwardAction(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 10.0
        if newTime < 0 {
            newTime = 0
        }
        let time = CMTimeMake(Int64(newTime*1000), 1000)
        player.seek(to: time)
    }
    
    @IBAction func playSliderAction(_ sender: Any) {
        playSlider.minimumValue = 0
//
//        let duration = pl
    }
 
    
    
}












