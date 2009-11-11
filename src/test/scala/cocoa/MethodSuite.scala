package cocoa

import cocoa.foundation._
import org.scalatest._

class MethodSuite extends FunSuite {
    import Foundation._
//    Foundation.require
    
    test("NSString!'length should return length") {
        val str = NSString("hello")
        assert(str!'length === 5)
    }
    
    test("NSString.length should return a number") {
        val str = NSString("hello")
        assert(str.length === 5)
    }
    
    test("NSString!string should return empty string") {
        val str = $ID(NSString ! 'string)
        assert(str.isInstanceOf[NSString])
        assert(str.isa.isInstanceOf[NSString_class])
        assert(str.toString === "")
        assert(str ! 'length === 0)
    }
    
    test("NSString ! isSubclassOfClass->NSObject should be true") {
        assert(NSString!('isSubclassOfClass->NSObject) === true)
    }
}
