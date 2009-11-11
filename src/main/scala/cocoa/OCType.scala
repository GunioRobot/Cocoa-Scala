package cocoa

abstract class OCType(val code: Char)

object OCType {
    case object VoidType extends OCType('v')
    case object CharType extends OCType('c')
    case object UCharType extends OCType('C')
    case object ShortType extends OCType('s')
    case object UShortType extends OCType('S')
    case object IntType extends OCType('i')
    case object UIntType extends OCType('I')
    case object LongType extends OCType('q')
    case object ULongType extends OCType('Q')
    case object FloatType extends OCType('f')
    case object DoubleType extends OCType('d')
    case object IDType extends OCType('@')
    case object ClassType extends OCType('#')
    case object SelectorType extends OCType(':')
    case object CStringType extends OCType('*')
    case object PointerType extends OCType('^')
    
    def apply(descr: String): OCType = descr match {
        case "v" => VoidType
        case "c" => CharType
        case "C" => UCharType
        case "s" => ShortType
        case "S" => UShortType
        case "i" | "l" => IntType
        case "I" | "L" => UIntType
        case "q" => LongType
        case "Q" => ULongType
        case "f" => FloatType
        case "d" => DoubleType
        case "@" => IDType
        case "#" => ClassType
        case ":" => SelectorType
        case "*" | "r*" => CStringType
        case _ => throw new UnsupportedNativeTypeException(descr)
    }
}

class UnsupportedNativeTypeException(descr: String) extends Exception(descr)
