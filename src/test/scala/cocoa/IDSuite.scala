package cocoa

import org.scalatest._

class IDSuite extends FunSuite {
    val aString = Bridge.stringToNSString("hello world")

    test("aString.isa should be NSCFString") {
        assert(aString.isa === OCClass("NSCFString"))
    }

    test("aString.isa.isa should be Class") {
        Console.println("metaclass=" + aString.isa.isa)
        assert(aString.isa.isa === Bridge.getMetaClass("NSCFString"))
    }
}
