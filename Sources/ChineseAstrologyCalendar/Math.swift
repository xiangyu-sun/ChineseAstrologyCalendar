//
//  File.swift
//  
//
//  Created by Xiangyu Sun on 24/12/22.
//
import Swift
import Foundation

func findGCD(_ num1: Int, _ num2: Int) -> Int {
   var x = 0

   // Finding maximum number
   var y: Int = max(num1, num2)

   // Finding minimum number
   var z: Int = min(num1, num2)

   while z != 0 {
      x = y
      y = z
      z = x % y
   }
   return y
}


func findLCM(n1: Int, n2: Int) -> Int{
   return (n1 * n2/findGCD(n1, n2))
}
