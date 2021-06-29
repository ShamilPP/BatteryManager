package com.shamil.battery_manager;

import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.BatteryManager;
import android.os.Handler;
import android.os.IBinder;

import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import static com.shamil.battery_manager.MainActivity.isMyServiceRunning;


public class MyService extends Service {

    Context context = this;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        if (!isMyServiceRunning(context, MyService.class)) {
            ContextCompat.startForegroundService(context, new Intent(context, MyService.class));
        }
        super.onTaskRemoved(rootIntent);
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
        registerReceiver(new BatteryReceiver(), new IntentFilter(Intent.ACTION_BATTERY_CHANGED));

        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        if (!isMyServiceRunning(context, MyService.class)) {
            ContextCompat.startForegroundService(context, new Intent(context, MyService.class));
        }
        super.onDestroy();
    }
}