package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.zinging.hobbystar.AddProfileActivity;
import com.zinging.hobbystar.FullScreenPic;
import com.zinging.hobbystar.LinkActivity;
import com.zinging.hobbystar.Model.FormatNumbers;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.Post;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.Model.TimeAgo;
import com.zinging.hobbystar.R;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;


import java.util.HashMap;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class PostAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder>
{

    public Context mContext;
    public List<Post> mPost;

    private RecyclerView PostRecycler;
    private UnifiedNativeAd nativeAd;
    private static final int AD_DISPLAY_FREQUENCY = 6;
    private static final int Type_AD = 1;
    private static final int Type_Normal = 2;

    private FirebaseUser firebaseUser;

    public PostAdapter(Context mContext, List<Post> mPost) {
        this.mContext = mContext;
        this.mPost = mPost;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
    {
        if(i == Type_AD)
        {
           View view1 = LayoutInflater.from(mContext)
                    .inflate(R.layout.activity_f_m_l_k_m_s, viewGroup, false);
            return new UnifiedNativeAdViewHolder(view1);
        }else {
            View view = LayoutInflater.from(mContext).inflate(R.layout.post, viewGroup, false);
            return new PostAdapter.ViewHolder(view);
        }

    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder viewHolder1, int i)
    {
        int viewType = getItemViewType(i);
        switch(viewType)
        {
            case Type_AD:
                MobileAds.initialize(mContext, mContext.getString(R.string.NativeAd));

                UnifiedNativeAdViewHolder adViewHolder = (UnifiedNativeAdViewHolder) viewHolder1;

                refreshAd(adViewHolder.frameLayout);
//
                break;
            case Type_Normal:

                firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
                Post post = mPost.get(i);

                ViewHolder viewHolder = (ViewHolder) viewHolder1;

                TimeAgo getTimeAgoObject = new TimeAgo();

                FormatNumbers formatNumbers = new FormatNumbers();

                final String pid = mPost.get(i).getPostid();

                String userid = FirebaseAuth.getInstance().getUid();

                DatabaseReference postdescription = FirebaseDatabase.getInstance().getReference("Users");

                postdescription.child(post.getPublisher()).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.hasChild("points"))
                        {
                            viewHolder.Points.setText(snapshot.child("points").getChildrenCount()+" ");
                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });
                Long Time = post.getTimestamp();
                String NotifTime = getTimeAgoObject.getTimeAgo(Time,viewHolder.date.getContext());

                viewHolder.date.setText(NotifTime);

                Picasso.get().load(post.getPostimage()).into(viewHolder.Postimage);

                Rates(post.getTimestring(), viewHolder.Rating);
                nrRates(viewHolder.Rates, post.getTimestring());

                Dislikes(post.getTimestring(), viewHolder.postdislike);
                nrDislikes(viewHolder.dislike, post.getTimestring());

                Publisherinfo(viewHolder.Userimage, viewHolder.Username, post.getPublisher());

                viewHolder.Rating.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if(viewHolder.Rating.getTag().equals("Rate"))
                        {
                            FirebaseDatabase.getInstance().getReference().child("Rates").child(post.getTimestring())
                                    .child(firebaseUser.getUid()).setValue(true);
                            AddToNotification(post.getPublisher(), post.getPostid());

                        }else
                        {
                            FirebaseDatabase.getInstance().getReference().child("Rates").child(post.getTimestring())
                                    .child(firebaseUser.getUid()).removeValue();
                        }

                    }
                });

                viewHolder.postdislike.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if(viewHolder.postdislike.getTag().equals("Rate"))
                        {
                            FirebaseDatabase.getInstance().getReference().child("Dislikes").child(post.getTimestring())
                                    .child(firebaseUser.getUid()).setValue(true);
                            AddToNotification(post.getPublisher(), post.getPostid());

                        }else
                        {
                            FirebaseDatabase.getInstance().getReference().child("Dislikes").child(post.getTimestring())
                                    .child(firebaseUser.getUid()).removeValue();
                        }
                    }
                });

                viewHolder.Username.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent intent = new Intent(mContext, AddProfileActivity.class);
                        intent.putExtra("visit_user_id", post.getPublisher());
                        mContext.startActivity(intent);
                    }
                });

                viewHolder.Userimage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent intent = new Intent(mContext, AddProfileActivity.class);
                        intent.putExtra("visit_user_id", post.getPublisher());
                        mContext.startActivity(intent);
                    }
                });

//                viewHolder.Rates.setOnClickListener(new View.OnClickListener() {
//                    @Override
//                    public void onClick(View v) {
//                        Intent intent = new Intent(mContext, RatesActivity.class);
//                        intent.putExtra("rateid", post.getTimestring());
//                        mContext.startActivity(intent);
//                    }
//                });

                viewHolder.Postimage.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent intent = new Intent(mContext, FullScreenPic.class);
                        intent.putExtra("FullScreen", post.getPostimage());
                        mContext.startActivity(intent);
                    }
                });

                viewHolder.option.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if(post.getPublisher().equals(firebaseUser.getUid()))
                        {
                            String[] options = {"Delete", "Cancel"};

                            AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
                            builder.setItems(options, new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int i)
                                {
                                    if(i==0)
                                    {
                                        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Posts").child(post.getTimestring());
                                        ref.removeValue();
                                        DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference("Users").child(userid).child("post").child(post.getTimestring());
                                        ref1.removeValue();
                                        DatabaseReference ref2 = FirebaseDatabase.getInstance().getReference("PostNotifications").child(post.getTimestring());
                                        ref2.removeValue();
                                    }
                                    if(i==1)
                                    {
                                        dialog.cancel();
                                    }
                                }
                            })
                                    .show();
                        }else {
                            String[] options = {"Report", "Cancel"};

                            AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
                            builder.setItems(options, new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int i)
                                {
                                    if(i==0)
                                    {
                                        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Report").child(post.getPublisher()).child(post.getTimestring());
                                        ref.setValue("reported");
                                    }
                                    if(i==1)
                                    {
                                        dialog.cancel();
                                    }
                                }
                            })
                                    .show();
                        }
                    }
                });

                viewHolder.links.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Intent intent6 = new Intent(mContext, LinkActivity.class);
                        intent6.putExtra("LinkID", post.getPublisher());
                        mContext.startActivity(intent6);
                    }
                });

                break;
        }

    }

    private void refreshAd(FrameLayout frameLayout)
    {
        AdLoader.Builder builder = new AdLoader.Builder(mContext, mContext.getString(R.string.NativeAd));
        builder.forUnifiedNativeAd(new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
            @Override
            public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                if (nativeAd != null) {
                    nativeAd.destroy();
                }
                nativeAd = unifiedNativeAd;
                UnifiedNativeAdView adView = (UnifiedNativeAdView) LayoutInflater.from(mContext).inflate(R.layout.allweknow, null);
                populateUnifiedNativeAdView(unifiedNativeAd, adView);
                frameLayout.removeAllViews();
                frameLayout.addView(adView);
            }
        });
        NativeAdOptions adOptions = new NativeAdOptions.Builder().build();
        builder.withNativeAdOptions(adOptions);
        AdLoader adLoader = builder.withAdListener (new AdListener(){
            @Override
            public void onAdFailedToLoad(int i) {
            }
        }).build();
        adLoader.loadAd(new AdRequest.Builder().build());
    }

    private void populateUnifiedNativeAdView(UnifiedNativeAd nativeAd, UnifiedNativeAdView adView) {
        adView.setMediaView((MediaView) adView.findViewById(R.id.ad_media));
        adView.setHeadlineView(adView.findViewById(R.id.ad_headline));
        adView.setBodyView(adView.findViewById(R.id.ad_body));
        adView.setCallToActionView(adView.findViewById(R.id.ad_call_to_action));
        adView.setIconView(adView.findViewById(R.id.ad_app_icon));
        adView.setPriceView(adView.findViewById(R.id.ad_price));
        adView.setAdvertiserView(adView.findViewById(R.id.ad_advertiser));
        adView.setStoreView(adView.findViewById(R.id.ad_store));
        adView.setStarRatingView(adView.findViewById(R.id.ad_stars));
        ((TextView) adView.getHeadlineView()).setText(nativeAd.getHeadline());
        adView.getMediaView().setMediaContent(nativeAd.getMediaContent());
        if (nativeAd.getBody() == null) {
            adView.getBodyView().setVisibility(View.INVISIBLE);
        } else {
            adView.getBodyView().setVisibility(View.VISIBLE);
            ((TextView) adView.getBodyView()).setText(nativeAd.getBody());
        }
        if (nativeAd.getCallToAction() == null) {
            adView.getCallToActionView().setVisibility(View.INVISIBLE);
        } else {
            adView.getCallToActionView().setVisibility(View.VISIBLE);
            ((Button) adView.getCallToActionView()).setText(nativeAd.getCallToAction());
        }
        if (nativeAd.getIcon() == null) {
            adView.getIconView().setVisibility(View.GONE);
        } else {
            ((ImageView) adView.getIconView()).setImageDrawable(nativeAd.getIcon().getDrawable());
            adView.getIconView().setVisibility(View.VISIBLE);
        }
        if (nativeAd.getPrice() == null) {
            adView.getPriceView().setVisibility(View.INVISIBLE);
        } else {
            adView.getPriceView().setVisibility(View.VISIBLE);
            ((TextView) adView.getPriceView()).setText(nativeAd.getPrice());
        }
        if (nativeAd.getStore() == null) {
            adView.getStoreView().setVisibility(View.INVISIBLE);
        } else {
            adView.getStoreView().setVisibility(View.VISIBLE);
            ((TextView) adView.getStoreView()).setText(nativeAd.getStore());
        }
        if (nativeAd.getStarRating() == null) {
            adView.getStarRatingView().setVisibility(View.INVISIBLE);
        } else {
            ((RatingBar) adView.getStarRatingView()).setRating(nativeAd.getStarRating().floatValue());
            adView.getStarRatingView().setVisibility(View.VISIBLE);
        }
        if (nativeAd.getAdvertiser() == null) {
            adView.getAdvertiserView().setVisibility(View.INVISIBLE);
        } else {
            ((TextView) adView.getAdvertiserView()).setText(nativeAd.getAdvertiser());
            adView.getAdvertiserView().setVisibility(View.VISIBLE);
        }
        adView.setNativeAd(nativeAd);
    }

    @Override
    public int getItemCount() {
        return mPost.size();
    }

    @Override
    public int getItemViewType(int position)
    {
        return position % AD_DISPLAY_FREQUENCY == 0 && position != 0 ? Type_AD :Type_Normal;
//        if (position!=0 && position%4 == 0) {
//            return Type_AD;
//        }
//        return Type_Normal;
    }
    
    public class ViewHolder extends RecyclerView.ViewHolder
    {
        public ImageView Postimage, Rating, option, Sharing, postdislike, links;
        public TextView Points, Rates, description, date, Username, dislike;
        public CircleImageView Userimage;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            Postimage = itemView.findViewById(R.id.post_image);
            Rating = itemView.findViewById(R.id.Rate);
            Rates = itemView.findViewById(R.id.PostRates);
            dislike = itemView.findViewById(R.id.Post_Dislike);
            date = itemView.findViewById(R.id.Post_Time);
            postdislike = itemView.findViewById(R.id.DislikeEmoji);
            Username = itemView.findViewById(R.id.Post_Username);
            Userimage = itemView.findViewById(R.id.Post_profileimg);
            Points = itemView.findViewById(R.id.NoOfPoints);
            links = itemView.findViewById(R.id.Link);
            option = itemView.findViewById(R.id.OptionImage);

        }

    }

    public class UnifiedNativeAdViewHolder extends RecyclerView.ViewHolder
    {
        private FrameLayout frameLayout;

        public UnifiedNativeAdViewHolder(@NonNull View itemView)
        {
            super(itemView);

            frameLayout = itemView.findViewById(R.id.fl_adplaceholder);
        }
    }

    private void Rates(String postid, ImageView imageView)
    {
        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        DatabaseReference reference = FirebaseDatabase.getInstance().getReference()
                .child("Rates")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.child(firebaseUser.getUid()).exists())
                {
                    imageView.setImageResource(R.drawable.ic_green_smiley);
                    imageView.setTag("Rated");
                }else{
                    imageView.setImageResource(R.drawable.ic_satisfied_alt_24);
                    imageView.setTag("Rate");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
    private void Dislikes(String postid, ImageView imageView)
    {
        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        DatabaseReference reference = FirebaseDatabase.getInstance().getReference()
                .child("Dislikes")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.child(firebaseUser.getUid()).exists())
                {
                    imageView.setImageResource(R.drawable.ic_unhappy);
                    imageView.setTag("Rated");
                }else{
                    imageView.setImageResource(R.drawable.ic_very_dissatisfied_24);
                    imageView.setTag("Rate");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }


    private void AddToNotification(String userid, String Postid)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Notifications").child(userid);


        long date = System.currentTimeMillis();

        String timestamp = String.valueOf(System.currentTimeMillis());

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("userid", firebaseUser.getUid());
        hashMap.put("text", "Has Rated your pic!");
        hashMap.put("postid", Postid);
        hashMap.put("impost", true);
        hashMap.put("date", date);
        hashMap.put("timestamp", timestamp);

        ref.child(timestamp).setValue(hashMap);

    }

    private void nrRates(TextView Rates, String postid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Rates")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Rates.setText(snapshot.getChildrenCount()+ " likes");
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
    private void nrDislikes(TextView Rates, String postid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Dislikes")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Rates.setText(snapshot.getChildrenCount()+ " dislikes");
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void Publisherinfo(CircleImageView Userimage, TextView Username, String userid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Users").child(userid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Message user = snapshot.getValue(Message.class);
                if(snapshot.hasChild("profileimage")) {
                    String image = snapshot.child("profileimage").getValue().toString();
                    Picasso.get().load(image).into(Userimage);
                }
                Username.setText(user.getUsername());
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

}
