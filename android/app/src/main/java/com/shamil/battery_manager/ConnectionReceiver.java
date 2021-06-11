package com.shamil.battery_manager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.BatteryManager;
import android.os.Build;
import android.widget.Toast;

import androidx.annotation.RequiresApi;

public class ConnectionReceiver extends BroadcastReceiver {
    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    public void onReceive(Context context, Intent intent) {
        SharedPreferences sharedpreferences = context.getSharedPreferences("Battery", Context.MODE_PRIVATE);
        int maxBattery = sharedpreferences.getInt("MaxCharge", 0);
        String musicPath = sharedpreferences.getString("MusicPath",null);
        int deviceStatus = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
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

    }
}

