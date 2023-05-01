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
import com.zinging.hobbystar.Model.Comments;
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

import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class CommentsAdapter extends RecyclerView.Adapter<CommentsAdapter.ViewHolder>
{
    private Context mContext;
    private List<Comments> mComment;

    private FirebaseUser firebaseUser;

    public CommentsAdapter(Context mContext, List<Comments> mComment) {
        this.mContext = mContext;
        this.mComment = mComment;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(mContext).inflate(R.layout.comment_item, viewGroup, false);
        return new CommentsAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position)
    {
        Comments comments = mComment.get(position);

        ZingingPics zingingPics = new ZingingPics();

        TimeAgo getTimeAgoObject = new TimeAgo();

        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        holder.comment.setText(comments.getComment());
        getUserInfo(holder.circleImageView, holder.username, comments.getPublisher());
        nrRates(holder.upvotes, comments.getTimestring());
        Rates(comments.getTimestring(), holder.commentlike);

        Long Time = comments.getTimestamp();
        String NotifTime = getTimeAgoObject.getTimeAgo(Time, holder.time.getContext());

//        CharSequence prettyTime = DateUtils.getRelativeDateTimeString(mContext,
//                comments.getTimestamp(), DateUtils.SECOND_IN_MILLIS, DateUtils.YEAR_IN_MILLIS, 0);

        holder.time.setText(NotifTime);

        holder.commentlike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(holder.commentlike.getTag().equals("Rate"))
                {
                    FirebaseDatabase.getInstance().getReference().child("CommentLikes").child(comments.getTimestring())
                            .child(firebaseUser.getUid()).setValue(true);
                    FirebaseDatabase.getInstance().getReference("Users").child(comments.getPublisher()).child("points")
                            .child(comments.getComment()).child(firebaseUser.getUid()).setValue(true);

                }else
                {
                    FirebaseDatabase.getInstance().getReference().child("CommentLikes").child(comments.getTimestring())
                            .child(firebaseUser.getUid()).removeValue();
                    FirebaseDatabase.getInstance().getReference("Users").child(comments.getPublisher()).child("points")
                            .child(comments.getComment()).child(firebaseUser.getUid()).removeValue();
                }
            }
        });

        holder.circleImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            Intent intent = new Intent(mContext, AddProfileActivity.class);
            intent.putExtra("visit_user_id", comments.getPublisher());
            mContext.startActivity(intent);
            }
        });

        holder.username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(mContext, AddProfileActivity.class);
                intent.putExtra("visit_user_id", comments.getPublisher());
                mContext.startActivity(intent);
            }
        });

//        holder.itemView.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View view) {
//                if(comments.getPublisher().equals(firebaseUser.getUid()))
//                {
//                    String[] options = {"Delete", "Cancel"};
//
//                    AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
//                    builder.setItems(options, new DialogInterface.OnClickListener() {
//                                @Override
//                                public void onClick(DialogInterface dialog, int i)
//                                {
//                                    if(i==0)
//                                    {
//                                        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Comments").child(comments.g());
//                                        ref.removeValue();
//                                    }
//                                    if(i==1)
//                                    {
//                                        dialog.cancel();
//                                    }
//                                }
//                            })
//                            .show();
//                }
//                return true;
//            }
//        });
    }

    @Override
    public int getItemCount() {
        return mComment.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder
    {
        public CircleImageView circleImageView;
        public TextView username, comment, upvotes, time;
        private ImageView commentlike;

        public ViewHolder(@NonNull View itemView)
        {
            super(itemView);

            circleImageView = itemView.findViewById(R.id.commenters_image);
            username = itemView.findViewById(R.id.comment_username);
            comment = itemView.findViewById(R.id.comments);
            commentlike = itemView.findViewById(R.id.like_comment);
            upvotes = itemView.findViewById(R.id.Upvotes);
            time = itemView.findViewById(R.id.Timer);
        }

    }

    private void nrRates(TextView Rates, String postid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("CommentLikes")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Rates.setText(snapshot.getChildrenCount()+ " yesss");
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
                .child("CommentLikes")
                .child(postid);

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.child(firebaseUser.getUid()).exists())
                {
                    imageView.setImageResource(R.drawable.like);
                    imageView.setTag("Rated");
                }else{
                    imageView.setImageResource(R.drawable.ic_favorite_border_24);
                    imageView.setTag("Rate");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void getUserInfo(CircleImageView circleImageView, TextView username, String publisherid)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users").child(publisherid);

        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Message user = snapshot.getValue(Message.class);
                if(snapshot.hasChild("profileimage")) {
                    String image = snapshot.child("profileimage").getValue().toString();
                    Picasso.get().load(image).into(circleImageView);
                }
                username.setText(user.getUsername());
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
}
