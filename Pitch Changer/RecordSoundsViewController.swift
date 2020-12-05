//
//  ViewController.swift
//  Pitch Changer
//
//  Created by user on 04/12/2020.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var startRecordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
    }

    @IBAction func startRecording(_ sender: Any) {
        
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: filePath!, settings:[:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            showErrorAlert()
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            showErrorAlert()
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("audio recording not sucssesful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playSoundVC = segue.destination as! PlaySoundsViewController
        let recordedAudioURL = sender as! URL
        playSoundVC.recordedAudioURL = recordedAudioURL
    }
    
    func configureUI(isRecording: Bool) {
        startRecordButton.isEnabled = !isRecording
        stopRecordButton.isEnabled = isRecording
        recordLabel.text = isRecording ? "Recording in progress" : "Tap to record"
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "There is an error.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

