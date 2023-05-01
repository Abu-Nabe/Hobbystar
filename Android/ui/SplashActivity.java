package com.zinging.hobbystar.ui;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;

//import com.example.afinal.BasicShit;
import com.zinging.hobbystar.HomeActivity;
import com.zinging.hobbystar.LoginActivity;
import com.zinging.hobbystar.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class SplashActivity extends AppCompatActivity {

    // Constant Time Delay (this means 2.5 seconds)
    private final int SPLASH_DELAY = 3500;

    // Fields (Widgets)
    private ImageView imageView;

    @Override
    protected void onStart() {
        super.onStart();

        FirebaseUser currentUser = FirebaseAuth.getInstance().getCurrentUser();

        if(currentUser == null)
        {
            initializeView();
            animateLogo();
            goToLoginActivity();
        }
        else{
            Intent intent = new Intent(SplashActivity.this, HomeActivity.class);
            startActivity(intent);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);



        getWindow().setBackgroundDrawable(null);

        // Methods to call
        //initializeView();
//        animateLogo();
//        goToLoginActivity();
    }

    private void goToLoginActivity() {
        // This method will take the user to main activity when animation is finished9
        new Handler().postDelayed(()-> {
            startActivity(new Intent(SplashActivity.this, LoginActivity.class));
            finish();
        }, SPLASH_DELAY);
    }


    private void initializeView() {
        imageView = findViewById(R.id.imageView2);
    }


    private void animateLogo() {
        // this method will animate logo
        Animation fadingInAnimation = AnimationUtils.loadAnimation(this,R.anim.fade_in);
        fadingInAnimation.setDuration(SPLASH_DELAY);

        imageView.startAnimation(fadingInAnimation);

    }
}
