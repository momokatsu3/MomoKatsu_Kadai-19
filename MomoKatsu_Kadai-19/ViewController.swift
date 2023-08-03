//
//  ViewController.swift
//  MomoKatsu_Kadai-16 ⇒ 17 ⇒ 19
//  Part16 ⇒ Part17 ⇒ Part19 チェックリストの保存・読み込み機能を追加する（NSUserDefaults）
//  Created by モモカツ on 2023/07/21.（Part16・17からの機能追加版）

import UIKit

class ViewController: UIViewController {

    // UserDefaults用キー設定
    let itemUserDefaultKey = "ItemValueKey"    // 課題１９の追加分**********

    // 編集用インデックスパスnadoを設定
    private var editSelectedIndexPath: IndexPath?

    // テーブルビューとのインスタンス変数設定（？？）
    @IBOutlet weak var tableView: UITableView!

    // 構造体を設定
    struct ItemValue: Codable {     // 課題１９の追加分**********
        var name: String
        var check: Bool
    }
    // 表示する値を構造体で設定
    var selectItems:[ItemValue] = []

     override func viewDidLoad() {
        super.viewDidLoad()
        // テーブルビュー表示内容
        selectItems = [
            ItemValue(name: "りんご", check: false),
            ItemValue(name: "みかん", check: true),
            ItemValue(name: "バナナ", check: false),
            ItemValue(name: "パイナップル", check: true),
        ]

         // ユーザーデフォルトをロードする
         loadSelectItems()  // 課題１９の追加分**********
    }


    // 課題１９の追加分
    // ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    // ユーザーデフォルトをロード
    //UserDefaultsから Data 型として取得し、構造体に変換し直す
    func loadSelectItems() {
        // `JSONDecoder` で `Data` 型を自作した構造体へデコードする
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: itemUserDefaultKey),
              //let dataModel = try? jsonDecoder.decode(ItemValue.self, from: data) else {
              let _ = try? jsonDecoder.decode(ItemValue.self, from: data) else {
            //print("loadSelectItems実施後のselectItems：", selectItems)
            return
        }
    }

    //ユーザーデフォルトに保存
    //構造体をUserDefaultsに追加する
    func saveSelectItems(selectItems: [ItemValue]) {
        // `JSONEncoder` で `Data` 型へエンコードし、UserDefaultsに追加
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(selectItems) else {
            return
        }
        //print("saveSelectItems実施後のselectItems：", selectItems)
        UserDefaults.standard.set(data, forKey: itemUserDefaultKey)
    }
    // ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


    // AddEditItemViewController で新規登録する内容のテキストフィールド値を追加・テーブルビュー再描画
    @IBAction func inputNameTextField(unwindSegue: UIStoryboardSegue) {

        guard let addEditItemVC = unwindSegue.source as? AddEditItemViewController else { return }

        //print("選択モード：", addEditItemVC.mode as Any)
        // AddEditItemViewController で追加した内容を表示
        //print("追加内容：'", addEditItemVC.inputName as Any, "'")

        // 追加・編集モードの処理
        switch addEditItemVC.mode {
        case .add:
            selectItems.append(ItemValue(name: addEditItemVC.inputName, check: false))
        case .edit:
            selectItems[editSelectedIndexPath!.row].name = addEditItemVC.inputName
        case nil:
            assertionFailure("mode is nil.")
        }
        //テーブルを再描画
        tableView.reloadData()
        //ユーザーデフォルトに保存
        saveSelectItems(selectItems: selectItems)   // 課題１９の追加分**********
    }

    // performSegueで遷移した編集画面の内容を処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // 画面遷移する際の segue.identifier を確認
        //print("選択seghue：", segue.identifier as Any)

        if let addEditItemVC = segue.destination as? AddEditItemViewController {

            switch segue.identifier ?? "" {
            case "AddSegue" :
                // 遷移先画面を追加モードに設定
                addEditItemVC.mode = AddEditItemViewController.Mode.add
                break
            case "EditSegue" :
                // 遷移先画面を編集モードに設定
                addEditItemVC.mode = AddEditItemViewController.Mode.edit
                guard let indexPath = sender as? NSIndexPath else { break } //NSIndexPathでエラーの可能性がある
                addEditItemVC.inputName = selectItems[indexPath.row].name
                //print(addEditItemVC.inputName as Any, selectItems[indexPath.row].name, selectItems[indexPath.row].check)
                break
            default:
                break;
            }
        }
        
    }

}


// ストリーボードの TableView と ViewController を Delegate で紐付けするが必要。
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    // テーブルビューに表示するセルの生成（データを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される））
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //セルを取得する
        let cell = UITableViewCell(style: .default, reuseIdentifier: "selectCell")
        // アクセサリに「DetailButton」を指定する場合
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton

        // 選択テーブルビュー位置を表示
        //print("indexPath=", indexPath)

        // チェックマークを"true"の場合付ける
        if selectItems[indexPath.row].check {
            cell.imageView!.image = UIImage(named: "check")
        } else {
            cell.imageView!.image = UIImage(named: "nocheck")
        }

        cell.textLabel!.text = selectItems[indexPath.row].name
        return cell
    }

    // テーブルビューに表示するデータ個数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        //print("データ個数：", selectItems.count)
        return selectItems.count
    }

    // didSelectRowAtでセルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // チェックマークを反転
        selectItems[indexPath.row].check.toggle()
        //print("チェックマーク：", selectItems[indexPath.row].check, ",   名 前：", selectItems[indexPath.row].name)

        // TableView の特定の行だけをリロード
        self.tableView.reloadRows(at: [indexPath], with: .fade)//automatic) .none)
        //ユーザーデフォルトに保存
        saveSelectItems(selectItems: selectItems)   // 課題１９の追加分**********
    }

    //各indexPathのcellのアクセサリボタンがタップされた際の処理
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        editSelectedIndexPath = indexPath
        // selectedEditIndexPathを使用して "EditSegue"を呼び出す
        performSegue(withIdentifier: "EditSegue", sender: indexPath)

        //print("accessory button was tapped")
        // 選択テーブルビュー位置を表示
        //print("indexPath=", indexPath)

    }

    // テーブルビューのセルをスワイプアクションで削除ボタンの実装
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectItems.remove(at: indexPath.row) // 先にリストから削除する
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //ユーザーデフォルトに保存
            saveSelectItems(selectItems: selectItems)   // 課題１９の追加分**********
        }
    }
}
