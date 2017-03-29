//
//  File.swift
//  TextViewWithPlaceholder
//
//  Created by Micha Volin on 2017-02-12.
//  Copyright © 2017 Vmee. All rights reserved.
//
@objc
public protocol TextViewWithPlaceholderDelegeta{
   
   @objc optional func textViewWithPlaceholderShouldBeginEditing(textView: TextViewWithPlaceholder)
   @objc optional func textViewWithPlaceholderDidFinishEditing(textView: TextViewWithPlaceholder)
   @objc optional func textViewWithPlaceholderDidChange(textView: TextViewWithPlaceholder)
   @objc optional func textViewWithPlaceholderShouldReturn(textView: TextViewWithPlaceholder, replacement text: String, length: Int) -> Bool
}
