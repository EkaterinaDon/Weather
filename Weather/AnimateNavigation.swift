//
//  AnimateNavigation.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 08/09/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit


class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        }

        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }


}


class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    

    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.33

            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }

    
}


final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        //добавляем следующий view controller в контейнер и задаем начальные frame и transform
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
        
 
        
          //удаляться текущий
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.75,
                                                       animations: {
                                                           let translation = CGAffineTransform(translationX: -200, y: 0)
                                                           let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                                           source.view.transform = translation.concatenating(scale)
                                    })
                                    //немного увеличиваться и накрывать текущий
                                    UIView.addKeyframe(withRelativeStartTime: 0.2,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                           let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
                                                           let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                                           destination.view.transform = translation.concatenating(scale)
                                    })
                                    //полностью накроет текущий
                                    UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                           destination.view.transform = .identity
                                    })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }


    }
    
    

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    
    
}

final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
            guard let source = transitionContext.viewController(forKey: .from) else { return }
            guard let destination = transitionContext.viewController(forKey: .to) else { return }
                
                transitionContext.containerView.addSubview(destination.view)
                transitionContext.containerView.sendSubviewToBack(destination.view)
                
                destination.view.frame = source.view.frame
                
                let translation = CGAffineTransform(translationX: -200, y: 0)
                let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                destination.view.transform = translation.concatenating(scale)
                
                UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                        delay: 0,
                                        options: .calculationModePaced,
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0,
                                                               relativeDuration: 0.4,
                                                               animations: {
                                                                   let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
                                                                   let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                                                   source.view.transform = translation.concatenating(scale)
                                            })
                                            UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                               relativeDuration: 0.4,
                                                               animations: {
                                                                   source.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
                                            })
                                            UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                               relativeDuration: 0.75,
                                                               animations: {
                                                                   destination.view.transform = .identity
                                            })
                                            
                                            
                }) { finished in
                    if finished && !transitionContext.transitionWasCancelled {
                        source.removeFromParent()
                    } else if transitionContext.transitionWasCancelled {
                        destination.view.transform = .identity
                    }
                    transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
                }
            }
}
