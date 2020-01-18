//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by aekachai tungrattanavalee on 17/1/2563 BE.
//  Copyright © 2563 aekachai tungrattanavalee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var btn_record: UIButton!
    @IBOutlet weak var btn_stop: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func btn_record(_ sender: Any) {
        print("record")
        btn_stop.isHidden = false
        btn_record.isHidden = true
        
        recordingLabel.text = "Recording in progress"
       

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func btn_stop(_ sender: Any) {
        recordingLabel.text = "Tap to Record"
        btn_stop.isHidden = true
        btn_record.isHidden = false
        audioRecorder.stop()
        let audioSesion = AVAudioSession.sharedInstance()
        try! audioSesion.setActive(false)
       
       
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording was not successful")
        }
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        btn_stop.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playerVC = segue.destination as! PlayerViewController
            let recordedAudioURL = sender as! URL
            playerVC.recordedAudioURL = recordedAudioURL
        }
    }


}

