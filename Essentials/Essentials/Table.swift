//
//  TableView.swift
//  WineInsider
//
//  Created by Micha Volin on 2017-01-17.
//  Copyright © 2017 Spencer Mandrusiak. All rights reserved.
//



public class Table: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    private var previousContentOffSetY : CGFloat = 0
   
    private var isScrolling = false
    
    var fastScrollSpeed: CGFloat = 30
    
    var delegation: TableDelegate?
    
    public convenience init(frame: CGRect){
        self.init(frame: frame, style: .grouped)
    }
    
    public override init(frame: CGRect, style: UITableViewStyle){
        super.init(frame: frame, style: style)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp(){
        delegate = self
        dataSource = self
    }
 
    
    func scrollToBottom(completion: (()->Void)?){

        let offSetY = contentSize.height - bounds.size.height + contentInset.bottom
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.contentOffset.y = offSetY
            
        }) { (_) in
            
             completion?()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffSetY = scrollView.contentOffset.y
        
        let speed = previousContentOffSetY - contentOffSetY
        
        previousContentOffSetY = contentOffSetY
        
        if abs(speed) > self.fastScrollSpeed && !isScrolling{
            delegation?.tableDidScrollFast?()
        }
        
        let bottom = scrollView.contentOffset.y + scrollView.frame.height
        
        if bottom >= scrollView.contentSize.height + 10{
            
            delegation?.tableDidScrollToBottom?()
        }
    }
 
    //MARK: -
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let delegate = delegation else{
            return 0
        }
        
        return delegate.table?(estimatedHeightForRowAt: indexPath) ?? 100
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        guard let delegate = delegation else{
            return 0
        }
        
        return delegate.table?(estimatedHeightForRowAt: indexPath) ?? tableView.rowHeight
    }
    
    //MARK: -
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        delegation?.table?(willDisplay: cell, at: indexPath)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let delegate = delegation else{
            return UITableViewCell()
        }
        
        return delegate.table(cellForRowAt: indexPath)
    }
    
    //MARK: -
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegation?.table?(viewForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegation?.table?(heightForFooterInSection: section) ?? CGFloat.leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegation?.table?(viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegation?.table?(heightForHeaderInSection: section) ?? CGFloat.leastNonzeroMagnitude
    }
    
    //MARK: -
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return delegation?.numberOfSections?() ?? 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegation?.table(numberOfRowsInSection: section) ?? 0
    }
    
    //MARK: -
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return delegation?.table?(canEditRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        delegation?.table?(didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        delegation?.table?(commit: editingStyle, forRowAt: indexPath)
    }
    
}


@objc public protocol TableDelegate {
    //MARK: -
    @objc optional func table(heightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func table(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func table(willDisplay cell:  UITableViewCell, at indexPath: IndexPath)
    
    //MARK: -
    @objc optional func table(heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func table(heightForFooterInSection section: Int) -> CGFloat
    @objc optional func table(viewForFooterInSection section: Int) -> UIView?
    @objc optional func table(viewForHeaderInSection section: Int) -> UIView?
    
    //MARK: -
    @objc optional func table(canEditRowAt indexPath: IndexPath) -> Bool
    @objc optional func table(commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    
    //MARK: - additional methods
    @objc optional func tableDidScrollFast()
    @objc optional func tableDidScrollToBottom()
   
    //MARK: -
    @objc optional func table(didSelectRowAt indexPath: IndexPath)
   
    //MARK: -
    @objc optional func numberOfSections() -> Int
   
    //MARK: -
    func table(cellForRowAt indexPath: IndexPath) -> UITableViewCell
  
    //MARK: -
    func table(numberOfRowsInSection section: Int) -> Int
    
}














