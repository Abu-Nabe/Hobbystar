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

import com.zinging.hobbystar.AddProfileActivity;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.Notification;
import com.zinging.hobbystar.Model.Post;
import com.zinging.hobbystar.Model.TimeAgo;
import com.zinging.hobbystar.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import de.hdodenhof.circleimageview.CircleImageView;

public class NotificationAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder>
{

    private Context context;
    private ArrayList<Notification> notificationslist;

    private static final int DEFAULT_VIEW_TYPE = 1;
    private static final int NATIVE_AD_VIEW_TYPE = 2;

    public NotificationAdapter(Context context, ArrayList<Notification> notificationslist) {
        this.context = context;
        this.notificationslist = notificationslist;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
    {

        View view = LayoutInflater.from(context).inflate(R.layout.notification, viewGroup, false);

        return new HolderNotification(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder1, int i)
    {
        Notification notification  = notificationslist.get(i);

        HolderNotification holder = (HolderNotification) holder1;

        TimeAgo getTimeAgoObject = new TimeAgo();
        holder.notifevent.setText(notification.getText());
        getuserinfo(holder.notifimage, holder.notifname, notification.getUserid());

        holder.notifname.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, AddProfileActivity.class);
                intent.putExtra("visit_user_id", notification.getUserid());
                context.startActivity(intent);
            }
        });
        holder.notifimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, AddProfileActivity.class);
                intent.putExtra("visit_user_id", notification.getUserid());
                context.startActivity(intent);
            }
        });

        holder.notifdelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Notifications").child(FirebaseAuth.getInstance().getCurrentUser().getUid())
                        .child(notification.getTimestamp());
                ref.removeValue();
            }
        });

        Long Time = notification.getDate();
        String NotifTime = getTimeAgoObject.getTimeAgo(Time, holder.notifdate.getContext());


//        CharSequence prettyTime = DateUtils.getRelativeDateTimeString(context,
//                notification.getDate(), DateUtils.SECOND_IN_MILLIS, DateUtils.YEAR_IN_MILLIS, 0);

        holder.notifdate.setText(NotifTime);

    }

    @Override
    public int getItemViewType(int position) {
        if (position!=0 && position%4 == 0) {
            return NATIVE_AD_VIEW_TYPE;
        }
        return DEFAULT_VIEW_TYPE;
    }

    @Override
    public int getItemCount() {
        return notificationslist.size();
    }

    public class HolderNotification extends RecyclerView.ViewHolder
    {

        private CircleImageView notifimage;
        private ImageView notifdelete;
        private TextView notifname, notifevent, notifdate;

        public HolderNotification(@NonNull View itemView)
        {
            super(itemView);

            notifimage = itemView.findViewById(R.id.notification_image);
            notifname = itemView.findViewById(R.id.notification_username);
            notifevent = itemView.findViewById(R.id.notification_event);
            notifdate = itemView.findViewById(R.id.notification_date);
            notifdelete = itemView.findViewById(R.id.delte_notif);

        }
    }

    private void getuserinfo(CircleImageView imageview, TextView username, String publisherid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Users").child(publisherid);
        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Message user = snapshot.getValue(Message.class);
                if(snapshot.hasChild("profileimage")) {
                    String image = snapshot.child("profileimage").getValue().toString();
                    Picasso.get().load(image).into(imageview);
                }
                username.setText(user.getUsername());

            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void getPostImage(String postid, TextView timestamp)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Posts").child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Post post = snapshot.getValue(Post.class);
//                if(snapshot.hasChild("date"))
//                {
//                    Long timestamp = 0L;
//                    timestamp = Long.valueOf(snapshot.getValue().toString());
//                }
               // Picasso.get().load(post.getPostimage()).into(imageview);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
}
