plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.journiq.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.journiq.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val releaseKeystore = file("keystore.jks")
            val keystorePassword = System.getenv("KEYSTORE_PASSWORD")
            val keyAliasValue = System.getenv("KEY_ALIAS")
            val keyPasswordValue = System.getenv("KEY_PASSWORD")
            if (!releaseKeystore.exists() || keystorePassword.isNullOrBlank() ||
                keyAliasValue.isNullOrBlank() || keyPasswordValue.isNullOrBlank()) {
                throw GradleException(
                    "Production release signing requires the protected CI/CD " +
                        "keystore and signing variables."
                )
            }
            storeFile = releaseKeystore
            storePassword = keystorePassword
            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
