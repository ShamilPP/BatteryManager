package com.shamil.battery_manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.BatteryManager;
import android.os.Build;
import android.widget.Toast;

import androidx.annotation.RequiresApi;

import static android.content.Context.ALARM_SERVICE;

public class CheckService extends BroadcastReceiver {
    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            Intent i = new Intent(context, CheckService.class);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0,
                    i, 0);

            IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            Intent batteryStatus = context.registerReceiver(null, intentFilter);

            SharedPreferences sharedpreferences = context.getSharedPreferences("Battery", Context.MODE_PRIVATE);
            int maxBattery = sharedpreferences.getInt("MaxCharge", 0);
            String musicPath = sharedpreferences.getString("MusicPath", null);
            int deviceStatus = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            if (deviceStatus == BatteryManager.BATTERY_PLUGGED_AC | deviceStatus == BatteryManager.BATTERY_PLUGGED_USB) {
                BatteryManager bm = (BatteryManager) context.getSystemService(Context.BATTERY_SERVICE);
                int batLevel = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
                if (batLevel >= maxBattery) {
                    try {
                        Charged.fullCharged(context, musicPath);
                    } catch (Exception e) {
                        Toast.makeText(context, e.toString() + "\nProblem detected", Toast.LENGTH_LONG).show();
                    }
                } else {
                    int second = 5;
                    MainActivity.alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
                    MainActivity.alarmManager.set(AlarmManager.RTC, System.currentTimeMillis() + second * 1000, pendingIntent);
                }
            } else {
                MainActivity.alarmManager.cancel(pendingIntent);
                Charged.stopAlert(context);
            }
        } catch (Exception e) {
            Toast.makeText(context, e.toString(), Toast.LENGTH_LONG).show();
        }
    }
}
