package com.shamil.battery_manager;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;

import static android.content.Context.AUDIO_SERVICE;
import static android.media.AudioManager.STREAM_MUSIC;
public class Charged {

    public static void fullCharged(Context context, String music) throws Exception {
        AudioManager audioManager = (AudioManager) context.getSystemService(AUDIO_SERVICE);
        audioManager.setStreamVolume(STREAM_MUSIC, 15, AudioManager.FLAG_PLAY_SOUND);
        MediaPlayer mediaPlayer = MainActivity.mediaPlayer;
        if (!mediaPlayer.isPlaying()) {
            if (music.equals("Default")) {
                Uri ringtone = RingtoneManager.getActualDefaultRingtoneUri(context.getApplicationContext(), RingtoneManager.TYPE_RINGTONE);
                mediaPlayer.setDataSource(context, ringtone);
            } else {
                mediaPlayer.setDataSource(context, Uri.parse(music));
            }
            mediaPlayer.prepare();
            mediaPlayer.start();
            mediaPlayer.setLooping(true);
            showNotification(context);
        }
    }

    private static void showNotification(Context context) {
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context, "Battery")
                .setSmallIcon(R.mipmap.icon)
                .setContentTitle("Battery Charged")
                .setContentText("Please remove plugged charger")
                .setOngoing(true)
                .setAutoCancel(true);

        NotificationManager notificationManager =
                (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (notificationManager != null)
            notificationManager.notify(35, notificationBuilder.build());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Battery Charged";
            String description = "Please remove plugged charger";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel("Battery", name, importance);
            channel.setDescription(description);
            notificationManager.createNotificationChannel(channel);
        }
    }

    static void cancelNotification(Context context) {
        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        manager.cancel(35);
    }


    public static void stopAlert(Context context) {
        MediaPlayer mediaPlayer = MainActivity.mediaPlayer;
        if (mediaPlayer.isPlaying()) {
            mediaPlayer.reset();
            cancelNotification(context);
        }
    }
}
