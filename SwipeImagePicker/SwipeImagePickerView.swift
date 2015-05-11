//
//  SwipeImagePickerView
//  SwipeImagePicker
//
//  Created by Oliver Eichhorn on 10.12.14.
//  Copyright (c) 2015 Oliver Eichhorn. All rights reserved.
//

import UIKit
import QuartzCore


class SwipeImagePickerView: UIView {

    private var scrollView: UIScrollView?
    private var imageViews: [UIImageView]?
    private var labels: [UILabel]?
	private var titles: [String]
	private var images: [UIImage]

    private var viewCenter:CGPoint = CGPoint()
    private var pageWidth: CGFloat = 0
	
	var tapHandler: (tappedIndex: Int) -> ()

	
	/**
		Constructor for the SwipeImagePickerView.
	
		:param: frame		the frame for the SwipeImagePickerView
		:param: images		an array of images which are shown in the scrollview
		:param: titles		an array of titles which are shown below the images
		:param: tapHandler	the handler which is called when an image is tapped. It's only parameter is the index of the tapped image.
	*/
	init(frame: CGRect, images: [UIImage], titles: [String], tapHandler: (tappedIndex: Int) -> ()) {
		self.images = images
		self.titles = titles
		self.tapHandler = tapHandler
		super.init(frame: frame)
		self.backgroundColor = UIColor.whiteColor()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
		
		if let saveSuperview = self.superview {
	        self.viewCenter = CGPoint(x: saveSuperview.frame.width / 2, y: saveSuperview.frame.height / 2)
    	    self.pageWidth = saveSuperview.frame.width / 2.0
		}
		
        let maxImageWidth:CGFloat = 150
        let maxImageHeight:CGFloat = 200
        let labelHeight:CGFloat = 30
        
        // create scrollView
        
        var pagePadding = (self.pageWidth - maxImageWidth) / 2.0
        self.scrollView = UIScrollView(frame: CGRect(x: self.pageWidth / 2, y: 0, width: self.pageWidth, height: maxImageHeight))
		
		if let saveScrollView = self.scrollView {
			saveScrollView.pagingEnabled = true
			saveScrollView.bounces = true
			saveScrollView.clipsToBounds = false
			saveScrollView.showsHorizontalScrollIndicator = false
			saveScrollView.showsVerticalScrollIndicator = false
			
			var scrollViewTapped = UITapGestureRecognizer(target: self, action: Selector("scrollViewTappedHandler:"))
			saveScrollView.addGestureRecognizer(scrollViewTapped)

			self.addSubview(saveScrollView)
		}
		
        // create imageviews and labels

        self.imageViews = []
        self.labels = []

		for (var counter=0; counter < self.images.count; counter++) {
			var imageView = UIImageView(image: scaleImage(self.images[counter], size: CGSize(width: maxImageWidth, height: maxImageHeight)))
			var label = UILabel()
			
			if (counter < self.titles.count) {
				label.text = self.titles[counter]
			}
			
			self.imageViews?.append(imageView)
			self.labels?.append(label)
		}

        var contentWidth = self.pageWidth * CGFloat(self.imageViews!.count)
        self.scrollView?.contentSize = CGSize(width: contentWidth, height: maxImageHeight)
        
        // fill scrollview with imageviews and labels

        var pageNumber = 0
        
        for imageView in self.imageViews! {
            imageView.frame = CGRect(x: CGFloat(pageNumber) * self.pageWidth + pagePadding, y: 0, width: maxImageWidth, height: maxImageHeight)
            self.scrollView?.addSubview(imageView)
            pageNumber++
        }

        pageNumber = 0
        
        for label in self.labels! {
            label.frame = CGRect(x: CGFloat(pageNumber) * pageWidth, y: maxImageHeight, width: self.pageWidth, height: labelHeight)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.blackColor()
            self.scrollView?.addSubview(label)
            pageNumber++
        }

		// Add gradients
        
        var leftOfScrollView = UIImageView(frame: CGRect(x: 0, y: 0, width: pageWidth / 2, height: maxImageHeight + labelHeight))
        leftOfScrollView.image = UIImage(named: "GradientLeft.png")
        self.addSubview(leftOfScrollView)
        
        var rightOfScrollView = UIImageView(frame: CGRect(x: pageWidth * 1.5, y: 0, width: pageWidth / 2, height: maxImageHeight + labelHeight))
        rightOfScrollView.image = UIImage(named: "GradientRight.png")
        self.addSubview(rightOfScrollView)
    }
	
	
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self.pointInside(point, withEvent: event) ? self.scrollView : nil
    }

	
	/**
		Scales a given image to the given size.
	
		:param: image		the image to be scaled
		:param: size		the new size of the image
	
		:returns: the new scaled image
	*/
	func scaleImage(image: UIImage, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		image.drawInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
		var newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
			
		return newImage
	}

	
	/**
		Is called when the scrollview was tapped. Checks if the taphandler should be called.
	*/
    func scrollViewTappedHandler(recognizer: UITapGestureRecognizer) {
        
        var xPos = recognizer.locationInView(nil).x

        if (xPos < (self.pageWidth / 2.0)) {
            // left symbol tapped: do nothing
        } else if (xPos > (self.pageWidth * 1.5)) {
            // right symbol tapped: do nothing
        } else {
            // middle symbol tapped: call handler
			self.tapHandler(tappedIndex: Int(round((self.scrollView?.contentOffset.x)! / self.pageWidth)))
        }
    }
}

