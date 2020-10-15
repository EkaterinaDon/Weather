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
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var loginView: UILabel!
    
    @IBOutlet weak var passwordView: UILabel!
    
    @IBOutlet weak var authButton: UIButton!
    
    

    
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
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    //жест нажатия к UIScrollView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // присвоим его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        loginInput.text = "admin"
        passwordInput.text = "123456"
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)

        
        animateTitleAppearing()
        animateFieldsAppearing()
        animateAuthButton()
        
    }
    
    //подписаться на сообщения из центра уведомлений, которые рассылает клавиатура
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Второе - когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //делаем увет navigation прозрачным чтобы установить свои обои
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    //от уведомлений надо отписываться, когда они не нужны. Добавим метод отписки при исчезновении контроллера с экрана
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //возвращаем цвет navigation bar to default для следующих экранов
           navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
           navigationController?.navigationBar.shadowImage = nil
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
    
    
    
    // MARK: - Animation
    
    
   //заголовка Weather создадим пружинную анимацию, будто он опускается немного ниже своего конечного местоположения, а затем возвращается к нему.
    func animateTitleAppearing() {
        

        self.titleView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height / 2)

        let animator = UIViewPropertyAnimator(duration: 1,
                                              dampingRatio: 0.5,
                                              animations: {
                                                  self.titleView.transform = .identity
        })

        animator.startAnimation(afterDelay: 1)
    }
//Для полей ввода применим анимацию постепенного появления и будем использовать анимации слоя.
    func animateFieldsAppearing() {
        
        //вычисляем расстояние по у для трансформации
        let offset = abs(self.loginView.frame.midY - self.passwordView.frame.midY)
                
        self.loginView.transform = CGAffineTransform(translationX: 0, y: offset)
        self.passwordView.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        // keyframe-анимация, перемещение в сторону и вниз, и на исходное положение
        UIView.animateKeyframes(withDuration: 1,
                                delay: 1,
                                options: .calculationModeCubicPaced, //равномерная, с плавными поворотами
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
             self.loginView.transform = CGAffineTransform(translationX: 150, y: 50)
             self.loginView.transform = CGAffineTransform(translationX: -150, y: -50)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5,
                                                       animations: {
             self.loginView.transform = .identity
             self.passwordView.transform = .identity
                                    })
        }, completion: nil)
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1

        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 150
        scaleAnimation.mass = 2

        let animationsGroup = CAAnimationGroup()
        animationsGroup.duration = 1
        animationsGroup.beginTime = CACurrentMediaTime() + 1
        animationsGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationsGroup.fillMode = CAMediaTimingFillMode.backwards
        animationsGroup.animations = [fadeInAnimation, scaleAnimation]

        self.loginView.layer.add(animationsGroup, forKey: nil)
        self.passwordView.layer.add(animationsGroup, forKey: nil)

    }
    //К кнопке «Войти» применим пружинную анимацию увеличения и тоже будем использовать анимации слоя.

    func animateAuthButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.authButton.layer.add(animation, forKey: nil)
    }
    
    
    
     // MARK: - UIPanGestureRecognizer
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                         dampingRatio: 0.5,
                                                         animations: {
                self.authButton.transform = CGAffineTransform(translationX: 0,
                                                              y: 150)
            })
            
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            
            interactiveAnimator.addAnimations {
                self.authButton.transform = .identity
            }
            
            interactiveAnimator.startAnimation()
        default: return
        }
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
