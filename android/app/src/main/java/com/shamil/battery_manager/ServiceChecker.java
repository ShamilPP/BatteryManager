package com.shamil.battery_manager;

import static com.shamil.battery_manager.MainActivity.isMyServiceRunning;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.content.ContextCompat;

public class ServiceChecker extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        if (!isMyServiceRunning(context, MyService.class)) {
            ContextCompat.startForegroundService(context, new Intent(context, MyService.class));
        }
        int second = 600;

        Intent i = new Intent(context, ServiceChecker.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0,
                i, 0);
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + second * 1000, pendingIntent);
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + second * 1000, pendingIntent);
        }
    }
}
