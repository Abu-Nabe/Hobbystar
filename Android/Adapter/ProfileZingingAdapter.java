package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.Model.ZingingPics;
import com.zinging.hobbystar.PicClick;
import com.zinging.hobbystar.R;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

public class ProfileZingingAdapter extends RecyclerView.Adapter<ProfileZingingAdapter.ViewHolder>
{
    private Context mContext;
    private ArrayList<ZingingPics> ProfileZinging;

    public ProfileZingingAdapter(Context mContext, ArrayList<ZingingPics> profileZinging) {
        this.mContext = mContext;
        ProfileZinging = profileZinging;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(mContext).inflate(R.layout.profile_zinging, viewGroup, false);

        return new ProfileZingingAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position)
    {
        ZingingPics post = ProfileZinging.get(position);

        Picasso.get().load(post.getPicimage()).fit().centerCrop().into(holder.profilepost);


        holder.profilepost.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(mContext, PicClick.class);
                intent.putExtra("PicId", post.getTimestring());
                mContext.startActivity(intent);

            }
        });
    }

    @Override
    public int getItemCount() {
        return ProfileZinging.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        private ImageView profilepost;

        public ViewHolder(@NonNull View itemView)
        {
            super(itemView);

            profilepost = itemView.findViewById(R.id.profile_zinging_image);

        }
    }
}
