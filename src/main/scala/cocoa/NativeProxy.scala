package cocoa

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
		case that: NativeProxy => this.nptr == that.nptr
		case _ => false
	}
}