/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

let menuColors = [
  UIColor(red: 249/255, green: 84/255,  blue: 7/255,   alpha: 1.0),
  UIColor(red: 69/255,  green: 59/255,  blue: 55/255,  alpha: 1.0),
  UIColor(red: 249/255, green: 194/255, blue: 7/255,   alpha: 1.0),
  UIColor(red: 32/255,  green: 188/255, blue: 32/255,  alpha: 1.0)
]

class MenuItem {
  
  let title: String
  let symbol: String
  let color: UIColor
  
  init(symbol: String, color: UIColor, title: String) {
    self.symbol = symbol
    self.color  = color
    self.title  = title
  }
  
  class var sharedItems: [MenuItem] {
    struct Static {
      static let items = MenuItem.sharedMenuItems()
    }
    return Static.items
  }
  
  class func sharedMenuItems() -> [MenuItem] {
    var items = [MenuItem]()
    
    items.append(MenuItem(symbol: "ⓘ", color: menuColors[0], title: "Information"))
    items.append(MenuItem(symbol: "+", color: menuColors[1], title: "Archiving"))
    items.append(MenuItem(symbol: "♽", color: menuColors[2], title: "Extraction"))
    items.append(MenuItem(symbol: "✺", color: menuColors[3], title: "Settings"))
    
    return items
  }
  
}

