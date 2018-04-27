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
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var videoPlaceholder: UILabel!
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
    
    
    // !!!!!!!!!!!!!!!
    @IBAction func fullScreenAction(_ sender: UIButton) {
        if fullScreenBtn.isSelected {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIApplication.shared.isStatusBarHidden = false
            self.videoUrlTextField.isHidden = false
            self.searchBtn.isHidden = false
            playerLayer.minimizeToFrame(CGRect(x: 0, y: 0, width: self.view.frame.width, height: 211))
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.isStatusBarHidden = true
            self.videoUrlTextField.isHidden = true
            self.searchBtn.isHidden = true
            playerLayer.goFullscreen(CGRect(x: 0, y: -251.5, width: self.view.frame.width, height: self.view.frame.height))
        }
        fullScreenBtn.isSelected = !fullScreenBtn.isSelected
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
    
    
    // !!!!!!!!!!!!!!!
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if (UIDevice.current.orientation.isLandscape) {
            DispatchQueue.main.async {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.videoUrlTextField.isHidden = true
                self.searchBtn.isHidden = true
                self.videoView.backgroundColor = UIColor.black
                self.timeStartLabel.textColor = UIColor.white
                self.timeEndLabel.textColor = UIColor.white
                self.videoPlaceholder.textColor = UIColor.white
                self.playBtn.setImage(#imageLiteral(resourceName: "play_button").withRenderingMode(.alwaysTemplate), for: .normal)
                self.playBtn.tintColor = .white
                self.forwardBtn.setImage(#imageLiteral(resourceName: "fast_forward").withRenderingMode(.alwaysTemplate), for: .normal)
                self.forwardBtn.tintColor = .white
                self.backwardBtn.setImage(#imageLiteral(resourceName: "rewind").withRenderingMode(.alwaysTemplate), for: .normal)
                self.backwardBtn.tintColor = .white
                self.fullScreenBtn.setImage(#imageLiteral(resourceName: "full_screen_button").withRenderingMode(.alwaysTemplate), for: .normal)
                self.fullScreenBtn.tintColor = .white
                self.volBtn.setImage(#imageLiteral(resourceName: "volume_up").withRenderingMode(.alwaysTemplate), for: .normal)
                self.volBtn.tintColor = .white
                self.view.didAddSubview(self.videoView)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer.frame = self.videoView.bounds
                self.playerLayer.videoGravity = .resize
                self.view.layer.addSublayer(self.playerLayer)
                self.view.reloadInputViews()
            }
            print("Device is landscape")
        } else {
            print("Device is portrait")
            DispatchQueue.main.async {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.videoUrlTextField.isHidden = false
                self.searchBtn.isHidden = false
                self.videoView.backgroundColor = UIColor.clear
                self.timeStartLabel.textColor = UIColor.black
                self.timeEndLabel.textColor = UIColor.black
                self.videoPlaceholder.textColor = UIColor.lightGray
                self.playBtn.setImage(#imageLiteral(resourceName: "play_button").withRenderingMode(.alwaysTemplate), for: .normal)
                self.playBtn.tintColor = .black
                self.forwardBtn.setImage(#imageLiteral(resourceName: "fast_forward").withRenderingMode(.alwaysTemplate), for: .normal)
                self.forwardBtn.tintColor = .black
                self.backwardBtn.setImage(#imageLiteral(resourceName: "rewind").withRenderingMode(.alwaysTemplate), for: .normal)
                self.backwardBtn.tintColor = .black
                self.fullScreenBtn.setImage(#imageLiteral(resourceName: "full_screen_button").withRenderingMode(.alwaysTemplate), for: .normal)
                self.fullScreenBtn.tintColor = .black
                self.volBtn.setImage(#imageLiteral(resourceName: "volume_up").withRenderingMode(.alwaysTemplate), for: .normal)
                self.volBtn.tintColor = .black
                self.playerLayer.removeFromSuperlayer()
                self.playerLayer.frame = self.videoView.bounds
                self.view.reloadInputViews()
            }
        }
    }
    
}


extension CGAffineTransform {
    static let ninetyDegreeRotation = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
}

extension AVPlayerLayer {
    var fullScreenAnimationDuration: TimeInterval {
        return 0.15
    }
    
    func minimizeToFrame(_ frame: CGRect) {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.setAffineTransform(.identity)
            self.frame = frame
        }
    }
    
    func goFullscreen(_ frame: CGRect) {
        UIView.animate(withDuration: fullScreenAnimationDuration) {
            self.setAffineTransform(.ninetyDegreeRotation)
            self.frame = frame
        }
    }
}
































