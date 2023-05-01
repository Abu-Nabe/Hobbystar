package com.zinging.hobbystar.Adapter;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.TextView;
import android.widget.VideoView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.AddProfileActivity;
import com.zinging.hobbystar.CommentActivity;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.TimeAgo;
import com.zinging.hobbystar.Model.ZingingModel;
import com.zinging.hobbystar.R;
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

public class ZingingVideoAdapter extends RecyclerView.Adapter<ZingingVideoAdapter.ViewHolder>
{
    public Context mContext;
    public List<ZingingModel> mZinging;

    public FirebaseUser firebaseUser;
    String state = "volume";

    public ZingingVideoAdapter(Context mContext, List<ZingingModel> mZinging) {
        this.mContext = mContext;
        this.mZinging = mZinging;
    }

    @NonNull
    @Override
    public ZingingVideoAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(mContext).inflate(R.layout.zinging_vids, viewGroup, false);
        return new ZingingVideoAdapter.ViewHolder(view);
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onBindViewHolder(@NonNull ZingingVideoAdapter.ViewHolder viewHolder, int i)
    {
        firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
        ZingingModel zinging = mZinging.get(i);

        TimeAgo GetTimeAgoObject = new TimeAgo();

        if(zinging.getVideoName().equals(""))
        {
            viewHolder.description.setVisibility(View.GONE);
        } else {
            viewHolder.description.setVisibility(View.VISIBLE);
            viewHolder.description.setText(zinging.getVideoName());
        }

        viewHolder.Hobby.setText(zinging.getVideoHobby());

        Publisherinfo(viewHolder.Userimage, viewHolder.Username, viewHolder.points,zinging.getVideoPublisher());

        String currentuser = FirebaseAuth.getInstance().getCurrentUser().getUid();

        Rates(zinging.getTimestring(), viewHolder.Rating);
        nrRates(viewHolder.Rates, zinging.getTimestring());


        String videoUrl = zinging.getVideoUrl();

        MediaController mediaController = new MediaController(mContext);
        mediaController.setAnchorView(viewHolder.videoview);
        Uri videoUri = Uri.parse(videoUrl);

        VideoUri(zinging.getTimestring(), viewHolder.videoview, videoUri, viewHolder.PlayVid);

        viewHolder.Rating.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(viewHolder.Rating.getTag().equals("Rate"))
                {
                    FirebaseDatabase.getInstance().getReference().child("Rates").child(zinging.getTimestring())
                            .child(firebaseUser.getUid()).setValue(true);
                    FirebaseDatabase.getInstance().getReference("Users").child(zinging.getVideoPublisher()).child("points").child(zinging.getVideoID())
                            .child(firebaseUser.getUid()).setValue(true);
                    AddToNotification(zinging.getVideoPublisher(), zinging.getVideoID());

                }else
                {
                    FirebaseDatabase.getInstance().getReference().child("Rates").child(zinging.getTimestring())
                            .child(firebaseUser.getUid()).removeValue();
                    FirebaseDatabase.getInstance().getReference("Users").child(zinging.getVideoPublisher()).child("points").child(zinging.getVideoID())
                            .child(firebaseUser.getUid()).removeValue();
                }

            }
        });

        viewHolder.Comment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mContext, CommentActivity.class);
                intent.putExtra("postid", zinging.getTimestring());
                intent.putExtra("publisherid", zinging.getVideoPublisher());
                mContext.startActivity(intent);
            }
        });

        viewHolder.option.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(zinging.getVideoPublisher().equals(firebaseUser.getUid()))
                {
                    String[] options = {"Delete", "Cancel"};

                    AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
                    builder.setItems(options, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int i)
                        {
                            if(i==0)
                            {
                                DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Videos").child(zinging.getTimestring());
                                ref.removeValue();
                                DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference("Users").child(firebaseUser.getUid()).child("zingingvid").child(zinging.getTimestring());
                                ref1.removeValue();
                                DatabaseReference ref2 = FirebaseDatabase.getInstance().getReference("PostNotifications").child(zinging.getTimestring());
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
                                DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Report").child(zinging.getVideoPublisher()).child(zinging.getTimestring());
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

        viewHolder.Userimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", zinging.getVideoPublisher());
                mContext.startActivity(intent);
            }
        });
        viewHolder.Username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", zinging.getVideoPublisher());
                mContext.startActivity(intent);
            }
        });

        Long Time = zinging.getTimestamp();
        String NotifTime = GetTimeAgoObject.getTimeAgo(Time, viewHolder.date.getContext());

        viewHolder.date.setText(NotifTime);
    }

    @Override
    public int getItemCount() {
        return mZinging.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder
    {
        public ImageView Rating, Comment, Sharing, PlayVid, option;
        public VideoView videoview;
        public TextView Rates, description, date, Username, points, Hobby;
        public CircleImageView Userimage;


        public ViewHolder(@NonNull View itemView) {
            super(itemView);


            PlayVid = itemView.findViewById(R.id.PlayVideo);
            videoview = itemView.findViewById(R.id.Vid_image);
            Rating = itemView.findViewById(R.id.Point);
            Comment = itemView.findViewById(R.id.Vid_Comment);
            description = itemView.findViewById(R.id.Vid_Description);
            date = itemView.findViewById(R.id.Vid_Time);
            Hobby = itemView.findViewById(R.id.Vid_Hobby);
            points = itemView.findViewById(R.id.Vid_Points);
            Rates = itemView.findViewById(R.id.VidPoint);
            Username = itemView.findViewById(R.id.Vid_Username);
            Userimage = itemView.findViewById(R.id.Vid_ProfileImage);
            option = itemView.findViewById(R.id.OptionImage);
        }

    }

    private void VideoUri(String vidid, VideoView videoView, Uri videouri, ImageView volume)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Videos").child(vidid);
        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    MediaController mediaController = new MediaController(mContext);
                    mediaController.setAnchorView(videoView);

                    //videoView.setMediaController(mediaController);
                    videoView.setVideoURI(videouri);
                    videoView.requestFocus();
                    mediaController.hide();
                    videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                        @Override
                        public void onPrepared(MediaPlayer mp)
                        {
                            videoView.pause();
                            videoView.seekTo(1);

                            volume.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    if(state == "volume") {
                                        state = "novolume";
                                        mp.setVolume(0f, 0f);
                                        mp.setLooping(true);
                                    }
                                    else if(state == "novolume"){
                                        state = "volume";
                                        mp.setVolume(1.0f, 1.0f);
                                        mp.setLooping(true);
                                    }
                                }
                            });
                        }
                    });
                    videoView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            if(videoView.isPlaying()) {
                                videoView.pause();
                            }else{
                                videoView.start();
                            }
                        }
                    });
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
                    imageView.setImageResource(R.drawable.ic_dark_star);
                    imageView.setTag("Rated");
                }else{
                    imageView.setImageResource(R.drawable.ic_star);
                    imageView.setTag("Rate");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
    private void setVideoUrl(ZingingModel zingingModel, ViewHolder viewHolder)
    {
        ProgressDialog progressDialog;

        progressDialog = new ProgressDialog(mContext);
        progressDialog.setTitle("Please wait");
        progressDialog.setMessage("Uploading Video");
        progressDialog.setCanceledOnTouchOutside(false);

        String videoUrl = zingingModel.getVideoUrl();

        MediaController mediaController = new MediaController(mContext);
        mediaController.setAnchorView(viewHolder.videoview);

        Uri videoUri = Uri.parse(videoUrl);
        viewHolder.videoview.setMediaController(mediaController);
        viewHolder.videoview.setVideoURI(videoUri);

        viewHolder.videoview.requestFocus();
        viewHolder.videoview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                viewHolder.videoview.start();
            }
        });

        viewHolder.PlayVid.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                viewHolder.videoview.start();
            }
        });

        viewHolder.videoview.setOnInfoListener(new MediaPlayer.OnInfoListener() {
            @Override
            public boolean onInfo(MediaPlayer mp, int what, int extra) {
                switch(what)
                {
                    case MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START:
                    {
                        progressDialog.show();
                        return true;
                    }
                    case MediaPlayer.MEDIA_INFO_BUFFERING_START:
                    {
                        progressDialog.show();
                        return true;
                    }
                    case MediaPlayer.MEDIA_INFO_BUFFERING_END:
                    {
                        progressDialog.dismiss();
                        return true;
                    }
                }
                return false;
            }
        });

        viewHolder.videoview.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                mp.start();
            }
        });
    }

    private void nrRates(TextView Rates, String postid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Rates")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Rates.setText(snapshot.getChildrenCount()+ " points");
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }


    private void Publisherinfo(CircleImageView Userimage, TextView Username, TextView Points,String userid)
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
                if(snapshot.hasChild("points"))
                {
                    Points.setText(snapshot.child("points").getChildrenCount()+"");
                }
                Username.setText(user.getUsername());
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

}
