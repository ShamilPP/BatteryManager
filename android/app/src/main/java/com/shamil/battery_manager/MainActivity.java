package com.shamil.battery_manager;

import android.app.ActivityManager;
import android.app.AlarmManager;
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
import android.os.PowerManager;
import android.provider.Settings;
import android.widget.Toast;

import androidx.core.content.ContextCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    public static MediaPlayer mediaPlayer = new MediaPlayer();
    private static final String CHANNEL = "battery";
    public static SharedPreferences sharedpreferences;
    SharedPreferences.Editor editor;

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
            editor.putString("MusicPath", "Default ( Ring toon )");
            editor.apply();
        }

        int second = 2;

        Intent i = new Intent(this, ServiceChecker.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 0,
                i, 0);
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + second * 1000, pendingIntent);
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
                            } else if (call.method.equals("getMAH")) {
                                result.success(getBatteryMAH());
                            } else if (call.method.equals("getHealth")) {
                                result.success(getBatteryHealth());
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

    String getBatteryHealth() {

        IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent intent = registerReceiver(null, intentFilter);
        int deviceHealth = intent.getIntExtra(BatteryManager.EXTRA_HEALTH, 0);

        if (deviceHealth == BatteryManager.BATTERY_HEALTH_COLD) {
            return "Cold";
        } else if (deviceHealth == BatteryManager.BATTERY_HEALTH_DEAD) {
            return "Dead";
        } else if (deviceHealth == BatteryManager.BATTERY_HEALTH_GOOD) {
            return "Good";
        } else if (deviceHealth == BatteryManager.BATTERY_HEALTH_OVERHEAT) {
            return "OverHeat";
        } else if (deviceHealth == BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE) {
            return "Over voltage";
        } else if (deviceHealth == BatteryManager.BATTERY_HEALTH_UNKNOWN) {
            return "Unknown";
        } else if (deviceHealth == BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE) {
            return "Unspecified Failure";
        }
        return "Getting Problem";


    }

    String getBatteryMAH() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager mBatteryManager = (BatteryManager) getSystemService(Context.BATTERY_SERVICE);
            int chargeCounter = mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER);
            int capacity = mBatteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);

            if (chargeCounter == Integer.MIN_VALUE || capacity == Integer.MIN_VALUE) {
                return "Getting Problem";
            } else {
                return (chargeCounter / capacity / 10) + " mAh";
            }
        }
        return "Getting Problem";
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
