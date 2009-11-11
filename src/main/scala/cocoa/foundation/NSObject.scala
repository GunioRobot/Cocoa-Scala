package cocoa.foundation

class NSObject_class(className: String) extends OCClass(className) {
    override def alloc = super.alloc.asInstanceOf[NSObject]
}

class NSObject extends $ID
