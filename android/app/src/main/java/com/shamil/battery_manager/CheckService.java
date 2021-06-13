package com.shamil.battery_manager;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.widget.Toast;

public class CheckService extends Service {

    public static Runnable runnable = null;
    public Context context = this;
    public Handler handler = null;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startForegroundService(new Intent(context, CheckService.class));
                } else {
                    startService(new Intent(context, CheckService.class));
                }
            }
        }, 1000);

    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Intent restartServiceIntent = new Intent(getApplicationContext(), this.getClass());
        restartServiceIntent.setPackage(getPackageName());
        startService(restartServiceIntent);
        super.onTaskRemoved(rootIntent);
    }

    @Override
    public void onCreate() {
        handler = new Handler();
        runnable = new Runnable() {
            public void run() {
                getChargeAndRing();
                handler.postDelayed(runnable, 1000);
            }
        };

        handler.postDelayed(runnable, 1000);

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        onTaskRemoved(intent);
        return START_STICKY;
    }

    void getChargeAndRing() {
        try {
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
                    Charged.stopAlert(context);
                }
            } else {
                Charged.stopAlert(context);
            }
        } catch (Exception e) {
            Toast.makeText(context, e.toString(), Toast.LENGTH_LONG).show();
        }
    }
}