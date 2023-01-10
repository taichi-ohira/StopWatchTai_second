//
//  SecondViewController1.swift
//  StopWatch
//
//  Created by 大平泰地 on 2022/07/14.
//

import UIKit
import RealmSwift

class SecondViewController1: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    
    @IBOutlet var oldResultLabel: UILabel!
    @IBOutlet var table: UITableView!
    
    var songNameArray = [String]()
    let realm = try! Realm()
    var record: Results<Record>!
    

    
    
    
    var recieveValue: Double!
    var text:String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        record = realm.objects(Record.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        table.dataSource = self
        
        table.delegate = self
        record = realm.objects(Record.self)
    

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = record[indexPath.row].time
        /// DateFomatterクラスのインスタンス生成
        let dateFormatter = DateFormatter()
         
        /// カレンダー、ロケール、タイムゾーンの設定（未指定時は端末の設定が採用される）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
         
        /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "yyyy年M月d日(EEEEE) H時m分s秒"
         
        /// データ変換（Date→テキスト）
        let dateString = dateFormatter.string(from: record[indexPath.row].createDay)
        print(dateString)   // "2020年4月25日(土) 16時8分56秒"
        
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(record[indexPath.row])が選ばれました!")
    }
    override func viewWillAppear(_ animated: Bool) {
            self.navigationItem.title = "履歴"
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
