package com.shamil.battery_manager;

import static android.content.Context.AUDIO_SERVICE;
import static com.shamil.battery_manager.MainActivity.view;
import static com.shamil.battery_manager.MainActivity.windowManager;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.PixelFormat;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Handler;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Toast;

import java.io.IOException;

public class Charged {

    public static void fullCharged(Context context, String music) {
        SharedPreferences sharedpreferences = context.getSharedPreferences("Battery", Context.MODE_PRIVATE);
        try {
            AudioManager audioManager = (AudioManager) context.getSystemService(AUDIO_SERVICE);
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC), 0);
            MediaPlayer mediaPlayer = MainActivity.mediaPlayer;
            if (!mediaPlayer.isPlaying()) {
                if (music.equals("Default ( Ring toon )")) {
                    Uri ringtone = RingtoneManager.getActualDefaultRingtoneUri(context.getApplicationContext(), RingtoneManager.TYPE_RINGTONE);
                    mediaPlayer.setDataSource(context, ringtone);
                } else {
                    mediaPlayer.setDataSource(context, Uri.parse(music));
                }
                showRingScreen(context);
                mediaPlayer.prepare();
                mediaPlayer.start();
                mediaPlayer.setLooping(true);
                if (sharedpreferences.contains("Time")) {
                    String time = sharedpreferences.getString("Time", null);
                    if (!time.equals("Unlimited")) {
                        new Handler().postDelayed(Charged::stopAlert, Integer.parseInt(time));
                    }
                }
            }
        } catch (Exception e) {
            try {
                Uri ringtone = RingtoneManager.getActualDefaultRingtoneUri(context.getApplicationContext(), RingtoneManager.TYPE_RINGTONE);
                MainActivity.mediaPlayer.setDataSource(context, ringtone);
                MainActivity.mediaPlayer.prepare();
                MainActivity.mediaPlayer.start();
                MainActivity.mediaPlayer.setLooping(true);
                if (sharedpreferences.contains("Time")) {
                    String time = sharedpreferences.getString("Time", null);
                    if (!time.equals("Unlimited")) {
                        new Handler().postDelayed(Charged::stopAlert, Integer.parseInt(time));
                    }
                }
            } catch (IOException ioException) {
                Toast.makeText(context, "Battery Manager Error Detected", Toast.LENGTH_SHORT).show();
            }
        }
    }


    public static void stopAlert() {

        if (windowManager != null) {
            if (view.isShown()) {
                windowManager.removeView(view);
            }
        }
        MediaPlayer mediaPlayer = MainActivity.mediaPlayer;
        if (mediaPlayer.isPlaying()) {
            mediaPlayer.reset();
        }
    }

    public static void showRingScreen(Context context) {
        MainActivity.turnScreenOn(context);

        WindowManager.LayoutParams mLayoutParams = new WindowManager.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT, 0, 0,
                WindowManager.LayoutParams.TYPE_SYSTEM_OVERLAY,
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                        | WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD,
                PixelFormat.RGBA_8888);
        MainActivity.windowManager.addView(view, mLayoutParams);
    }
}
