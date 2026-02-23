import java.util.Properties
import java.io.FileInputStream
 
plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
 
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
 
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
 
android {
    namespace = "com.infiniquote.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"
 
    defaultConfig {
        applicationId = "com.infiniquote.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }
 
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }
 
    kotlinOptions {
        jvmTarget = "11"
    }
 
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
 
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
 
dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    // ✅ Kotlin DSL syntax for desugaring
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.1.4")
}
 
flutter {
    source = "../.."
}