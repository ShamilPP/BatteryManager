package com.shamil.battery_manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

public class ChargingReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Intent i = new Intent(context, CheckService.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 1,
                i, 0);
        try {
            if (intent.getAction().equals(Intent.ACTION_POWER_CONNECTED)) {
                int second = 5;

                MainActivity.alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

                MainActivity.alarmManager.setExact(AlarmManager.RTC, System.currentTimeMillis() + second * 1000, pendingIntent);
            } else {
                MainActivity.alarmManager.cancel(pendingIntent);
                Charged.stopAlert(context);
            }
        } catch (Exception e) {
        }
    }
}
