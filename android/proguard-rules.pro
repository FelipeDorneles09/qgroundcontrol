# Proguard rules for QGroundControl / SkyClean

# Keep all Mavlink classes
-keep class org.mavlink.** { *; }

# Keep all QGroundControl classes
-keep class org.qgroundcontrol.** { *; }
-keep class org.apache.harmony.** { *; }

# Keep USB Serial
-keep class com.hoho.android.usbserial.** { *; }

# Keep Qt classes
-keep class org.qtproject.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Optimization settings
-optimizationpasses 5
-verbose
-dontnote

# Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Remove unnecessary warnings
-dontwarn java.awt.**
-dontwarn javax.swing.**
-dontwarn com.sun.**
-dontwarn sun.misc.**
-dontwarn com.android.**
