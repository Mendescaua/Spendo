# Impede o R8 de remover essas classes do ML Kit
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**
