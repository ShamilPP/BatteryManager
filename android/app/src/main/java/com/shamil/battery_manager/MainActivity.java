package com.shamil.battery_manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.media.MediaPlayer;
import android.os.BatteryManager;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static MediaPlayer mediaPlayer = new MediaPlayer();
    private static final String CHANNEL = "battery";
    public static SharedPreferences sharedpreferences;
    public static AlarmManager alarmManager;
    SharedPreferences.Editor editor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
        sharedpreferences = getSharedPreferences("Battery", Context.MODE_PRIVATE);
        editor = sharedpreferences.edit();
        if (!sharedpreferences.contains("MaxCharge")) {
            editor.putInt("MaxCharge", 95);
            editor.putString("MusicPath", "Default");
            editor.apply();
        }
        IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = registerReceiver(null, intentFilter);

        int deviceStatus = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        if (deviceStatus == BatteryManager.BATTERY_PLUGGED_AC | deviceStatus == BatteryManager.BATTERY_PLUGGED_USB) {
            Intent i = new Intent(this, CheckService.class);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 0,
                    i, 0);

            int second = 5;

            alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);

            alarmManager.setExact(AlarmManager.RTC, System.currentTimeMillis() + second * 1000, pendingIntent);
        }
    }


    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();
                                result.success(batteryLevel);
                            } else if (call.method.equals("getMusic")) {
                                result.success(getMusicPath());
                            } else if (call.method.equals("setMusic")) {
                                setMusic(call.argument("path"));
                            } else if (call.method.equals("getMax")) {
                                result.success(getMaxCharge());
                            } else if (call.method.equals("setMax")) {
                                setMaxCharge(call.argument("charge"));
                            }
                        }
                );
    }

    private int getBatteryLevel() {
        int batteryLevel;
        BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);

        return batteryLevel;
    }

    void setMusic(String path) {
        editor.putString("MusicPath", path);
        editor.apply();
    }

    String getMusicPath() {
        return sharedpreferences.getString("MusicPath", null);
    }

    void setMaxCharge(int charge) {
        editor.putInt("MaxCharge", charge);
        editor.apply();
    }

    int getMaxCharge() {
        return sharedpreferences.getInt("MaxCharge", 0);
    }

}
