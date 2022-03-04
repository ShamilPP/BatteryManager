package com.shamil.battery_manager;

import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.DownloadManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.PowerManager;
import android.provider.Settings;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static MediaPlayer mediaPlayer = new MediaPlayer();
    private static final String CHANNEL = "battery";
    public static SharedPreferences sharedpreferences;
    SharedPreferences.Editor editor;
    Intent actionBatteryChangedIntent;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "getBatteryLevel":
                                    int batteryLevel = getBatteryLevel();
                                    result.success(batteryLevel);
                                    break;
                                case "getCapacity":
                                    result.success(getBatteryCapacity() + " mAh");
                                    break;
                                case "getHealth":
                                    result.success(getBatteryHealth());
                                    break;
                                case "getMusic":
                                    result.success(getMusicPath());
                                    break;
                                case "setMusic":
                                    setMusic(call.argument("path"));
                                    break;
                                case "getMax":
                                    result.success(getMaxCharge());
                                    break;
                                case "setMax":
                                    setMaxCharge(call.argument("charge"));
                                    break;
                                case "getTime":
                                    result.success(getTime());
                                    break;
                                case "setTime":
                                    setTime(call.argument("time"));
                                    break;
                                case "getTemperature":
                                    result.success(getTemperature());
                                    break;
                                case "getDownloadPath":
                                    result.success(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString());
                                    break;
                                case "openDownloadFolder":
                                    startActivity(new Intent(DownloadManager.ACTION_VIEW_DOWNLOADS));
                                    break;
                            }
                        }
                );
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = new Intent();
        String packageName = getPackageName();
        PowerManager pm = (PowerManager) getSystemService(POWER_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setData(Uri.parse("package:" + packageName));
                startActivity(intent);
            }
        }

        sharedpreferences = getSharedPreferences("Battery", Context.MODE_PRIVATE);
        editor = sharedpreferences.edit();

        if (!sharedpreferences.contains("MaxCharge")) {
            editor.putInt("MaxCharge", 95);
            editor.putString("MusicPath", "Default ( Ring tone )");
            editor.apply();
        } else {
            if (sharedpreferences.getString("MusicPath", null).equals("Default") | sharedpreferences.getString("MusicPath", null).equals("Default ( Ring toon )")) {
                editor.putString("MusicPath", "Default ( Ring tone )");
                editor.apply();
            }
        }

        if (!sharedpreferences.contains("Time")) {
            editor.putString("Time", "Unlimited");
            editor.apply();
        }

        IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        actionBatteryChangedIntent = registerReceiver(null, intentFilter);

        int second = 2;

        Intent i = new Intent(this, ServiceChecker.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 0,
                i, 0);
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + second * 1000, pendingIntent);
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + second * 1000, pendingIntent);
        }
    }

    String getTemperature() {
        try {
            float temp = ((float) actionBatteryChangedIntent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) / 10);
            return temp + " °C";
        } catch (Exception e) {
            return "Getting Problem";
        }
    }

    String getBatteryHealth() {
        int currentCapacity = getBatteryCapacity();
        int maxCapacity = getBatteryMaxCapacity();
        double batteryHealth = ((double) currentCapacity / maxCapacity) * 100;
        int percentage = (int) batteryHealth;

        if (100 < percentage) {
            if (190 < percentage) {
                percentage = 10;
            } else {
                percentage = 200 - percentage;
            }
        } else if (10 > percentage) {
            percentage = 10;
        }
        return percentage + " %";
    }

    int getBatteryCapacity() {
        BatteryManager mBatteryManager = (BatteryManager) getSystemService(Context.BATTERY_SERVICE);
        int chargeCounter = mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER);
        int capacity = mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        if (chargeCounter == 0 || capacity == 0) {
            return getBatteryMaxCapacity();
        } else {
            return (chargeCounter / capacity / 10);
        }
    }

    int getBatteryMaxCapacity() {
        Object mPowerProfile;
        double batteryCapacity = 0;
        final String POWER_PROFILE_CLASS = "com.android.internal.os.PowerProfile";

        try {
            mPowerProfile = Class.forName(POWER_PROFILE_CLASS)
                    .getConstructor(Context.class)
                    .newInstance(this);

            batteryCapacity = (double) Class
                    .forName(POWER_PROFILE_CLASS)
                    .getMethod("getBatteryCapacity")
                    .invoke(mPowerProfile);

        } catch (Exception e) {
            e.printStackTrace();
        }
        int batteryMAH = (int) batteryCapacity;
        return batteryMAH;
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

    void setTime(String time) {
        editor.putString("Time", time);
        editor.apply();
    }

    String getTime() {
        return sharedpreferences.getString("Time", null);
    }

    void setMaxCharge(int charge) {
        editor.putInt("MaxCharge", charge);
        editor.apply();
    }

    int getMaxCharge() {
        return sharedpreferences.getInt("MaxCharge", 0);
    }

    public static boolean isMyServiceRunning(Context context, Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }
}
