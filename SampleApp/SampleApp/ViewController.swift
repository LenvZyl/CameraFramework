//
//  ViewController.swift
//  SampleApp
//
//  Created by Len van Zyl on 2019/01/10.
//  Copyright © 2019 Len van Zyl. All rights reserved.
//

import UIKit
import CameraFramework

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func startButtonTapped(_ sender: Any) {
        let camera = CameraViewController.init()
        camera.delegate = self
        camera.position = .back
        present(camera, animated: true, completion: nil)
    }
    

}
extension ViewController: CameraControllerDelegate {
    func stillImageCaptured(controller: CameraViewController, image: UIImage) {
        self.imageView.image = image
        controller.dismiss(animated: true, completion: nil)
    }
    func cancelButtonTapped(controller: CameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func triggerButtonTapped(controller: CameraViewController) {
        print("trigger tapped")
    }
}
