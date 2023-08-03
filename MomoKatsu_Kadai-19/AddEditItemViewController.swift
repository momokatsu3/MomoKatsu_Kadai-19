//
//  AddEditItemViewController.swift
//  MomoKatsu_Kadai-16 ⇒ 17 ⇒ 19
//
//  Created by モモカツ on 2023/07/21.
//

import UIKit

class AddEditItemViewController: UIViewController {

    // 当該クラスが遷移元画面で追加モード画面・編集モード画面を区別するための設定
    enum Mode {
        case add, edit
    }
    // mode変数を追加モードに初期化
    var mode: Mode?

    var inputName: String = ""

    // 追加名前入力用テキストフィールド
    @IBOutlet weak var nameTextField: UITextField!

    // セーブボタンを選択した場合
    @IBAction func tapSaveButtonItems(_ sender: Any) {
        inputName = nameTextField.text ?? ""
        //print(inputName)
        performSegue(withIdentifier: "AddEditSegue", sender: nil)
    }

    // キャンセルを選択した場合
    @IBAction func tapCancelButtonItems(_ sender: Any) {
        // モーダル遷移で元に画面遷移
        //（退出させる(dismiss)、アニメーションありで、完了した後の処理なし）
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 遷移元画面から編集モードで遷移した場合
        switch mode {
        case .add:
            break
        case .edit:
            nameTextField.text = inputName
        case nil:
            assertionFailure("mode is nil.")
        }
    }

}
