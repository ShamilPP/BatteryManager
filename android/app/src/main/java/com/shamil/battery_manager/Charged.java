package com.shamil.battery_manager;

import static android.content.Context.AUDIO_SERVICE;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.RingtoneManager;
import android.net.Uri;
import android.widget.Toast;

import java.io.IOException;

public class Charged {

    public static void fullCharged(Context context, String music) {
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
                mediaPlayer.prepare();
                mediaPlayer.start();
                mediaPlayer.setLooping(true);
            }
        } catch (Exception e) {
            try {
                Uri ringtone = RingtoneManager.getActualDefaultRingtoneUri(context.getApplicationContext(), RingtoneManager.TYPE_RINGTONE);
                MainActivity.mediaPlayer.setDataSource(context, ringtone);
                MainActivity.mediaPlayer.prepare();
                MainActivity.mediaPlayer.start();
                MainActivity.mediaPlayer.setLooping(true);
            } catch (IOException ioException) {
                Toast.makeText(context, "Battery Manager Error Detected", Toast.LENGTH_SHORT).show();
            }
        }
    }


    public static void stopAlert() {
        MediaPlayer mediaPlayer = MainActivity.mediaPlayer;
        if (mediaPlayer.isPlaying()) {
            mediaPlayer.reset();
        }
    }
}
