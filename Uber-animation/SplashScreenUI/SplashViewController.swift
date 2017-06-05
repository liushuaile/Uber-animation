//
//  SplashViewController.swift
//  Uber-animation
//
//  Created by SL on 04/06/2017.
//  Copyright © 2017 SL. All rights reserved.
//

import UIKit
import Commons

public class SplashViewController: UIViewController {
    open var pulsing: Bool = false
    
    let animatedULogoView: AnimatedULogoView = AnimatedULogoView(frame: CGRect(x: 0.0, y: 0.0, width: 90.0, height: 90.0))
    
    var tileGridView: TileGridView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public init(tileViewFileName: String) {
        super.init(nibName: nil, bundle: nil)
        
        tileGridView = TileGridView(TileFileName: tileViewFileName)
        view.addSubview(tileGridView)
        tileGridView.frame = view.bounds
        
        
        view.addSubview(animatedULogoView)
        animatedULogoView.layer.position = view.layer.position
        
        tileGridView.startAnimating()
        animatedULogoView.startAnimating()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
