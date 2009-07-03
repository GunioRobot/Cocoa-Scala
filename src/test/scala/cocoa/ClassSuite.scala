package cocoa

import org.scalatest._

class ClassSuite extends FunSuite {
	import OCType._
	
	test("NSString className should be 'NSString'") {
		assert(OCClass("NSString").className === "NSString")
	}

	test("NSString superClass should be NSObject") {
		assert(OCClass("NSString").superClass === OCClass("NSObject"))
	}

	test("NSString respondsToSelector stringWithFormat: should return true") {
		assert(OCClass("NSString").respondsToSelector("stringWithFormat:") === true)
	}

	test("NSString respondsToSelector length should return false") {
		assert(OCClass("NSString").respondsToSelector("length") === false)
	}
	
	test("NSString.isa.isMetaClass should be true") {
		assert(OCClass("NSString").isa.isMetaClass === true)
	}
	
	test("NSString.isa.isMetaClass should be equal to getMetaClass('NSString')") {
		assert(OCClass("NSString").isa === Bridge.getMetaClass("NSString"))
	}
	
	test("NSObject.init method should have IDType return type and no args") {
		val method = OCClass("NSObject").methodForSelector("init").get
		Console.println("NSObject.init => " + method)
		assert(method.sel === Selector("init"))
		assert(method.returnType === IDType)
		assert(method.argTypes.length === 0)
	}
	
	test("NSString.initWithString: method should have IDType return type and one arg") {
		val method = OCClass("NSString").methodForSelector("initWithString:").get
		Console.println("NSString.initWithString: => " + method)
		assert(method.sel === Selector("initWithString:"))
		assert(method.returnType === IDType)
		assert(method.argTypes.length === 1)
		assert(method.argTypes(0) === IDType)
	}
	
	test("NSString.initWithUTF8String: method should have IDType return type and one arg") {
		val method = OCClass("NSString").methodForSelector("initWithUTF8String:").get
		Console.println("NSString.initWithUTF8String: => " + method)
		assert(method.sel === Selector("initWithUTF8String:"))
		assert(method.returnType === IDType)
		assert(method.argTypes.length === 1)
		assert(method.argTypes(0) === CStringType)
	}
	
	test("NSString.initWithFormat: method should have IDType return type and one arg") {
		val method = OCClass("NSString").methodForSelector("initWithFormat:").get
		Console.println("NSString.initWithFormat: => " + method)
		assert(method.sel === Selector("initWithFormat:"))
		assert(method.returnType === IDType)
		assert(method.argTypes.length === 1)
		assert(method.argTypes(0) === IDType)
	}
	
	
	test("NSString.length method should have UIntType return type and no args") {
		val method = OCClass("NSString").methodForSelector("length").get
		Console.println("NSString.length => " + method)
		assert(method.sel === Selector("length"))
		assert(method.returnType === UIntType)
		assert(method.argTypes.length === 0)
	}
}
