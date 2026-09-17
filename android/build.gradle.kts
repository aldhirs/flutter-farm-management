allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

/*
Samakan compileSdk seluruh modul plugin dengan milik aplikasi.

Sebagian plugin menuliskan compileSdk-nya sendiri dan tidak pernah ikut naik —
fluttertoast, misalnya, masih menyebut 33 di versi terbarunya. Sementara itu
pustaka AndroidX yang dipakainya menuntut minimal 34, dan sejak AGP 8.13
ketidakcocokan itu menggagalkan build, bukan lagi sekadar peringatan. Akibatnya
satu plugin yang tidak terurus menahan seluruh aplikasi di Android lama.

Hanya compileSdk yang disamakan — angka yang menentukan API mana yang boleh
dipanggil saat mengompilasi. minSdk tiap plugin dibiarkan apa adanya, karena
itu yang menentukan perangkat mana yang masih bisa memasang aplikasinya.

Disetel di `afterEvaluate`, supaya berlaku setelah berkas build milik plugin
selesai menyebut angkanya sendiri; disetel lebih awal, angka itulah yang menang.
Blok ini juga harus berdiri sebelum blok `evaluationDependsOn` di bawah, karena
blok tersebut memaksa subproject dievaluasi, dan menitipkan pekerjaan ke
`afterEvaluate` pada proyek yang sudah selesai dievaluasi adalah galat.

Dipakai properti `compileSdk` dari DSL baru, bukan `compileSdkVersion(angka)`
yang lama. Yang lama merangkai nama platform sebagai "android-37", sementara
Android kini menerbitkan platform bernomor minor dan yang terpasang bernama
"android-37.0", sehingga buildnya berhenti dengan "Failed to find target with
hash string 'android-37'". Galat itu hanya muncul pada build yang benar-benar
bersih — selama folder .gradle proyek masih ada, hasil resolusi sebelumnya
dipakai ulang dan semuanya tampak baik-baik saja.
*/
val pluginCompileSdk = (project.findProperty("agrisatwa.compileSdk") as String?)?.toInt()
if (pluginCompileSdk != null) {
    subprojects {
        afterEvaluate {
            when (val androidExtension = extensions.findByName("android")) {
                is com.android.build.api.dsl.LibraryExtension ->
                    androidExtension.compileSdk = pluginCompileSdk
                is com.android.build.api.dsl.ApplicationExtension ->
                    androidExtension.compileSdk = pluginCompileSdk
                else -> Unit
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
