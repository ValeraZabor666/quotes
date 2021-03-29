//
//  TextInfoViewController.swift
//  Yand
//
//  Created by Mac on 24.03.2021.
//

import UIKit

class TextInfoViewController: UIViewController {

    var moreInfo = [MoreInfo]()
    var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTextView()
    }
    
    func createTextView() {
        textView = UITextView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: self.view.bounds.width,
                                            height: self.view.bounds.height))
        textView.text = """
        location : \(moreInfo[0].country),
        \(moreInfo[0].state), \(moreInfo[0].city)
        \(moreInfo[0].address1)
        ---
        phone: \(moreInfo[0].phone)
        web: \(moreInfo[0].website)
        ---
        \(moreInfo[0].longBusinessSummary)
        """
        textView.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(textView)
    }
}
