package com.shamil.battery_manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

public class BootReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        int second = 5;

        Intent i = new Intent(context, RestartService.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0,
                i, 0);
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        alarmManager.set(AlarmManager.RTC, System.currentTimeMillis() + second * 1000, pendingIntent);

    }
}
