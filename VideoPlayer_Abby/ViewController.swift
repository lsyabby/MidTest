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
    @IBOutlet weak var searchBtn: UIButton!
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
        searchBtn.layer.cornerRadius = 5
        searchBtn.layer.borderWidth = 1
        searchBtn.layer.borderColor = UIColor.lightGray.cgColor
        playSlider.tintColor = UIColor.purple
        playSlider.value = 0
        
//        let url = URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4")!
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
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resize
        videoView.layer.addSublayer(playerLayer)
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
 
    @IBAction func playSliderAction(_ sender: UISlider) {
        player.seek(to: CMTimeMake(Int64(sender.value*1000), 1000))
    }
    
    @IBAction func muteAction(_ sender: UIButton) {
        if volBtn.isSelected {
            player.isMuted = false
        } else {
            player.isMuted = true
        }
        volBtn.isSelected = !volBtn.isSelected
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.timeEndLabel.text = getTimeString(from: player.currentItem!.duration)
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes, seconds])
        }
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else { return }
            self?.playSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.playSlider.minimumValue = 0
            self?.playSlider.value = Float(currentItem.currentTime().seconds)
            self?.timeStartLabel.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
}



































