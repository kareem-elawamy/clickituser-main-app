allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    // نضع فحصاً بسيطاً لتجنب مشاكل التقييم المتداخل
    if (project.name != "app") {
        project.evaluationDependsOn(":app")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// الحل النهائي والأكثر استقراراً لمشكلة الـ Namespace في Kotlin DSL
subprojects {
    project.plugins.whenPluginAdded {
        if (this is com.android.build.gradle.api.AndroidBasePlugin) {
            val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            android?.let {
                if (it.namespace == null) {
                    // إذا لم يكن هناك namespace، نستخدم اسم المجموعة أو اسم المشروع كبديل
                    it.namespace = project.group.toString().ifEmpty { "com.sixvalley.${project.name.replace("-", ".")}" }
                }
            }
        }
    }
}