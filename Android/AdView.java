//package com.example.afinal;
//
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.recyclerview.widget.LinearLayoutManager;
//import androidx.recyclerview.widget.RecyclerView;
//
//import android.os.Bundle;
//import android.view.View;
//import android.widget.Button;
//
//import com.google.android.gms.ads.AdLoader;
//import com.google.android.gms.ads.MobileAds;
//import com.google.android.gms.ads.formats.UnifiedNativeAd;
//import com.google.android.gms.ads.formats.UnifiedNativeAdView;
//import com.google.android.gms.ads.initialization.InitializationStatus;
//import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;
//
//public class AdView extends AppCompatActivity {
//
//    private UnifiedNativeAd nativeAd;
//    private Button sofkindone;
//    private RecyclerView fkinview;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState)
//    {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_ad_view);
//
//        MobileAds.initialize(this, new OnInitializationCompleteListener() {
//            @Override
//            public void onInitializationComplete(InitializationStatus initializationStatus) {
//
//            }
//        });
//
//        fkinview = (RecyclerView) findViewById(R.id.AdRecyclerView);
//        fkinview.setHasFixedSize(true);
//        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
//        linearLayoutManager.setReverseLayout(true);
//        linearLayoutManager.setStackFromEnd(true);
//        fkinview.setLayoutManager(linearLayoutManager);
//
//        sofkindone = (Button) findViewById(R.id.confirm);
//        sofkindone.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                refreshAd();
//            }
//        });
//
//        refreshAd();
//
//    }
//
//    private void refreshAd()
//    {
//        sofkindone.setEnabled(false);
//        AdLoader.Builder builder = new AdLoader.Builder(this,getString(R.string.NativeAd));
//        builder.forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
//            @Override
//            public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
//                if(nativeAd != null)
//                {
//                    nativeAd = unifiedNativeAd;
//                    UnifiedNativeAdView adView = (UnifiedNativeAdView) getLayoutInflater().inflate(R.layout.adlayout, null);
//                    populateNativeAd(unifiedNativeAd, adView);
//                    fkinview.addView(adView);
//                    sofkindone.setEnabled(true);
//                }
//            }
//        });
//    }
//
//    private void populateNativeAd(UnifiedNativeAd nativeAd, UnifiedNativeAdView adView)
//    {
//        adView.setHeadlineView(adView.findViewById(R.id.AdType));
//        adView.setAdvertiserView(adView.findViewById(R.id.Post_Username));
//        adView.setIconView(adView.findViewById(R.id.Post_profileimg));
//        adView.setMediaView(adView.findViewById(R.id.post_image));
//
//        adView.getMediaView().setMediaContent(nativeAd.getMediaContent());
//    }
//}