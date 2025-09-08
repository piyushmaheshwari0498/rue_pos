allprojects {
//    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
//        kotlinOptions {
//            jvmTarget = "17"
//        }
//    }
//
//    tasks.withType<JavaCompile>().configureEach {
//        sourceCompatibility = JavaVersion.VERSION_17.toString()
//        targetCompatibility = JavaVersion.VERSION_17.toString()
//    }

    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
            extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                if (namespace == null) {
                    namespace = group.toString()
                }
            }
        }
    }
    afterEvaluate {
        tasks.matching { it.name == "mapDebugSourceSetPaths" }.configureEach {
            dependsOn("processDebugGoogleServices")
        }
    }
}

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
//    if (project.plugins.hasPlugin("com.android.library") || project.plugins.hasPlugin("com.android.application")) {
//        project.extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
//            if (namespace == null) {
//                namespace = project.group.toString()
//            }
//        }
//    }

}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
