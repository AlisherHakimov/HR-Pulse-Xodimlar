import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // DO NOT put google-services here anymore (in new Flutter projects)
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("key.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

android {
    namespace = "uz.sectorsoft.hrpulse"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true          // Correct
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "uz.sectorsoft.hrpulse"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Highly recommended when desugaring is enabled
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            storeFile = localProperties["storeFile"]?.let { file(it.toString()) }
            storePassword = localProperties["storePassword"]?.toString()
            keyAlias = localProperties["keyAlias"]?.toString()
            keyPassword = localProperties["keyPassword"]?.toString()
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.13.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")  // Correct syntax in kts
}

apply(plugin = "com.google.gms.google-services")