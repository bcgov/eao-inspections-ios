//
//  TextViewWithPlaceholder.swift
//  TextViewWithPlaceholder
//
//  Created by Micha Volin on 2017-02-12.
//  Copyright © 2017 Vmee. All rights reserved.
//

@IBDesignable
open class TextViewWithPlaceholder: UIView, UITextViewDelegate{
   
   public var delegate: TextViewWithPlaceholderDelegeta?
   
   @IBOutlet public var view: UIView!
   
   @IBOutlet var textView: UITextView!
   @IBOutlet var placeholderLabel: UILabel!
   @IBOutlet var counterLabel: UILabel!
   
   @IBOutlet var topConstraint: NSLayoutConstraint!
   @IBOutlet var leftConstraint: NSLayoutConstraint!
  
   @IBInspectable public var top: CGFloat{
      get {return 0}
      set {
         textView.textContainerInset.top = newValue
         setPlaceholder()
      }
   }
   
   @IBInspectable public var left: CGFloat{
      get {return 0}
      set {
         textView.textContainerInset.left = newValue
         setPlaceholder()
      }
   }
   
   @IBInspectable public var bottom: CGFloat{
      get {return 0}
      set {textView.textContainerInset.bottom = newValue}
   }
   
   @IBInspectable public var right: CGFloat{
      get {return 0}
      set {textView.textContainerInset.right = newValue}
   }
   
   @IBInspectable public var charLimit: Int = 200{
      didSet{
         counterLabel.text = "\(charLimit)"
      }
   }
   
   @IBInspectable public var placeholder: String?{
      didSet{
         placeholderLabel.text = placeholder
      }
   }
   
   @IBInspectable public var textColor: UIColor = UIColor.gray{
      didSet{
         textView.textColor = textColor
      }
   }
   
   ///Example: if set to '3', textView becoms scrollable after third line
   @IBInspectable public var scrollLimit: Int = 0
   
   @IBInspectable public var font: Int = 0{
      didSet{
         
         switch font{
         case 0:
            
            textView.font = Font.round
            
         case 1:
            
            textView.font = Font.normal
            
         case 2:
   
            textView.font = Font.thin
            
         default:
            
            textView.font = Font.round
         }
      }
   }
   
   @IBInspectable public var counter: Bool = true{
      didSet{
         counterLabel.isHidden = !counter
      }
   }
   
   public var text: String?{
      
      get {return textView.text}
      set{
         textView.text = newValue
         placeholderLabel.isHidden = (text == "" || text == nil) ? false : true 
      }
   }

   func setPlaceholder(){
      topConstraint.constant  = textView.textContainerInset.top 
      leftConstraint.constant = textView.textContainerInset.left + 8
      layoutIfNeeded()
   }
   
   public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
      delegate?.textViewWithPlaceholderShouldBeginEditing?(textView: self)
      return true
   }
   
   public func textViewDidEndEditing(_ textView: UITextView) {
      delegate?.textViewWithPlaceholderDidFinishEditing?(textView: self)
   }
   
   public func textViewDidChange(_ textView: UITextView) {
      if let str = textView.text, str != ""{
         placeholderLabel.isHidden = true
      } else {
         placeholderLabel.isHidden = false
      }
      delegate?.textViewWithPlaceholderDidChange?(textView: self)
   }
   
   public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
      if text == "\n" && textView.text.characters.last == "\n"{
         return false
      }
      if text == "\n" && textView.text == ""{
         return false
      }
      
      let length = textView.text.characters.count + text.characters.count - range.length
      
      let count = charLimit - length
      
      counterLabel.text = "\(count)"
      
      if scrollLimit > 0{
         textView.isScrollEnabled = (textView.numberOfLines() > scrollLimit) ? true : false
      }
      
      return delegate?.textViewWithPlaceholderShouldReturn?(textView: self, replacement: text, length: length) ?? (length < charLimit)
   }
   
   open override func prepareForInterfaceBuilder() {
      awakeFromNib()
   }
   
   open override func awakeFromNib() {
      textView.textContainerInset.bottom += (counter ? 30 : 0)
      textView.contentInset = .zero
   }
   
   func xibSetup() {
      view = loadFromNib()
      view.frame = bounds
      view.backgroundColor = UIColor.clear
      view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      addSubview(view)
      
      textView.delegate = self
   }
   
   public override init(frame: CGRect) {
      super.init(frame: frame)
      xibSetup()
   }
   
   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      xibSetup()
   }
 
   
}


struct Font{
   
   static let round  = UIFont(name: "Arial Rounded MT Bold", size: 18)!
   static let normal = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
   static let thin = UIFont.systemFont(ofSize: 18, weight: UIFontWeightRegular)
   
}


extension UITextView {
   public func numberOfLines() -> Int {
      let layoutManager = self.layoutManager
      let numberOfGlyphs = layoutManager.numberOfGlyphs
      var lineRange: NSRange = NSMakeRange(0, 1)
      var index = 0
      var numberOfLines = 0
      
      while index < numberOfGlyphs {
         layoutManager.lineFragmentRect(
            forGlyphAt: index, effectiveRange: &lineRange
         )
         index = NSMaxRange(lineRange)
         numberOfLines += 1
      }
      return numberOfLines
   }
}



