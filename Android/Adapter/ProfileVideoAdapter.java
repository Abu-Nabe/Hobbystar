package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.VideoView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.zinging.hobbystar.Model.ZingingModel;
import com.zinging.hobbystar.R;
import com.zinging.hobbystar.VidClick;

import java.util.ArrayList;

public class ProfileVideoAdapter extends RecyclerView.Adapter<ProfileVideoAdapter.ViewHolder>
{
    private Context mContext;
    private ArrayList<ZingingModel> VideoZinging;

    public ProfileVideoAdapter(Context mContext, ArrayList<ZingingModel> videoZinging) {
        this.mContext = mContext;
        VideoZinging = videoZinging;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(mContext).inflate(R.layout.profile_zinging_video, viewGroup, false);

        return new ProfileVideoAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position)
    {
        ZingingModel post = VideoZinging.get(position);

        String videoUrl = post.getVideoUrl();

        MediaController mediaController = new MediaController(mContext);
        mediaController.setAnchorView(holder.profilepost);
        Uri videoUri = Uri.parse(videoUrl);

//        holder.profilepost.setVideoURI(videoUri);
//        holder.profilepost.requestFocus();
//        holder.profilepost.seekTo(100);
//        holder.profilepost.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
//            @Override
//            public void onPrepared(MediaPlayer mediaPlayer) {
//                float videoRatio = mediaPlayer.getVideoWidth() / (float) mediaPlayer.getVideoHeight();
//                float screenRatio = holder.profilepost.getWidth() / (float) holder.profilepost.getHeight();
//                float scaleX = videoRatio / screenRatio;
//                if (scaleX >= 1f) {
//                    holder.profilepost.setScaleX(scaleX);
//                } else {
//                    holder.profilepost.setScaleY(1f / scaleX);
//                }
//               holder.profilepost.seekTo(100);
//            }
//        });

        Glide.with(mContext).load(post.getVideoUrl()).into(holder.imagepost);

        holder.imagepost.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(mContext, VidClick.class);
                intent.putExtra("VidId", post.getTimestring());
                mContext.startActivity(intent);

            }
        });

//        Bitmap thumb = ThumbnailUtils.createVideoThumbnail(post.getVideoID(),
//                MediaStore.Images.Thumbnails);
//
//        BitmapDrawable bitmapDrawable = new BitmapDrawable(thumb);
//        holder.profilepost.setBackgroundDrawable(bitmapDrawable);

    }

    @Override
    public int getItemCount() {
        return VideoZinging.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        private VideoView profilepost;
        private ImageView imagepost;

        public ViewHolder(@NonNull View itemView)
        {
            super(itemView);

            profilepost = itemView.findViewById(R.id.profile_zinging_video);
            imagepost = itemView.findViewById(R.id.profile_zinging_image_video);

        }
    }

    public static Bitmap retriveVideoFrameFromVideo(String videoPath) throws Throwable {
        Bitmap bitmap = null;
        MediaMetadataRetriever mediaMetadataRetriever = null;
        try {
            mediaMetadataRetriever = new MediaMetadataRetriever();
            mediaMetadataRetriever.setDataSource(videoPath);
            bitmap = mediaMetadataRetriever.getFrameAtTime();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Throwable("Exception in retriveVideoFrameFromVideo(String videoPath)" + e.getMessage());

        } finally {
            if (mediaMetadataRetriever != null) {
                mediaMetadataRetriever.release();
            }
        }
        return bitmap;

    }
}
