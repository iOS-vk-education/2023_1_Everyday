//
//  SplashViewController.swift
//  YoulaSplash
//
//  Created by Artur Sardaryan on 4/9/19.
//  Copyright © 2019 Artur Sardaryan. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    // swiftlint:disable private_outlet
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textImageView: UIImageView!
    
    var logoIsHidden: Bool = false
    var textImage: UIImage?
    
    static let logoImageBig: UIImage = UIImage(named: "logo")!

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textImageView.image = textImage
        logoImageView.isHidden = logoIsHidden
    }
    // swiftlint:enable private_outlet
}
