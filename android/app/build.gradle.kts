plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

buildscript {
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")
    }
}

android {
    namespace = "com.clickituser.clickituserapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true 
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.clickituser.clickituserapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "brand"

    productFlavors {
        create("velvey") {
            dimension = "brand"
            applicationId = "com.ussus.velvey"
            resValue("string", "app_name", "Velvey")
        }
        create("umart") {
            dimension = "brand"
            applicationId = "com.ussus.umart"
            resValue("string", "app_name", "Umart")
        }
        create("ladychic") {
            dimension = "brand"
            applicationId = "com.ussus.ladychic"
            resValue("string", "app_name", "LadyChic")
        }
        create("vivo") {
            dimension = "brand"
            applicationId = "com.ussus.vivo"
            resValue("string", "app_name", "VIVO")
        }
        create("veraalux") {
            dimension = "brand"
            applicationId = "com.ussus.veraalux"
            resValue("string", "app_name", "Veraalux")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.10")
    implementation("com.google.firebase:firebase-messaging:21.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}