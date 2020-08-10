//
//  UCVTableWithoutExtraLine.swift
//  UniqueCalendarView
//
//  Created by Macsed on 2020/7/14.
//  Copyright © 2020 Macsed. All rights reserved.
//

import UIKit

internal class UCVTableWithoutExtraLine: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame:frame,style:style)
        clearExtraLine()
    }
    
    func clearExtraLine(){
        let view = UIView()
        view.backgroundColor = UIColor.clear
        self.tableFooterView = view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

