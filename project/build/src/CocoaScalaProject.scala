import sbt._
import Process._
import FileUtilities._

class CocoaScalaProject(info: ProjectInfo) extends DefaultProject(info) {
    val scalatest = "org.scala-tools.testing" % "scalatest" % "0.9.5"

    val frameworkPath = path("framework")
    val headersPath = frameworkPath / "jni-src"

	val targetPath = path("target")
    val targetFrameworkPath = targetPath / "CocoaScala.framework"
	val targetJNILibPath = targetPath / "libCocoaScala.jnilib"
    
    val nativeClasses = List(
        "cocoa.Bridge$",
        "cocoa.$ID",
		"cocoa.OCClass",
		"cocoa.Method",
		"cocoa.foundation.NSObject_class")
        
    override def cleanAction = super.cleanAction dependsOn cleanFramework
        
    lazy val javah = task {
        ("javah -classpath target/classes -d " + headersPath + " " + nativeClasses.mkString(" ")) ! log
        None
    } dependsOn(compile)
    
    lazy val framework = task {
        FileUtilities.clean(List(targetFrameworkPath), log)
        Process("xcodebuild -target CocoaScala", frameworkPath) ! log
        copyDirectory(targetPath / "framework" / "Release" / "CocoaScala.framework", 
            targetFrameworkPath, 
            log)
        None
    } dependsOn(`package`)

    lazy val jnilib = task {
        FileUtilities.clean(List(targetJNILibPath), log)
        Process("xcodebuild -target JNILib", frameworkPath) ! log
        copyFile(targetPath / "framework" / "Release" / "libCocoaScala.jniLib", 
            targetJNILibPath, 
            log)
        None
    }

    lazy val jnilibDebug = task {
        FileUtilities.clean(List(targetJNILibPath), log)
        Process("xcodebuild -target JNILib -configuration Debug", frameworkPath) ! log
        copyFile(targetPath / "framework" / "Debug" / "libCocoaScala.jniLib", 
            targetJNILibPath, 
            log)
        None
    }

    lazy val cleanFramework = task {
        Process("xcodebuild clean", frameworkPath) ! log
        None
    }

	lazy val testApp = task {
        Process("xcodebuild -target UnitTests", frameworkPath) ! log
		Process("open -W " + (frameworkPath / "build" / "Release" / "UnitTests.app")) ! log
		None
	} dependsOn(packageTest)
}
