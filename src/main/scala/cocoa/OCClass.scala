package cocoa

/**
 * Instances of this class are used to proxy Objective-C classes.
 */
class OCClass(val className: String, val isMetaClass: Boolean) extends $ID {
    private val methods = Cache.strict((name:String) => findMethod(Selector(name)))
    
    /** gets the proxy for the superclass */
    lazy val superClass: OCClass = findSuperClass
    
    Bridge.touch() // be sure the jnilib is loaded
    attach(className, isMetaClass)
    Bridge.registerClass(this)
    
    def this(className: String) = this(className, false)
    
    /** returns the name of the Objective-C class */
    override def toString = className + (if (isMetaClass) "[meta]" else "")
    
    /** connects to the underlying objective-c class */
    @native private def attach(className: String, isMetaClass: Boolean)
    
    override protected def finalize() {}
    
    /** gets the java.lang.Class for the objective-c proxy instances associated with this class */
    lazy val instanceClass: Class[$ID] = {
        if (getClass() == classOf[OCClass]) {
            classOf[$ID]
        }
        else {
            val classClassName = getClass().getName
            val instanceClassName = 
                if (classClassName endsWith "_class") 
                    classClassName.substring(0, classClassName.length - "_class".length)
                else {
                    val dot = classClassName.lastIndexOf('.')
                    classClassName.substring(0, dot + 1) + className
                }
            Class.forName(instanceClassName).asInstanceOf[Class[$ID]]
        }
    }

    /** gets the proxy for the superclass */
    @native private def findSuperClass: OCClass
    
    /** calls the respondsToSelector method on the objective-c class */
    @native def respondsToSelector(sel: String): Boolean

    /** gets the Method for the specified selector */
    def methodForSelector(sel: String): Option[Method] = methods(sel)
    
    /** searches the underlying objective-class for a method for the given selector */
    @native private def findMethod(sel: Selector): Method
    
    /* allocates an instance of this class */
    @native def alloc: $ID
}

object OCClass {
    def apply(className: String) = Bridge.getClass(className)
}

