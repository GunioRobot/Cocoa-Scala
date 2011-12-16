package cocoa.foundation

class NSString_class(className: String) extends NSObject_class(className) {
    override def alloc = super.alloc.asInstanceOf[NSString]

    def apply(string: String) = Bridge.stringToNSString(string)
}

class NSString extends NSObject {
    override def toString = Bridge.nsStringToString(this)

    def length: Long = msgSend("length", null).asInstanceOf[Long]
}

