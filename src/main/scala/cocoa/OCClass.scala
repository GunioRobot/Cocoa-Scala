package cocoa

/**
 * Instances of this class are used to proxy Objective-C classes.
 */
class OCClass extends $ID {
	/** gets the name of the objective-c class */
	@native def className: String
	
	/** gets the proxy for the superclass */
	@native def superClass: OCClass
	
	/** calls the respondsToSelector method on the objective-c class */
	@native def respondsToSelector(sel: String): Boolean
	
	/** returns the name of the Objective-C class */
	override def toString = className
	
	/* allocates an instance of this class */
	@native def alloc: $ID
}

object OCClass {
	def apply(className: String) = OCBridge.getClass(className)
}

