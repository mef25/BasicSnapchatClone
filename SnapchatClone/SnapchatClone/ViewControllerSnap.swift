//
//  ViewControllerSnap.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 14.02.2024.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher
class ViewControllerSnap: UIViewController {
    @IBOutlet var timeleft: UILabel!
    
    var secilensnap : UserSnap?
    var inputarray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let snap = secilensnap{
            timeleft.text = "Time Left: \(snap.timeDifference)"
            
            for imageurl in snap.imageurlsnap{
                inputarray.append(KingfisherSource(urlString: imageurl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
                       imageSlideShow.backgroundColor = UIColor.white
                       
                       let pageIndicator = UIPageControl()
                       pageIndicator.currentPageIndicatorTintColor = UIColor.black
                       pageIndicator.pageIndicatorTintColor = UIColor.lightGray
                       imageSlideShow.pageIndicator = pageIndicator
                       
                       imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
                       imageSlideShow.setImageInputs(inputarray)
                       self.view.addSubview(imageSlideShow)
                       self.view.bringSubviewToFront(timeleft)
            
            
        }
        
        
    }
    


}
