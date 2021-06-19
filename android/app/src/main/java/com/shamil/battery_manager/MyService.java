package com.shamil.battery_manager;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.BatteryManager;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.IBinder;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;


public class MyService extends Service {

    Runnable runnable;
    Handler handler;
    Context context = this;

    public static void CheckAndRing(Context context) {
        SharedPreferences sharedpreferences = context.getSharedPreferences("Battery", Context.MODE_PRIVATE);
        int maxBattery = sharedpreferences.getInt("MaxCharge", 0);
        String musicPath = sharedpreferences.getString("MusicPath", null);
        BatteryManager bm = (BatteryManager) context.getSystemService(Context.BATTERY_SERVICE);
        int batLevel = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = context.registerReceiver(null, ifilter);
        int chargePlug = batteryStatus.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
        if (chargePlug == BatteryManager.BATTERY_PLUGGED_USB || chargePlug == BatteryManager.BATTERY_PLUGGED_AC) {
            if (batLevel >= maxBattery) {
                Charged.fullCharged(context, musicPath);
            } else {
                Charged.stopAlert();
            }
        } else {
            Charged.stopAlert();
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Intent serviceIntent = new Intent(this, MyService.class);
        startService(serviceIntent);
        super.onTaskRemoved(rootIntent);
    }

    @Override
    public void onCreate() {
        handler = new Handler();
        runnable = () -> {
            CheckAndRing(context);
            handler.postDelayed(runnable, 1000);
        };

        handler.postDelayed(runnable, 1000);
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, 0);

        Notification notification = new NotificationCompat.Builder(this, App.CHANNEL_ID)
                .setContentTitle("Battery manager")
                .setContentText("Battery manager service started")
                .setSmallIcon(R.mipmap.icon_foreground)
                .setContentIntent(pendingIntent)
                .build();

        startForeground(1, notification);

        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        Intent serviceIntent = new Intent(this, MyService.class);
        startService(serviceIntent);
        super.onDestroy();
    }
}