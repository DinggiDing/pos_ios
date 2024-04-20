//
//  File.swift
//  pos001
//
//  Created by 성재 on 2021/07/08.
//

import Foundation

@available(iOS 6.0, *)
open class UIRefreshControl: UIControl {
    public init()
    
    open var isRefreshing: Bool {get}
    
    open var tintColor: UIColor!
    
    open var attributedTitle: NSAttributedString?
    
    @available(iOS 6.0, *)
    open func beginRefreshing()
    
    @available(iOS 6.0, *)
    open func endRefreshing()
}
