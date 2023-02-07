//
//  ViewController.swift
//  StopWatch
//
//  Created by Tomoya Tanaka on 2021/06/28.
//

import UIKit
import AVFoundation
import RealmSwift
import UserNotifications

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource  {
    
    //時分秒のデータ
    let dataList = [[Int](0...23), [Int](0...59), [Int](0...59)]
    var timer = Timer()
    var hour: Float = 0.0
    var minuts: Float = 0.0
    var seconds: Float = 0.0
    
    let userDefaults = UserDefaults.standard
    
    
    
    var timeCheck:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleButton.layer.cornerRadius = 50
        circleButton1.layer.cornerRadius = 50
        circleButton2.layer.cornerRadius = 50
        circleButton3.layer.cornerRadius = 10
        circleButton4.layer.cornerRadius = 10
        timeCheck = true
        
        
        let backButton = UIBarButtonItem()
        backButton.title = "戻る"
        navigationItem.backBarButtonItem = backButton
        
        let hStr = UILabel()
        hStr.text = "時間"
        hStr.sizeToFit()
        hStr.frame = CGRect(x: testPickerView.bounds.width/4 ,
                            y: testPickerView.bounds.height/2 - (hStr.bounds.height/2),
                            width: hStr.bounds.width, height: hStr.bounds.height)
        testPickerView.addSubview(hStr)
        
        //「分」のラベルを追加
        let mStr = UILabel()
        mStr.text = "分"
        mStr.sizeToFit()
        mStr.frame = CGRect(x: testPickerView.bounds.width/2 + mStr.bounds.width,
                            y: testPickerView.bounds.height/2 - (mStr.bounds.height/2),
                            width: mStr.bounds.width, height: mStr.bounds.height)
        testPickerView.addSubview(mStr)
        
        
        //「秒」のラベルを追加
        let sStr = UILabel()
        sStr.text = "秒"
        sStr.sizeToFit()
        sStr.frame = CGRect(x: testPickerView.bounds.width*3/4 + sStr.bounds.width*3,
                            y: testPickerView.bounds.height/2 - (sStr.bounds.height/2),
                            width: sStr.bounds.width, height: sStr.bounds.height)
        testPickerView.addSubview(sStr)
        
        testPickerView.delegate = self
        testPickerView.dataSource = self
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.getTime), name: Notification.Name(rawValue: "TestNotification"), object: nil)
        
        let center = UNUserNotificationCenter.current()
        
        // 通知の使用許可をリクエスト
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
    }
    
    
    //これはがアプリが再開した時にアプリを閉じていた時間の分だけ経っているようにしたり、通知したい時間を保存したりするメソッド
    func getTime() {
        var timeDiff: Double!
        
        
        let nowDate: Date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //保存している、前回アプリを閉じたときの時刻。
        //前回アプリを閉じた時の時刻を取ってくる
        let strDate  = userDefaults.object(forKey: "appclosedtime")
    
        
        //  var date = nowDate.timeIntervalSince(restartDate!)
        
        
        //ここで差分を計算！
        
        //if let の中身は、倉庫に値がある時。
        if let strDateAru = strDate {
            print("閉じた時刻",strDateAru)
            print("今の時間",nowDate)
            timeDiff = nowDate.timeIntervalSince(strDateAru as! Date)
            print("データあったよ！")
            print("閉じている時間",timeDiff)
            count += Float(timeDiff)
            userDefaults.removeObject(forKey: "appclosedtime")
        } else {
            print("データない！！")
        }
        //通知したい時間を保存する
        let dateFormatter = DateFormatter()
        let date = Date()
        let date2 = Date(timeInterval: TimeInterval(hour + minuts + seconds), since: date) // 通知したい時間
        print(date2)
//        let targetDate = Calendar.current.dateComponents(
//            [.year, .month, .day, .hour, .minute],
//            from: date2)
        userDefaults.set(date2, forKey: "targetDate")
    
        
        
        let dateString = dateFormatter.string(from: date2)
              print(dateString)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBOutlet var circleButton: UIButton!
    @IBOutlet var circleButton1: UIButton!
    @IBOutlet var circleButton2: UIButton!
    @IBOutlet var circleButton3: UIButton!
    @IBOutlet var circleButton4: UIButton!
    @IBOutlet weak var testPickerView: UIPickerView!
    let realm = try! Realm()
    
    
    
    
    
    @IBOutlet var label: UILabel!
    
    
    
    // 結果表示用ラベル
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var oldResultLabel: UILabel!
    @IBOutlet var switchlabel: UILabel!
    @IBOutlet var soundswitchlabel: UILabel!
    @IBOutlet var fiveswitchlabel: UILabel!
    @IBOutlet var progresslabel: UILabel!
    @IBOutlet var threeswitchlabel: UILabel!
    @IBOutlet var tenswitchlabel: UILabel!
    var ledmode: Bool! = false
    var soundmode: Bool! = false
    var fivemode: Bool! = false
    var threemode: Bool! = false
    var fivenow: Bool! = false
    var tenmode: Bool! = false
    var timermode: Bool! = false
    // now = 0　なし
    //now = 1　5分モードで鳴らす
    //now = 2 ピッカービューで鳴らす
    var now: Int = 0
    var timerCount: Float = 0.0
    
    
    
    let timerSoundPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "timer")!.data)
    
    
    var count: Float = 0.0
    
    
    //プログレスバー
    @IBOutlet weak var testLabel: UILabel! //ラベル
    
    @IBOutlet weak var testProgressView: UIProgressView! //プログレスビュー
    
    //イベントメソッド
    @IBAction func clickButton () {
        
        
        //ラベルに進捗率を表示する。
        testLabel.text = "\(Int(testProgressView.progress * 100))%完了"
    }
    
    @IBAction func syoukyo() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    @IBAction func start() {
        if !timer.isValid {
            userDefaults.removeObject(forKey: "appclosedtime")
            var targetDate: Date!
            var nowData: Date = Date()
         //   targetDate = nowData +
            
            var targettime =  userDefaults.object(forKey: "targetDate") as! Date
    //        let strDate = formatter.date(from: targettime) // 2020-05-04 11:16:31
            print("🕞:", targettime)
            
            let content = UNMutableNotificationContent()
                    content.title = "タイマー"
                    content.body = "時間になりました"
                    content.sound = UNNotificationSound.default
            

    //        print(userDefaults.object(forKey: "targetDate"))
            
            let targetDateComponent = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
         from: targettime)

            let trigger = UNCalendarNotificationTrigger.init(dateMatching:targetDateComponent , repeats: false)
            let request = UNNotificationRequest(identifier: "Time Interval",
                                                                 content: content,
                                                                 trigger: trigger)
            // 通知の登録
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
            // タイマーが動作していなかったら動かす
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(self.up),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    
    @IBAction func stop() {
        if timer.isValid {
            // タイマーが動作していたら停止する
            timer.invalidate()
            
            //音を止める
            timerSoundPlayer.stop()
        }
        ledFlash(false)
        
        progresslabel.text = "0時間0分0秒"
        
        
        
        // 保存データ（インスタンス）を作成（ひとつめ）
        let instanceHistory1: Record = Record()
        instanceHistory1.createDay = Date()
        instanceHistory1.time = label.text!
        try!realm.write {
            realm.add(instanceHistory1)
        }
        
    }
    
    @IBAction func reset() {
        if timer.isValid {
            // タイマーが動作していたら停止する
            timer.invalidate()
            
            timerSoundPlayer.stop()
            ledFlash(false)
        }
        
        
        label.text = "0時間0分0秒"
        
        count = 0
        
        
        testProgressView.progress = 0
        progresslabel.text = "0時間0分0秒"
        
    }
    
    @IBAction func rireki() {
        self.performSegue(withIdentifier: "toSecondViewController1", sender: nil)
    }
    
    
    
    
    @objc func up() {
        // countを0.01足す
        count = count + 1
        if count >= 5.0 {
            timeCheck = false
        }
        
        print(count)
        // ラベルに小数点以下2桁まで表示
        label.text = String(format:"\(Int(count)/3600)時間\((Int(count)%3600)/60)分\(Int(count)%60)秒")
        print("count1: ", count)
        
        //現在の進捗にタイマーの時間を加算する。
        if count >= 0 && count<=hour + minuts + seconds {
            testProgressView.setProgress(testProgressView.progress + hour + minuts + seconds, animated: true)
        }
        
        
        
        if fivemode {
            
            if count.remainder(dividingBy: 300) >= 0 && count.remainder(dividingBy: 300)<=5  && count >= 5 {
                now = 1
                if soundmode == true && timeCheck == false {
                    timerSoundPlayer.play()
                    print("sound1")
                }
                
                if ledmode == true && timeCheck == false {
                    ledFlash(true)
                    print("led1")
                }
                
            }
            else if now == 1 {
                now = 0
                timerSoundPlayer.stop()
                ledFlash(false)
                print("ledoff2")
            }
            print(count.remainder(dividingBy: 300))
            
            
        }
        
        
        if count >= hour + minuts + seconds && count <= hour + minuts + seconds + 5 {
            now = 2
            if ledmode == true && timeCheck == false {
                ledFlash(true)
                print("led2")
            }
            if soundmode == true && timeCheck == false {
                timerSoundPlayer.play()
                print("sound2")
            }
        }
        else if now == 2 {
            now = 0
            timerSoundPlayer.stop()
            ledFlash(false)
            print("ledoff2")
        }
        
        if threemode {
            
            if count.remainder(dividingBy: 180) >= 0 && count.remainder(dividingBy: 180)<=5  && count >= 5 {
                now = 3
                if soundmode == true && timeCheck == false {
                    timerSoundPlayer.play()
                    print("sound1")
                }
                
                if ledmode == true && timeCheck == false {
                    ledFlash(true)
                    print("led1")
                }
                
            }
            else if now == 3 {
                now = 0
                timerSoundPlayer.stop()
                ledFlash(false)
                print("ledoff2")
            }
            print(count.remainder(dividingBy: 300))
        }
        
        
        
        
        
        if tenmode {
            
            if count.remainder(dividingBy: 600) >= 0 && count.remainder(dividingBy: 600)<=5  && count >= 5 {
                now = 4
                if soundmode == true && timeCheck == false {
                    timerSoundPlayer.play()
                    print("sound1")
                }
                
                if ledmode == true && timeCheck == false {
                    ledFlash(true)
                    print("led1")
                }
                
            }
            else if now == 4 {
                now = 0
                timerSoundPlayer.stop()
                ledFlash(false)
                print("ledoff2")
            }
            print(count.remainder(dividingBy: 300))
        }
        
        if timeCheck {
            now = 5
            timerSoundPlayer.stop()
            ledFlash(false)
            print("ok")
        }
        
        getTime()
    }
    
    
    func ledFlash(_ flg: Bool) {
        guard let avDevice = AVCaptureDevice.default(for: .video) else { return }
        if avDevice.hasTorch {
            do {
                try avDevice.lockForConfiguration()
                avDevice.torchMode = flg ? .on : .off
                avDevice.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList[component].count
    }
    //サイズを返すメソッド
    func pickerView(pickerView: UIPickerView, widthForComponent component:Int) -> CGFloat {
        return testPickerView.bounds.width * 1/4
        
    }
    
    //データを返すメソッド
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = String(dataList[component][row])
        print(dataList[component][row])
        return pickerLabel
        
    }
    
    @IBAction func testUISwitch(sender: UISwitch) {
        if ( sender.isOn ) {
            switchlabel.text = "光"
            ledmode = true
            
        }
        else {
            switchlabel.text = "光"
            ledmode = false
        }
    }
    
    @IBAction func soundUISwitch(sender: UISwitch) {
        if ( sender.isOn ) {
            soundswitchlabel.text = "音"
            soundmode = true
            
        }
        else {
            soundswitchlabel.text = "音"
            soundmode = false
            
            
        }
    }
    @IBAction func fiveUISwitch(sender: UISwitch) {
        if (sender.isOn) {
            fivemode = true
            fiveswitchlabel.text = "５分ごと"
        }
        else {
            fiveswitchlabel.text = "５分ごと"
            fivemode = false
        }
        
        
    }
    
    @IBAction func threeUISwitch(sender: UISwitch) {
        if (sender.isOn) {
            threemode = true
            threeswitchlabel.text = "３分ごと"
        }
        else {
            threeswitchlabel.text = "３分ごと"
            threemode = false
        }
    }
    
    @IBAction func tenUISwitch(sender: UISwitch) {
        if (sender.isOn) {
            tenmode = true
            tenswitchlabel.text = "10分ごと"
        }
        else {
            tenswitchlabel.text = "10分ごと"
            tenmode = false
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView {
            return String(dataList[component][row])
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondViewController1" {
            let nextVC = segue.destination as! SecondViewController1
            nextVC.text = label.text
        }
    }
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        print("時間:",dataList[0][pickerView.selectedRow(inComponent: 0)])
        print("分:",dataList[1][pickerView.selectedRow(inComponent: 1)])
        print("秒:",dataList[2][pickerView.selectedRow(inComponent: 2)])
        progresslabel.text = String(dataList[0][pickerView.selectedRow(inComponent: 0)]) + "時間" + String(dataList[1][pickerView.selectedRow(inComponent: 1)]) + "分" + String(dataList[2][pickerView.selectedRow(inComponent: 2)]) + "秒"
        hour = Float(dataList[0][pickerView.selectedRow(inComponent: 0)] * 3600)
        minuts = Float(dataList[1][pickerView.selectedRow(inComponent: 1)] * 60)
        seconds = Float(dataList[2][pickerView.selectedRow(inComponent: 2)])
        
        if hour == 0 && minuts == 0 && seconds == 0 {
            timeCheck = true
        }
        
    }
    
    final class UserNotificationUtil: NSObject, UNUserNotificationCenterDelegate {
        
        static var shared = UserNotificationUtil()
        private var center = UNUserNotificationCenter.current()
        
        func initialize() {
            center.delegate = UserNotificationUtil.shared
        }
    }
}
