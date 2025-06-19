# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Google Auth
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.auth.api.** { *; }
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-dontwarn com.google.android.gms.auth.**

# Smart Auth Plugin - Overridden to fix crashes
# -keep class fman.ge.smart_auth.** { *; }
# -dontwarn fman.ge.smart_auth.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Supabase
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# HTTP/Networking
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# JSON parsing
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepattributes Signature
-keepattributes *Annotation*

# Networking - Additional rules for release builds
-keep class javax.net.ssl.** { *; }
-keep class java.security.cert.** { *; }
-dontwarn javax.net.ssl.**
-dontwarn java.security.cert.**

# Keep authentication related classes
-keep class io.supabase.gotrue.** { *; }
-keep class io.supabase.realtime.** { *; }
-keep class io.supabase.storage.** { *; }
-keep class io.supabase.postgrest.** { *; }

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Retrofit
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep all model classes
-keep class * extends java.lang.Enum { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Additional rules for API/HTTP requests in release
-keep class * extends java.io.Serializable { *; }
-keepclassmembers class * extends java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Google Sign-In - Enhanced rules for release builds
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-keep class com.google.android.gms.internal.** { *; }
-dontwarn com.google.android.gms.internal.**

# Google Sign-In specifically
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-keep class com.google.android.gms.auth.GoogleAuthUtil { *; }
-keep class com.google.android.gms.auth.GooglePlayServicesAvailabilityException { *; }
-keep class com.google.android.gms.auth.UserRecoverableAuthException { *; }

# Flutter Google Sign-In plugin - Enhanced
-keep class io.flutter.plugins.googlesignin.** { *; }
-keep class io.flutter.plugins.googlesignin.GoogleSignInPlugin { *; }

# Keep all Flutter plugins
-keep class io.flutter.plugins.** { *; }

# Google Play Services - Additional rules
-keep class com.google.android.gms.common.ConnectionResult { *; }
-keep class com.google.android.gms.common.GoogleApiAvailability { *; } 