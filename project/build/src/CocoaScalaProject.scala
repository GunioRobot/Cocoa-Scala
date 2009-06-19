import java.lang.{ProcessBuilder => JProcessBuilder}
import sbt._
import Process._

class CocoaScalaProject(info: ProjectInfo) extends DefaultProject(info) {
    val scalatest = "org.scala-tools.testing" % "scalatest" % "0.9.5"

    val frameworkPath = path("framework")
    val headersPath = frameworkPath / "jni-src"
    
    val nativeClasses = List(
        "cocoa.ObjcBridge$",
        "cocoa.ObjcRef")
        
    def exec(cmd: String) = {
        Console.println(cmd)
        cmd!
    }
    
    def exec(inDir: Path, cmds: String*) = {
        Console.println(cmds.mkString(" "))
        new JProcessBuilder(cmds:_*).directory(inDir.asFile)!
    }
    
    override def cleanAction = super.cleanAction dependsOn cleanFramework
        
    lazy val javah = task {
        exec {
            "javah -classpath target/classes -d " + headersPath + " " + nativeClasses.mkString(" ")
        }
        None
    } dependsOn(compile)
    
    lazy val framework = task {
        exec(frameworkPath, "xcodebuild", "-alltargets")
        None
    } dependsOn(`package`)

    lazy val cleanFramework = task {
        exec(frameworkPath, "xcodebuild", "-clean")
        None
    } 
}
