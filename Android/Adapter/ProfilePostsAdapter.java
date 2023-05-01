package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.Model.Post;
import com.zinging.hobbystar.PostClick;
import com.zinging.hobbystar.R;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

public class ProfilePostsAdapter extends RecyclerView.Adapter<ProfilePostsAdapter.HolderNotification>
{
    private Context context;
    private ArrayList<Post> ProfilePostsList;

    public ProfilePostsAdapter(Context context, ArrayList<Post> profilePostsList) {
        this.context = context;
        ProfilePostsList = profilePostsList;
    }


    @NonNull
    @Override
    public ProfilePostsAdapter.HolderNotification onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
    {
        View view = LayoutInflater.from(context).inflate(R.layout.profile_post, viewGroup, false);

        return new ProfilePostsAdapter.HolderNotification(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProfilePostsAdapter.HolderNotification holder, int position)
    {
        Post post = ProfilePostsList.get(position);

        Picasso.get().load(post.getPostimage()).fit().centerCrop().into(holder.profilepost);

        holder.profilepost.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, PostClick.class);
                intent.putExtra("PicId", post.getTimestring());
                context.startActivity(intent);

            }
        });
    }

    @Override
    public int getItemCount()
    {
        return ProfilePostsList.size();
    }

    class HolderNotification extends RecyclerView.ViewHolder {

        private ImageView profilepost;

        public HolderNotification(@NonNull View itemView)
        {
            super(itemView);

            profilepost = itemView.findViewById(R.id.profile_post_image);

        }
    }
}
