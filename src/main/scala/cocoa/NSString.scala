package cocoa

class NSString extends NSObject {
	override def toString = OCBridge.nsStringToString(this)
}

