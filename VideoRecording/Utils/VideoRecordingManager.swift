//
//  VideoRecordingManager.swift
//  VideoRecording
//
//  Created by Sharon Omoyeni Babatunde on 08/08/2023.
//

import UIKit
import AVKit
import MobileCoreServices

protocol VideoDelegate: AnyObject {
//    func begin
}

class VideoRecordingManager {
    
   
    static let shared = VideoRecordingManager()
    var videoToPass: Data?
    var myPickedVideo: NSURL? = NSURL()
    
    func displayRecorder(controller: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera available")
            
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = controller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            videoPicker.sourceType = .camera
            videoPicker.mediaTypes = [kUTTypeMovie as String]
            videoPicker.allowsEditing = false
            
            controller.present(videoPicker, animated: true)
        } else {
            print("Camera unvailable")
        }
    }
    
    func playVideoSaved(videoURL: NSURL, myView: UIView) {
        if myPickedVideo != nil {
            let player = AVPlayer(url: videoURL as URL)

            let playerLayer = AVPlayerLayer(player: player)
            
            playerLayer.videoGravity = .resizeAspectFill //
            playerLayer.needsDisplayOnBoundsChange = true //
            playerLayer.frame = myView.bounds // 1

            myView.layer.masksToBounds = true // 2
            myView.layer.addSublayer(playerLayer)
            
            player.play()
        }
       
    }
}

/*
 1. In info.plist Add This Privacy:
 (1) Privacy - Camera Usage Description // For Take a video
 (2) Privacy - Microphone Usage Description // For Record a video
 (3) Privacy - Photo Library Additions Usage Description // For Save a video
 2. Import :
 MobileCoreServices
 3. Inherit :
 UTImagePickerControllerDelegate
 VINavigationControllerDelegate
 */
