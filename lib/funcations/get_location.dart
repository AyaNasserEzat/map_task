import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// دالة آمنة: تحاول تجيب الموقع الحالي، وترجع Position أو null
/// ما بترميش استثناءات للمستدعي — بتتعامل مع الأخطاء وتُعيد null.
Future<Position?> determinePositionSafely(BuildContext context) async {
  try {
    // 1) تأكد إن خدمة الموقع شغالة
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // اسأل المستخدم بشكل لطيف لو عايز يفتح إعدادات الموقع
      final bool? open = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("تشغيل الموقع"),
          content: const Text(
              "خدمة الموقع (GPS) متوقفة. هل تريد فتح إعدادات الموقع لتشغيلها؟"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("لا")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("نعم")),
          ],
        ),
      );

      if (open == true) {
        await Geolocator.openLocationSettings();
        // بعد ما المستخدم راح الإعدادات، نعيد التحقق مرة تانية
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          // لو لسه مقفولة رجّع null بدل ما نرمي error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("يرجى تشغيل خدمة الموقع لتحديد الموقع.")),
          );
          return null;
        }
      } else {
        // المستخدم رفض فتح الإعدادات → نرجع null
        return null;
      }
    }

    // 2) تأكد من صلاحيات الوصول (permission)
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // المستخدم رفض الإذن مؤقتًا
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("يرجى منح صلاحية الموقع لاستخدام هذه الميزة.")),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // مرفوض نهائيًا — نعرض Dialog يشرح له يفتح إعدادات التطبيق يدوياً
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("صلاحيات الموقع مرفوضة"),
          content: const Text(
              "تم رفض صلاحية الموقع نهائيًا للتطبيق. يمكنك تفعيلها من إعدادات التطبيق."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("حسناً"))
          ],
        ),
      );
      return null;
    }

    // 3) كل حاجة كويسة — نجيب الموقع الحالي
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  } catch (e) {
    // امسك أي استثناء غير متوقع — ما نخليش التطبيق ينهار
    // ممكن تسجلّي الخطأ هنا لو عايزة (log)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("حدث خطأ أثناء جلب الموقع. حاول مرة أخرى.")),
    );
    return null;
  }
}
