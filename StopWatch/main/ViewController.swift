//
//  ViewController.swift
//  StopWatch
//
//  Created by Zalkar on 7/9/21.
//

import UIKit
import SnapKit

protocol HomeViewControllerDelegate: AnyObject{
    func didTapButtonMenu()
}

class ViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    private var timeLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = NSTextAlignment.center
        view.font = UIFont.boldSystemFont(ofSize: 73)
        view.text = "00:00:00"
        return view
    }()
    
    private var segment: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Timer", "StopWatch"])
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.index(ofAccessibilityElement: "yes")
        imageView.image = UIImage(named: "stopwatch")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var imageViewSW: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stopwatch2")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private var pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.setImage(UIImage(named: "black_pause"), for: .highlighted)
        button.addTarget(self, action: #selector(pauseTap), for: .touchUpInside)
        return button
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.setImage(UIImage(named: "black_play"), for: .highlighted)
        button.addTarget(self, action: #selector(playTap), for: .touchUpInside)
        return button
    }()
    
    private var playButtonDown: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setImage(UIImage(named: "play"), for: .normal)
        button.setImage(UIImage(named: "black_play"), for: .highlighted)
        button.addTarget(self, action: #selector(playTapDown), for: .touchUpInside)
        return button
    }()
    
    private var stopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stop"), for: .normal)
        button.setImage(UIImage(named: "black_stop"), for: .highlighted)
        button.addTarget(self, action: #selector(stopTap), for: .touchUpInside)
        return button
    }()
    
    private var timerPick: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = true
        return picker
    }()
    
    var timer = Timer()
    
    var isTimerRunning = false //???
    
    var (hours, minutes, seconds) = (0, 0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(systemName:"list.bullet"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(barButtonTaped))
        view.backgroundColor = .systemGray6
      
        
        SetupUI()
        
    }
    
    func SetupUI(){
        
        view.backgroundColor = .systemYellow
        
        timerPick.delegate = self
        timerPick.dataSource = self
        
        stopButton.isEnabled = false
        pauseButton.isEnabled = false
        playButton.isEnabled = true
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(timerPick)
        timerPick.snp.makeConstraints{ (make) in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(view.frame.width / 1.0)
            make.height.equalTo(50)
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(timerPick.snp.top).offset(-100)
            make.width.equalTo(320)
            make.height.equalTo(80)
        }
        
        view.addSubview(segment)
        segment.snp.makeConstraints{ (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(timeLabel.snp.top).offset(-50)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints{ (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(segment.snp.top).offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        view.addSubview(imageViewSW)
        imageViewSW.snp.makeConstraints{ (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(segment.snp.top).offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        view.addSubview(pauseButton)
        pauseButton.snp.makeConstraints{ (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(timerPick.snp.bottom).offset(100)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        view.addSubview(playButton)
        playButton.snp.makeConstraints{ (make) in
            make.left.equalTo(pauseButton.snp.right).offset(30)
            make.top.equalTo(timerPick.snp.bottom).offset(100)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        view.addSubview(playButtonDown)
        playButtonDown.snp.makeConstraints{ (make) in
            make.left.equalTo(pauseButton.snp.right).offset(30)
            make.top.equalTo(timerPick.snp.bottom).offset(100)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        view.addSubview(stopButton)
        stopButton.snp.makeConstraints{ (make) in
            make.right.equalTo(pauseButton.snp.left).offset(-30)
            make.top.equalTo(timerPick.snp.bottom).offset(100)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
    }
    
    @objc func pauseTap(){
        stopButton.isEnabled = true
        pauseButton.isEnabled = false
        playButton.isEnabled = true
        playButtonDown.isEnabled = true
        if segment.selectedSegmentIndex == 0{
            timerPick.isHidden = true
        } else {
            timerPick.isHidden = false
        }
        isTimerRunning = false
        timer.invalidate()
    }
    
    @objc func playTap(){
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            
            stopButton.isEnabled = true
            pauseButton.isEnabled = true
            playButton.isEnabled = false
            timerPick.isHidden = true
        }
    }
    
    @objc func playTapDown(){
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runCountDown), userInfo: nil, repeats: true)
            isTimerRunning = true
            
            stopButton.isEnabled = true
            pauseButton.isEnabled = true
            playButtonDown.isEnabled = false
            timerPick.isHidden = true
        }
    }
    
    @objc func stopTap(){
        timer.invalidate()
        isTimerRunning = false
        (hours, minutes, seconds) = (0, 0, 0)
        timeLabel.text = "00:00:00"
        
        stopButton.isEnabled = false
        pauseButton.isEnabled = false
        playButton.isEnabled = true
        playButtonDown.isEnabled = true
        if segment.selectedSegmentIndex == 0{
            timerPick.isHidden = true
        } else {
            timerPick.isHidden = false
        }
        
    }
    
    @objc func segmentChange(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0{
            timer.invalidate()
            isTimerRunning = false
            (hours, minutes, seconds) = (0, 0, 0)
            timeLabel.text = "00:00:00"
            
            timerPick.isHidden = true
            imageView.isHidden = false
            imageViewSW.isHidden = true
            playButton.isHidden = false
            playButtonDown.isHidden = true
            pauseButton.isEnabled = false
            stopButton.isEnabled = false
            playButton.isEnabled = true

        } else if segment.selectedSegmentIndex == 1{
            timer.invalidate()
            isTimerRunning = false
            (hours, minutes, seconds) = (0, 0, 0)
            timeLabel.text = "00:00:00"
            
            timerPick.isHidden = false
            imageViewSW.isHidden = false
            imageView.isHidden = true
            playButton.isHidden = true
            playButtonDown.isHidden = false
            pauseButton.isEnabled = false
            stopButton.isEnabled = false
            playButtonDown.isEnabled = true
        }
    }
    
    @objc func runTimer(){
        
        seconds += 1
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        if minutes == 60{
            hours += 1
            minutes = 0
        }
        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
        
    }
    
    @objc func runCountDown(){
        var secondsOverAll = hours * 60 * 60 + minutes * 60 + seconds
        secondsOverAll -= 1
        
        hours = secondsOverAll / 3600
        secondsOverAll -= hours * 3600
        minutes = secondsOverAll / 60
        secondsOverAll -= minutes * 60
        seconds = secondsOverAll
        
        if secondsOverAll <= -1 {
            timer.invalidate()
            isTimerRunning = false
            (hours, minutes, seconds) = (0, 0, 0)

            timeLabel.text = "00:00:00"
            stopButton.isEnabled = false
            pauseButton.isEnabled = false
            playButtonDown.isEnabled = true
            timerPick.isHidden = false
        } else {
            timeLabel.text = "\(hours):\(minutes):\(seconds)"
        }
        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            hours = row
            let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
            let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
        } else if component == 1{
            minutes = row
            let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
            let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
        } else if component == 2{
            seconds = row
            let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
            let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
        }
        pickerView.reloadAllComponents()
    }
}

extension ViewController{
    
    @objc func barButtonTaped(){
        delegate?.didTapButtonMenu()
    }
}


