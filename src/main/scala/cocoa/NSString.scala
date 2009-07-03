package cocoa

class NSString extends NSObject {
	override def toString = Bridge.nsStringToString(this)
}

