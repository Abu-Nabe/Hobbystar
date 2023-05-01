package com.zinging.hobbystar;

import android.os.Bundle;

import android.app.Activity;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.squareup.picasso.Picasso;

public class FullScreenPic extends Activity {

    private RelativeLayout relativeLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_full_screen_pic);

        ImageView imgDisplay;

        String fullscreen = getIntent().getStringExtra("FullScreen");

        imgDisplay = (ImageView) findViewById(R.id.imgDisplay);
        relativeLayout = (RelativeLayout) findViewById(R.id.Relative);

        Picasso.get().load(fullscreen).into(imgDisplay);

        imgDisplay.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                FullScreenPic.this.finish();
            }
        });

    }
}