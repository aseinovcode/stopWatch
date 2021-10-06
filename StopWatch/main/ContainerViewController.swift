//
//  ViewController.swift
//  sideBarMenu
//
//  Created by Zalkar on 2/10/21.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
 
    let menuVC = MenuViewController()
    let homeVC = ViewController()
    var navVC: UINavigationController?
    lazy var infoVC = ViewController2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildsVC()
        // Do any additional setup after loading the view.
    }

    private func addChildsVC(){
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
        
    }

}

extension ContainerViewController: HomeViewControllerDelegate{
    func didTapButtonMenu() {
       
        toggleMenu(completion: nil)
        
    }
    
    func toggleMenu(completion: (() -> Void)?){
        
        switch menuState {
        case .closed:
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
            } completion: { [weak self] (done) in
                if done{
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] (done) in
                if done{
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}


extension ContainerViewController: MenuViewControllerDelegate{
    
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        
        switch menuItem{
        
        case .home:
            self.resetToHome()
        case .info:
            self.addInfo()
        case .appRating:
            break
        case .share:
            break
        case .settings:
            break
        }
    }
    
    func addInfo(){
        
        let vc = infoVC
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title
    }
    
    func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        
    }
    
}

