//
//  LoginFormController.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 27/07/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {
    
    @IBOutlet weak var loginInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //получаем текст логина
        let login = loginInput.text!
        // получаем пароль
        let password = passwordInput.text!
        
        //проверяем верны ли
        if login == "admin" && password == "123456" {
            print("Успешная авторизация")
        } else {
            print("Неуспешная авторизация")
        }
    }
    
    //жест нажатия к UIScrollView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // присвоим его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    //подписаться на сообщения из центра уведомлений, которые рассылает клавиатура
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Второе - когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //от уведомлений надо отписываться, когда они не нужны. Добавим метод отписки при исчезновении контроллера с экрана
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets 
    }
    
    
    
    //Добавим исчезновение клавиатуры при клике по пустому месту на экране и метод, который будет вызываться при клике.
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    //метод проверки ввода логина и пароля при нажатии на кнопку Войти
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //проверка данных
        let checkResult = checkUserData()
        
        //ошибка, если данные не верны
        if !checkResult {
            showLoginError()
        }
        
        //возвращаем результат
        return checkResult
    }
    
    func checkUserData() -> Bool {
        guard let login = loginInput.text,
            let password = passwordInput.text else { return false }
        
        if login == "admin" && password == "123456" {
            return true
        } else {
            return false
        }
    }
    
    func showLoginError() {
        //сообщаем если введенные данные не верны, создаем контроллер
        let alert = UIAlertController(title: "Ошибка", message: "Неверные данные пользователя", preferredStyle: .alert)
        //создаем кнопку
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //добавляем кнопку для алерта на контроллер
        alert.addAction(action)
        // показываем контроллер
        present(alert, animated: true, completion: nil)
        
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
