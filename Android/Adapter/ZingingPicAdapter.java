package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.AddProfileActivity;
import com.zinging.hobbystar.CommentActivity;
import com.zinging.hobbystar.FullScreenPic;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.TimeAgo;
import com.zinging.hobbystar.Model.ZingingPics;
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

public class ZingingPicAdapter extends RecyclerView.Adapter<ZingingPicAdapter.ViewHolder>
{
    public Context mContext;
    public List<ZingingPics> mPic;

    private FirebaseUser firebaseUser;

    public ZingingPicAdapter(Context mContext, List<ZingingPics> mPic) {
        this.mContext = mContext;
        this.mPic = mPic;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(mContext).inflate(R.layout.zinging_posts, viewGroup, false);
        return new ZingingPicAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position)
    {
        firebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        TimeAgo getTimeAgoObject = new TimeAgo();

        ZingingPics post = mPic.get(position);

        if(post.getdescription().equals(""))
        {
            holder.description.setText("");
        } else {
            holder.description.setText(post.getdescription());
        }

        holder.Hobby.setText(post.getHobby());
        
        Picasso.get().load(post.getPicimage()).into(holder.Postimage);

        Rates(post.getTimestring(), holder.Rating);
        nrRates(holder.Rates, post.getTimestring());

        Publisherinfo(holder.Userimage, holder.Username, holder.Points,post.getPublisher());

        holder.Rating.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(holder.Rating.getTag().equals("Rate"))
                {
                    FirebaseDatabase.getInstance().getReference().child("Rates").child(post.getTimestring())
                            .child(firebaseUser.getUid()).setValue(true);
                    FirebaseDatabase.getInstance().getReference("Users").child(post.getPublisher()).child("points").child(post.getTimestring())
                            .child(firebaseUser.getUid()).setValue(true);
                    AddToNotification(post.getPublisher(), post.getTimestring());

                }else
                {
                    FirebaseDatabase.getInstance().getReference().child("Rates").child(post.getTimestring())
                            .child(firebaseUser.getUid()).removeValue();
                    FirebaseDatabase.getInstance().getReference("Users").child(post.getPublisher()).child("points").child(post.getTimestring())
                            .child(firebaseUser.getUid()).removeValue();
                }

            }
        });

        holder.Userimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", post.getPublisher());
                mContext.startActivity(intent);
            }
        });
        holder.Username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", post.getPublisher());
                mContext.startActivity(intent);
            }
        });

        holder.Postimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, FullScreenPic.class);
                intent.putExtra("FullScreen", post.getPicimage());
                mContext.startActivity(intent);
            }
        });


        holder.option.setOnClickListener(new View.OnClickListener() {
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
                                DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Pics").child(post.getTimestring());
                                ref.removeValue();
                                DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference("Users").child(firebaseUser.getUid()).child("zingingpost").child(post.getTimestring());
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

//                else{
//                    String[] options = {"Save", "Cancel"};
//
//                    AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
//                    builder.setItems(options, new DialogInterface.OnClickListener() {
//                        @Override
//                        public void onClick(DialogInterface dialog, int i)
//                        {
//                            if(i==0)
//                            {
//                                DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference("Saved").child(FirebaseAuth.getInstance().getCurrentUser().getUid());
//
//                                HashMap <String, Object> usermap = new HashMap<>();
//                                usermap.put("postid", post.getPicid());
//                                usermap.put("postimage", post.getPicimage());
//                                usermap.put("publisher", post.getPublisher());
//                                usermap.put("timestamp", post.getTimestamp());
//
//                                ref1.child(post.getPicid()).updateChildren(usermap);
//                            }
//                            if(i==1)
//                            {
//                                dialog.cancel();
//                            }
//                        }
//                    })
//                            .show();
//                }

        Long Time = post.getTimestamp();
        String NotifTime = getTimeAgoObject.getTimeAgo(Time, holder.date.getContext());

        holder.date.setText(NotifTime);

        holder.Comment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mContext, CommentActivity.class);
                intent.putExtra("postid", post.getTimestring());
                intent.putExtra("publisherid", post.getPublisher());
                mContext.startActivity(intent);
            }
        });


    }

    @Override
    public int getItemCount() {
        return mPic.size();
    }


    public class ViewHolder extends RecyclerView.ViewHolder
    {
        public ImageView Postimage, Rating, Comment, option;
        public TextView Commenting, Rates, description, date, Username, Points, Hobby;
        public CircleImageView Userimage;


        public ViewHolder(@NonNull View itemView) {
            super(itemView);

            Postimage = itemView.findViewById(R.id.pic_image);
            Rating = itemView.findViewById(R.id.Point);
            Comment = itemView.findViewById(R.id.Pic_Comment);
            Points = itemView.findViewById(R.id.Post_Points);
            Rates = itemView.findViewById(R.id.PicPoints);
            description = itemView.findViewById(R.id.Pic_Description);
            date = itemView.findViewById(R.id.Pic_Time);
            Hobby = itemView.findViewById(R.id.Pic_Hobby);
            Username = itemView.findViewById(R.id.Pic_Username);
            Userimage = itemView.findViewById(R.id.PicProfileImage);
            option = itemView.findViewById(R.id.OptionImage);

        }

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


    private void AddToNotification(String userid, String Postid)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Notifications").child(userid);


        Long date = System.currentTimeMillis();

        String timestamp = String.valueOf(System.currentTimeMillis());

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("userid", firebaseUser.getUid());
        hashMap.put("text", "You've gained a point!");
        hashMap.put("postid", Postid);
        hashMap.put("impost", true);
        hashMap.put("date", date);
        hashMap.put("timestamp", timestamp);

        ref.child(timestamp).setValue(hashMap);

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
