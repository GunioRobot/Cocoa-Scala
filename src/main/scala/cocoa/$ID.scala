package cocoa

class $ID {
	private var nptr: Long = _
	lazy val isa: OCClass = OCBridge.getClass(this)
	@native protected override def finalize()
	@native def !(sym: Symbol): Any
	@native def !(message: (Symbol, Any)*): Any	
	
	override def toString = isa.className + "@" + nptr.toHexString

	override def equals(v: Any) = v match {
		case that: $ID => this.nptr == that.nptr
		case _ => false
	}
}
