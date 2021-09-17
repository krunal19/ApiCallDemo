//
//  ViewController.swift
//  ApiCallDemo
//
//  Created by Krunal on 18/07/20.
//  Copyright © 2020 Krunal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var button: UIBarButtonItem!
    
    @IBOutlet weak var circularView: CircularProgressView!
    
    //    var circularView: CircularProgressView!
    var duration: TimeInterval!
    override func viewDidLoad() {
    super.viewDidLoad()


    }
    
}
//    circularView.center = view.center
//    containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//    view.addSubview(circularView)
//    circularView.progressAnimation(duration: 1)
////    circularView.progressAnimation(duration: 0)
//    }
//
//    @objc func handleTap() {
//    duration = 0    //Play with whatever value you want :]
//    circularView.progressAnimation(duration: duration)
//    }
//}









//     @IBOutlet weak var circleV: CircleView!
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//        }
//
//        @IBAction func animateFrame(_ sender: UIButton) {
//
//
//            let diceRoll = CGFloat(Int(arc4random_uniform(7))*30)
//            let circleEdge = CGFloat(200)
//
//            // Create a new CircleView
//            let circleView = CircleView(frame: CGRect(x: 50, y: diceRoll, width: circleEdge, height: circleEdge))
//
//            view.addSubview(circleView)
//
//            // Animate the drawing of the circle over the course of 1 second
//            circleView.animateCircle(duration: 1.0)
//
//
//        }
//
//        @IBAction func animateAutolayout(_ sender: UIButton) {
//
//            let circleView = CircleView(frame: CGRect.zero)
//            circleView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(circleView)
//            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//            circleView.widthAnchor.constraint(equalToConstant: 250).isActive = true
//            circleView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//            // Animate the drawing of the circle over the course of 1 second
//            circleView.animateCircle(duration: 1.0)
//        }
//
//        @IBAction func animateStoryboard(_ sender: UIButton) {
//            // Animate the drawing of the circle over the course of 1 second
//            circleV.animateCircle(duration: 1.0)
//
//        }
//
//    }
        
        
        
        
        
        
        /******************************
        
//        let Question1 = JSON(["question":"Have you tried contacting your driver?","answer":"test"])
//        let Question2 = JSON(["question":"What item did you lose?","answer1":"test"])
//        let Question3 = JSON(["question":"Where do you think your item is in the vehicle?","answer2":"test"])
//        let Question4 = JSON(["question":"Where do you think your item is in the vehicle?","answer2":"test"])
//        let storeJson = JSON([Question1, Question2, Question3, Question4])
//        let SubQuestion = JSON(["question":"I couldn't reach my driver about a lost item","Answer":JSON(storeJson)])
//        let MainQuestion = JSON(["question":"I lost an item","Answer":JSON(SubQuestion)])
//
////        print(MainQuestion)
//
//        var parameter = [String:Any]()
//        parameter["ride_id"] = "10"
//        parameter["help_data"] = JSON(MainQuestion)
//        print(parameter)
//
        
        
        // Do any additional setup after loading the view.
            //parameter
//            var parameter = [String:Any]()
//
//            parameter["email"] = "kemail@yopmail.com"
//            parameter["password"] = "qFLn#G!I"
//            parameter["role"] = "Customer"
//
//            let url = WebURL.Login
        WebService.call.withPath("https://reqres.in/api/users/", parameter: [:],methods: .get) { (json, error) in

                print(json)
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let data = json["data"].dictionaryValue
            
            
            

                if status == 200{

                    let id = data["id"]?.stringValue
//                    UserInfo.sharedInstance.setMyUserDefaults(value: id!, key: MyUserDefaults.userId)

                    //User Device Api Call
//                    self.userDeviceApiCall()
                    // self.redirectToPickup(isAnimated: true)

                }else {

//                    self.alertController(title: "Alert", msg: "Plese Enter Currect UserName And Password")
                }
            }
//
        }

    }
*/
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIButton {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }

        badgeLayer?.removeFromSuperlayer()

        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)

        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)

        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }

    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
