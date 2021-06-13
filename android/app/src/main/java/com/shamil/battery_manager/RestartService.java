package com.shamil.battery_manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import static android.content.Context.ALARM_SERVICE;

public class RestartService extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(new Intent(context, CheckService.class));
        } else {
            context.startService(new Intent(context, CheckService.class));
        }
        int second = 5;

        Intent i = new Intent(context, RestartService.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0,
                i, 0);
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
        alarmManager.set(AlarmManager.RTC, System.currentTimeMillis() + second * 1000, pendingIntent);
    }
}
