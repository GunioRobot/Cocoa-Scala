package cocoa

/**
 * This class is used to wrap a pointer to a native data structure, such as
 * an objective-c object or a SEL.
 */
protected[cocoa] class NativeProxy {
    /** stores a pointer to the underlying objective-c object */
    protected var nptr: Long = _    
    
    protected def this(nptr: Long) = {
        this()
        this.nptr = nptr
    }
    
    /** sub-classes that override finalize MUST call this super version
     * in order to release the underlying objective-c object */
    @native protected override def finalize()

    /** hash code is based upon native pointer */
    override def hashCode = nptr.toInt

    /** equality is based upon native pointer */
    override def equals(v: Any) = v match {
        case that: NativeProxy => 
            // Console.println("equals: " + this.getClass.getName + "#" + this.nptr.toHexString +
            //     ", " + that.getClass.getName + "#" + that.nptr.toHexString)
            this.nptr == that.nptr
        case _ => false
    }
}