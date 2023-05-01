package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;
import com.zinging.hobbystar.AddProfileActivity;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.PostNotifications;
import com.zinging.hobbystar.Model.TimeAgo;
import com.zinging.hobbystar.PostClick;
import com.zinging.hobbystar.R;

import java.util.List;

public class PostNotificationAdapter extends RecyclerView.Adapter<PostNotificationAdapter.ViewHolder>
{
    private Context mContext;
    private List<PostNotifications> postnotif;

    public PostNotificationAdapter(Context mContext, List<PostNotifications> postnotif) {
        this.mContext = mContext;
        this.postnotif = postnotif;

    }

    @NonNull
    @Override
    public PostNotificationAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(mContext).inflate(R.layout.postnotifications, viewGroup, false);
        return new PostNotificationAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull PostNotificationAdapter.ViewHolder holder, int position) {

        TimeAgo getTimeAgoObject = new TimeAgo();
        PostNotifications postNotif = postnotif.get(position);

        Picasso.get().load(postNotif.getPost()).into(holder.postimage);

        Long Time = postNotif.getTimestamp();
        String NotifTime = getTimeAgoObject.getTimeAgo(Time, holder.time.getContext());

        holder.time.setText(NotifTime);

        configureUser(postNotif.getPublisher(), holder.profileimage, holder.username);

        holder.profileimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", postNotif.getPublisher());
                mContext.startActivity(intent);
            }
        });

        holder.username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", postNotif.getPublisher());
                mContext.startActivity(intent);
            }
        });

        holder.postimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(mContext, PostClick.class);
                intent.putExtra("PicId", postNotif.getTimestring());
                mContext.startActivity(intent);

            }
        });
    }

    private void configureUser(String publisher, ImageView imageView, TextView username)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users").child(publisher);
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists())
                {
                    Message user = snapshot.getValue(Message.class);
                    if(snapshot.hasChild("profileimage")) {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).into(imageView);
                    }
                    username.setText(user.getUsername());
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    @Override
    public int getItemCount() {
        return postnotif.size();
    }


    public class ViewHolder extends RecyclerView.ViewHolder
    {
        ImageView profileimage, postimage;
        TextView username, description, time;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            profileimage = itemView.findViewById(R.id.notification_image);
            postimage = itemView.findViewById(R.id.NotifPost);
            username = itemView.findViewById(R.id.notification_username);
            description = itemView.findViewById(R.id.notification_event);
            time = itemView.findViewById(R.id.notification_date);

        }

    }

}
