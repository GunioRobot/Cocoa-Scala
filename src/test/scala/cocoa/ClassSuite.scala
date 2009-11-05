package cocoa

import cocoa.foundation._
import org.scalatest._

class ClassSuite extends FunSuite {
	import Foundation._
	import OCType._

	Foundation.require
	
	test("NSString className should be 'NSString'") {
		assert(NSString.className === "NSString")
	}

	test("NSString superClass should be NSObject") {
		assert(NSString.superClass === NSObject)
	}

	test("NSString respondsToSelector stringWithFormat: should return true") {
		assert(NSString.respondsToSelector("stringWithFormat:") === true)
	}

	test("NSString respondsToSelector length should return false") {
		assert(NSString.respondsToSelector("length") === false)
	}
	
	test("NSString.isa.isMetaClass should be true") {
		assert(NSString.isa.isMetaClass === true)
	}
	
	test("NSString.isa.isMetaClass should be equal to getMetaClass('NSString')") {
		assert(NSString.isa === Bridge.getMetaClass("NSString"))
	}
	
	test("NSObject.init method should have IDType return type and no args") {
		val method = NSObject.methodForSelector("init").get
		Console.println("NSObject.init => " + method)
		assert(method.sel === Selector("init"))
		assert(method.returnType === IDType)
		assert(method.paramTypes.length === 0)
	}
	
	test("NSString.initWithString: method should have IDType return type and one arg") {
		val method = NSString.methodForSelector("initWithString:").get
		Console.println("NSString.initWithString: => " + method)
		assert(method.sel === Selector("initWithString:"))
		assert(method.returnType === IDType)
		assert(method.paramTypes.length === 1)
		assert(method.paramTypes(0) === IDType)
	}
	
	test("NSString.initWithUTF8String: method should have IDType return type and one arg") {
		val method = NSString.methodForSelector("initWithUTF8String:").get
		Console.println("NSString.initWithUTF8String: => " + method)
		assert(method.sel === Selector("initWithUTF8String:"))
		assert(method.returnType === IDType)
		assert(method.paramTypes.length === 1)
		assert(method.paramTypes(0) === CStringType)
	}
	
	test("NSString.initWithFormat: method should have IDType return type and one arg") {
		val method = NSString.methodForSelector("initWithFormat:").get
		Console.println("NSString.initWithFormat: => " + method)
		assert(method.sel === Selector("initWithFormat:"))
		assert(method.returnType === IDType)
		assert(method.paramTypes.length === 1)
		assert(method.paramTypes(0) === IDType)
	}
	
	
	test("NSString.length method should have ULongType return type and no args") {
		val method = NSString.methodForSelector("length").get
		Console.println("NSString.length => " + method)
		assert(method.sel === Selector("length"))
		assert(method.returnType === ULongType)
		assert(method.paramTypes.length === 0)
	}
}
