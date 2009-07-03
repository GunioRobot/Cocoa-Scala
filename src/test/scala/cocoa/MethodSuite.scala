package cocoa

import org.scalatest._

class MethodSuite extends FunSuite {
	test("NSString.length should return length") {
		val str = Bridge.stringToNSString("hello")
		assert(str!'length === 5)
	}
	
	test("NSString.string should return empty string") {
		val NSString = OCClass("NSString")
		val str = $ID(NSString ! 'string)
		assert(str.toString === "")
		assert(str ! 'length === 0)
	}
}
