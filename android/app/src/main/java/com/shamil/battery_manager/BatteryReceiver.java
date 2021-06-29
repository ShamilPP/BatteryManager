package com.shamil.battery_manager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.BatteryManager;

public class BatteryReceiver extends BroadcastReceiver {

    public static void CheckAndRing(Context context) {
        SharedPreferences sharedpreferences = context.getSharedPreferences("Battery", Context.MODE_PRIVATE);
        int maxBattery = sharedpreferences.getInt("MaxCharge", 0);
        String musicPath = sharedpreferences.getString("MusicPath", null);
        BatteryManager bm = (BatteryManager) context.getSystemService(Context.BATTERY_SERVICE);
        int batLevel = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = context.registerReceiver(null, intentFilter);
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
    public void onReceive(Context context, Intent intent) {
        CheckAndRing(context);
    }

}
