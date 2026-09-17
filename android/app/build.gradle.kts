import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Versi Android sasaran dibaca dari gradle.properties, dengan nilai bawaan
// Flutter sebagai cadangan bila propertinya tidak ada.
val agrisatwaCompileSdk: Int =
    (project.findProperty("agrisatwa.compileSdk") as String?)?.toInt() ?: 36
val agrisatwaTargetSdk: Int =
    (project.findProperty("agrisatwa.targetSdk") as String?)?.toInt() ?: 36

/*
Keterangan keystore, dari key.properties bila ada, dari gradle.properties bila
tidak.

key.properties didahulukan karena itu tempat yang lazim dipakai tiap mesin
menyimpan keterangan keystore-nya sendiri tanpa ikut ter-commit. Tetapi berkas
itu tidak ada di repo ini, sementara nilainya sudah tertulis di
gradle.properties — dan karena hanya key.properties yang dibaca, signingConfig
release tidak pernah terbentuk. Akibatnya `flutter build apk --release`
menghasilkan APK bertanda tangan kunci debug: tidak bisa diunggah ke Play
Console, dan tidak bisa memperbarui pemasangan yang sudah ada. Buildnya
berhasil tanpa keluhan apa pun, jadi tidak ada satu pun tanda bahwa hasilnya
tidak bisa dipakai.
*/
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}

fun keystoreValue(name: String): String? =
    keystoreProperties.getProperty(name) ?: project.findProperty(name) as String?

/*
Letak keystore dicari, tidak sekadar dipercaya apa adanya.

Yang tertulis di gradle.properties adalah "/app/agrisatwa-release.jks" — garis
miring di depan membuatnya dibaca sebagai jalur mutlak dari akar disk, padahal
berkasnya ada di android/app. Dicoba apa adanya dulu, untuk mesin yang memang
menyimpannya di luar repo, lalu relatif terhadap folder android.
*/
val keystoreFile: java.io.File? = keystoreValue("storeFile")?.let { path ->
    listOf(file(path), rootProject.file(path.trimStart('/'))).firstOrNull { it.exists() }
}

android {
    namespace = "com.agrisatwa.farm"
    compileSdk = agrisatwaCompileSdk
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.agrisatwa.farm"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = agrisatwaTargetSdk
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Hanya dibentuk bila keystore-nya benar-benar ditemukan, supaya mesin
        // tanpa keystore tetap bisa membangun — jatuh ke kunci debug di bawah.
        if (keystoreFile != null) {
            create("release") {
                keyAlias = keystoreValue("keyAlias")
                keyPassword = keystoreValue("keyPassword")
                storeFile = keystoreFile
                storePassword = keystoreValue("storePassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.findByName("release")
                ?: signingConfigs.getByName("debug")
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
