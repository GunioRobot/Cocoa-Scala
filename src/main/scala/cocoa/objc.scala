package cocoa

class ObjcRef(val nptr: Long) {
    @native def objcClass: ObjcClass
    @native def description: String
    @native protected override def finalize()
    @native def !(sym: Symbol): Any
    @native def !(message: (Symbol, Any)*): Any
    
    override def toString = "ObjcRef(0x" + nptr.toHexString + ", " + objcClass.className + ")"
    
    override def equals(v: Any) = v match {
        case that: ObjcRef => this.nptr == that.nptr
        case _ => false
    }
}

object ObjcNil extends ObjcRef(0) {
    override def toString = "Nil"
    override def !(sym: Symbol): Any = ObjcNil
    override def !(message: (Symbol, Any)*): Any = ObjcNil
}

class ObjcClass(nptr: Long, val className: String) extends ObjcRef(nptr) {
    override def toString = "ObjcClass(0x" + nptr.toHexString + ", " + className + ")"
}

object ObjcClass {
    def apply(className: String) = ObjcBridge.findClass(className)
}

trait Protocol extends ObjcRef

class message(sig: String) extends Annotation

case class SEL(selector: String)
