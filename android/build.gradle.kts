plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}

buildscript {
    val kotlin_version by extra("1.8.10")
    
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
        classpath("com.android.tools.build:gradle:8.2.2")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Define a new build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    
    // Ensure that all subprojects depend on ":app"
    evaluationDependsOn(":app")
}

// Register a task to clean the build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
