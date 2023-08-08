//
//  ViewController.swift
//  VideoRecording
//
//  Created by Sharon Omoyeni Babatunde on 08/08/2023.
//

import UIKit
import AVKit
import MobileCoreServices


class DashboardViewController: UIViewController {
    
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var videoDelegate: VideoRecordingManager?
    var videoList: [VideoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        title = "Video List"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: VideoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: VideoTableViewCell.identifier)
        videoDelegate = VideoRecordingManager.shared
    }
    
    @IBAction func createVideo(_ sender: Any) {
        // instantaite video controller
        //save video
        // reload
        videoDelegate?.displayRecorder(controller: self)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        // If you want use Video here 2

    }
    
    
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func showTextField(textField: UITextView, isHidden: Bool) {
        DispatchQueue.main.async {
           textField.isHidden = isHidden
        }
    }
}

extension DashboardViewController: UITableViewDelegate {
    
}

extension DashboardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Close
        showTextField(textField: textField, isHidden: true)
//        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
                
        else {
            return
        }
        if let pickedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            // Get Video URL
            videoDelegate?.myPickedVideo = pickedVideo as NSURL
            
            do {
                try? videoDelegate?.videoToPass = Data(contentsOf: pickedVideo)
                
                // Calculate duration of the video
                let asset = AVURLAsset(url: pickedVideo)
                let duration = asset.duration
                let durationInSeconds = CMTimeGetSeconds(duration)
                
                let hours = Int(durationInSeconds / 3600)
                let minutes = Int((durationInSeconds / 60).truncatingRemainder(dividingBy: 60))
                let seconds = Int(durationInSeconds.truncatingRemainder(dividingBy: 60))
                
                let durationString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                print("Video Duration: \(durationString)")
                
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths[0]
                let tempPath = documentsDirectory.appendingFormat("/vid.mp4")
                let url = URL(fileURLWithPath: tempPath)
                do {
                    try? videoDelegate?.videoToPass?.write(to: url, options: [])
                }
                
                // If you want to display the video here (Step 1)
            }
        }



        // Handle a movie capture
        //save to filemamnager here
//        UISaveVideoAtPathToSavedPhotosAlbum(
//            url.path,
//            self,
//            #selector(video(_:didFinishSavingWithError:contextInfo:)),
//            nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
