//
//  ViewController.swift
//  SwipeImagePicker
//
//  Created by Oliver Eichhorn on 10.05.15.
//  Copyright (c) 2015 Oliver Eichhorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Here we initialize the SwipeImagePickerView and add it to out view as subview.
		// The first two images have a title, the third one has none.
		
		var clipview = SwipeImagePickerView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200),
			images: [UIImage(named: "rabbits.jpg")!, UIImage(named: "cat.jpg")!, UIImage(named: "piggy.jpg")!],
			titles: ["Rabbits", "White Cat"]) { (tappedIndex: Int) in
				
				var alertView = UIAlertView(title: "SwipeImagePickerView", message: "Tapped image number \(tappedIndex)", delegate: nil, cancelButtonTitle: "OK")
				alertView.show()
			}
		
		self.view.addSubview(clipview)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}

