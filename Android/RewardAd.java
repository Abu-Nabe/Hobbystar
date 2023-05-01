package com.zinging.hobbystar;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.reward.RewardItem;
import com.google.android.gms.ads.reward.RewardedVideoAd;
import com.google.android.gms.ads.reward.RewardedVideoAdListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class RewardAd extends AppCompatActivity implements RewardedVideoAdListener
{
    RewardedVideoAd rewardedVideoAd;
    TextView textView;
    Button button;
    ProgressBar progressBar;

    FloatingActionButton cancel;
    int value = 0;

    FirebaseAuth mAuth;
    DatabaseReference UsersRef;

    String currentuserid;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.reward_ad);

        textView = (TextView) findViewById(R.id.text_view);
        button = (Button) findViewById(R.id.button);
        cancel = (FloatingActionButton) findViewById(R.id.CancelPic);
        progressBar = findViewById(R.id.ProgressBar);

        mAuth = FirebaseAuth.getInstance();
        currentuserid = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(currentuserid);

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("zings"))
                    {
                        textView.setText(snapshot.child("zings").getChildrenCount()+"");
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        progressBar.setVisibility(View.INVISIBLE);

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                progressBar.setVisibility(View.VISIBLE);
                if(rewardedVideoAd.isLoaded())
                {
                    progressBar.setVisibility(View.INVISIBLE);
                    button.setText("earn zings by watching video");
                    rewardedVideoAd.show();
                }
            }
        });

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                finish();
            }
        });
        MobileAds.initialize(this, "ca-app-pub-9964353647597239~2190302076");
        rewardedVideoAd = MobileAds.getRewardedVideoAdInstance(this);
        rewardedVideoAd.setRewardedVideoAdListener(this);
        loadAds();
    }

    private void loadAds()
    {
        rewardedVideoAd.loadAd("ca-app-pub-9964353647597239/3495080549", new AdRequest.Builder().build());
    }

    @Override
    public void onRewardedVideoAdLoaded()
    {
        button.setText("ready to play");
    }

    @Override
    public void onRewardedVideoAdOpened() {

    }

    @Override
    public void onRewardedVideoStarted() {

    }

    @Override
    public void onRewardedVideoAdClosed() {
        loadAds();
    }

    @Override
    public void onRewarded(RewardItem rewardItem) {

        UsersRef.child("zings").push().setValue(1).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                UsersRef.child("zings").push().setValue(1).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        UsersRef.child("zings").push().setValue(1).addOnSuccessListener(new OnSuccessListener<Void>() {
                            @Override
                            public void onSuccess(Void aVoid) {
                                UsersRef.child("zings").push().setValue(1).addOnSuccessListener(new OnSuccessListener<Void>() {
                                    @Override
                                    public void onSuccess(Void aVoid) {
                                        UsersRef.child("zings").push().setValue(1).addOnSuccessListener(new OnSuccessListener<Void>() {
                                            @Override
                                            public void onSuccess(Void aVoid) {
                                                UsersRef.addValueEventListener(new ValueEventListener() {
                                                    @Override
                                                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                                                        if(snapshot.exists())
                                                        {
                                                            if(snapshot.hasChild("zings"))
                                                            {
                                                                textView.setText(snapshot.child("zings").getChildrenCount()+"");
                                                            }
                                                        }
                                                    }

                                                    @Override
                                                    public void onCancelled(@NonNull DatabaseError error) {

                                                    }
                                                });
                                            }
                                        });
                                    }
                                });
                            }
                        });
                    }
                });
            }
        });
    }

    @Override
    public void onRewardedVideoAdLeftApplication() {

    }

    @Override
    public void onRewardedVideoAdFailedToLoad(int i) {

    }

    @Override
    public void onRewardedVideoCompleted() {

    }

    @Override
    protected void onPostResume()
    {
        rewardedVideoAd.resume(this);
        super.onPostResume();
    }

    @Override
    protected void onPause() {
        rewardedVideoAd.pause(this);
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        rewardedVideoAd.destroy(this);
        super.onDestroy();
    }
}
