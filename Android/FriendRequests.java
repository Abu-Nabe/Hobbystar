package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.zinging.hobbystar.Model.Rate;
import com.zinging.hobbystar.Model.Requests;
import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.firebase.ui.database.FirebaseRecyclerOptions;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.HashMap;

import de.hdodenhof.circleimageview.CircleImageView;

public class FriendRequests extends AppCompatActivity
{

    private CircleImageView reqimage;
    private TextView requsername, friendslist, viewreq;
    private RecyclerView friendreq, rateadapter;

    private DatabaseReference FriendRequestRef, UsersRef, RateRef, MessageRef, CrushRef;
    private FirebaseAuth mAuth;
    ArrayList<String> Usernamereq;
    ArrayList<String> Profilepicreq;

    private Toolbar mTopToolbar;

    Requests requestadapter;
    FirebaseUser mCurrentUser;

    private static final String PROGRESS = "SEEKBAR";
    private int save;
    String user_id;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.addfriends);


        requsername = (TextView) findViewById(R.id.addfriends_username);
        reqimage = (CircleImageView) findViewById(R.id.addprofile_image);
        friendslist = (TextView) findViewById(R.id.FriendSuggestion);
        viewreq = (TextView) findViewById(R.id.ViewRequests);

        mAuth = FirebaseAuth.getInstance();
        user_id = mAuth.getCurrentUser().getUid();

        rateadapter = (RecyclerView) findViewById(R.id.Friendslist);
        rateadapter.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

        RateRef = FirebaseDatabase.getInstance().getReference().child("Message").child(user_id);

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");
        CrushRef = FirebaseDatabase.getInstance().getReference().child("Crush");
        FriendRequestRef = FirebaseDatabase.getInstance().getReference().child("FriendRequest");
        MessageRef = FirebaseDatabase.getInstance().getReference().child("Message");

        friendreq = (RecyclerView) findViewById(R.id.add_friends);
        friendreq.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setOrientation(RecyclerView.HORIZONTAL);
        friendreq.setLayoutManager(linearLayoutManager);

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Friends");

        RateRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    friendslist.setText(snapshot.getChildrenCount()+ " Friends");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        viewreq.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(FriendRequests.this, ViewAllReq.class);
                startActivity(intent);
            }
        });
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item)
    {
        super.onOptionsItemSelected(item);
        switch (item.getItemId())
        {
            case android.R.id.home:
                finish();
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }

    }

    @Override
    protected void onStart()
    {
        super.onStart();

        MessageRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {

                if(snapshot.exists())
                {
                    UpdateRate();
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        FirebaseRecyclerOptions<Requests> options =
                new FirebaseRecyclerOptions.Builder<Requests>()
                .setQuery(FriendRequestRef.child(user_id), Requests.class)
                .build();


        FirebaseRecyclerAdapter<Requests, RequestViewHolder> adapter =
                new FirebaseRecyclerAdapter<Requests, RequestViewHolder>(options) {
                    @Override
                    protected void onBindViewHolder(@NonNull RequestViewHolder holder, int position, @NonNull Requests model)
                    {
                        final String list_user_id = getRef(position).getKey();

                        DatabaseReference getTypeRef = getRef(position).child("request_type").getRef();

                        getTypeRef.addValueEventListener(new ValueEventListener() {
                            @Override
                            public void onDataChange(@NonNull DataSnapshot snapshot)
                            {
                                if(snapshot.exists())
                                {
                                    String type = snapshot.getValue().toString();

                                    if(type.equals("received"))
                                    {
                                        UsersRef.child(list_user_id).addValueEventListener(new ValueEventListener() {
                                            @Override
                                            public void onDataChange(@NonNull DataSnapshot snapshot)
                                            {
                                                if(snapshot.exists()) {
                                                    final String RequestUsername = snapshot.child("username").getValue().toString();
                                                    if (snapshot.hasChild("profileimage")) {
                                                        final String RequestImage = snapshot.child("profileimage").getValue().toString();
                                                        Picasso.get().load(RequestImage).into(holder.profileimage);
                                                    }

                                                    holder.Username.setText(RequestUsername);

                                                    holder.Username.setOnClickListener(new View.OnClickListener() {
                                                        @Override
                                                        public void onClick(View view) {
                                                            Intent intent = new Intent(FriendRequests.this, AddProfileActivity.class);
                                                            intent.putExtra("visit_user_id", list_user_id);
                                                            startActivity(intent);
                                                        }
                                                    });
                                                    holder.profileimage.setOnClickListener(new View.OnClickListener() {
                                                        @Override
                                                        public void onClick(View view) {
                                                            Intent intent = new Intent(FriendRequests.this, AddProfileActivity.class);
                                                            intent.putExtra("visit_user_id", list_user_id);
                                                            startActivity(intent);
                                                        }
                                                    });

                                                }
                                                holder.AcceptButton.setOnClickListener(new View.OnClickListener() {
                                                    @Override
                                                    public void onClick(View v)
                                                    {
                                                        MessageRef.child(user_id).child(list_user_id).child("Message").setValue("Saved").
                                                                addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                    @Override
                                                                    public void onComplete(@NonNull Task<Void> task)
                                                                    {
                                                                        if(task.isSuccessful())
                                                                        {
                                                                            MessageRef.child(list_user_id).child(user_id).child("Message").setValue("Saved").
                                                                                    addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                        @Override
                                                                                        public void onComplete(@NonNull Task<Void> task)
                                                                                        {
                                                                                            long timestamp = System.currentTimeMillis();
                                                                                            MessageRef.child(list_user_id).child(user_id).child("timestamp").setValue(timestamp);
                                                                                            MessageRef.child(user_id).child(list_user_id).child("timestamp").setValue(timestamp);

                                                                                            FriendRequestRef.child(user_id).child(list_user_id)
                                                                                                    .removeValue()
                                                                                                    .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                                        @Override
                                                                                                        public void onComplete(@NonNull Task<Void> task)
                                                                                                        {

                                                                                                            FriendRequestRef.child(list_user_id).child(user_id)
                                                                                                                        .removeValue()
                                                                                                                        .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                                                            @Override
                                                                                                                            public void onComplete(@NonNull Task<Void> task) {
                                                                                                                                if (task.isSuccessful())
                                                                                                                                {
                                                                                                                                   UpdateRate();
                                                                                                                                }
                                                                                                                            }
                                                                                                                        });


                                                                                                        }
                                                                                                    });
                                                                                        }
                                                                                    });
                                                                        }
                                                                    }
                                                                });
                                                    }
                                                });

                                                holder.DeclineButton.setOnClickListener(new View.OnClickListener() {
                                                    @Override
                                                    public void onClick(View v) {
                                                        FriendRequestRef.child(user_id).child(list_user_id)
                                                                .removeValue()
                                                                .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                    @Override
                                                                    public void onComplete(@NonNull Task<Void> task)
                                                                    {
                                                                        if(task.isSuccessful())
                                                                        {
                                                                            FriendRequestRef.child(list_user_id).child(user_id)
                                                                                    .removeValue()
                                                                                    .addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                        @Override
                                                                                        public void onComplete(@NonNull Task<Void> task)
                                                                                        {
                                                                                            if(task.isSuccessful())
                                                                                            {
                                                                                                Toast.makeText(FriendRequests.this, "Declined Request", Toast.LENGTH_SHORT).show();
                                                                                            }
                                                                                        }
                                                                                    });
                                                                        }
                                                                    }
                                                                });
                                                    }
                                                });

                                            }

                                            @Override
                                            public void onCancelled(@NonNull DatabaseError error) {

                                            }
                                        });
                                    }else if(type.equals("sent"))
                                    {
                                        UsersRef.child(list_user_id).addValueEventListener(new ValueEventListener() {
                                            @Override
                                            public void onDataChange(@NonNull DataSnapshot snapshot)
                                            {
                                                if(snapshot.exists())
                                                {
                                                    String username = snapshot.child("username").getValue().toString();
                                                    holder.Username.setText(username);
                                                    if(snapshot.hasChild("profileimage"))
                                                    {
                                                        String profile = snapshot.child("profileimage").getValue().toString();
                                                        Picasso.get().load(profile).into(holder.profileimage);
                                                    }
                                                    holder.AcceptButton.setVisibility(View.INVISIBLE);
                                                    holder.DeclineButton.setVisibility(View.INVISIBLE);
                                                    holder.Reqtype.setText("Friend Request Sent");

                                                    holder.Username.setOnClickListener(new View.OnClickListener() {
                                                        @Override
                                                        public void onClick(View view) {
                                                            Intent intent = new Intent(FriendRequests.this, AddProfileActivity.class);
                                                            intent.putExtra("visit_user_id", list_user_id);
                                                            startActivity(intent);
                                                        }
                                                    });
                                                    holder.profileimage.setOnClickListener(new View.OnClickListener() {
                                                        @Override
                                                        public void onClick(View view) {
                                                            Intent intent = new Intent(FriendRequests.this, AddProfileActivity.class);
                                                            intent.putExtra("visit_user_id", list_user_id);
                                                            startActivity(intent);
                                                        }
                                                    });

                                                }
                                            }

                                            @Override
                                            public void onCancelled(@NonNull DatabaseError error) {

                                            }
                                        });
                                    }
                                }
                            }

                            @Override
                            public void onCancelled(@NonNull DatabaseError error) {

                            }
                        });

                    }


                    @NonNull
                    @Override
                    public RequestViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
                    {
                        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.receivereq, viewGroup, false);
                        RequestViewHolder holder = new RequestViewHolder(view);
                        return holder;
                    }
                };

        friendreq.setAdapter(adapter);
        adapter.startListening();
    }

    private void UpdateRate()
    {
        FirebaseRecyclerOptions sike =
                new FirebaseRecyclerOptions.Builder<Rate>()
                        .setQuery(RateRef, Rate.class)
                        .build();

        FirebaseRecyclerAdapter<Rate, RateViewHolder> adapter
                = new FirebaseRecyclerAdapter<Rate, RateViewHolder>(sike) {
            @NonNull
            @Override
            protected void onBindViewHolder(@NonNull RateViewHolder Holder, int position, @NonNull Rate model) {
                final String userIDs = getRef(position).getKey();

                UsersRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {

                        if (snapshot.exists()) {

                            String Username = snapshot.child("username").getValue().toString();
                            Holder.Username1.setText(Username);

                            if (snapshot.hasChild("profileimage")) {
                                String Image = snapshot.child("profileimage").getValue().toString();
                                Picasso.get().load(Image).into(Holder.Profileimage1);
                            }

                            Holder.Username1.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(FriendRequests.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });
                            Holder.Profileimage1.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(FriendRequests.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });

                            MessageRef.child(user_id).child(userIDs).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot)
                                {
                                    if(snapshot.exists())
                                    {
                                        if(snapshot.hasChild("status"))
                                        {
                                            String status = snapshot.child("status").getValue().toString();

                                            Holder.friend.setText(status);
                                        }
                                    }
                                }

                                @Override
                                public void onCancelled(@NonNull DatabaseError error) {

                                }
                            });

                            Holder.friend.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view)
                                {
                                    if(Holder.friend.getText().equals("friends"))
                                    {
                                        Holder.friend.setText("close friend");
                                    }
                                    else if(Holder.friend.getText().equals("close friend"))
                                    {
                                        Holder.friend.setText("best friend");
                                    }
                                    else if(Holder.friend.getText().equals("best friend"))
                                    {
                                        Holder.friend.setText("relationship");
                                    }
                                    else if(Holder.friend.getText().equals("relationship"))
                                    {
                                        Holder.friend.setText("family");
                                    }
                                    else if(Holder.friend.getText().equals("family"))
                                    {
                                        Holder.friend.setText("friends");
                                    }

                                    MessageRef.child(user_id).child(userIDs).child("status").setValue(Holder.friend.getText().toString());

                                }
                            });

                            CrushRef.child(user_id).child(userIDs).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot) {
                                    if(snapshot.exists())
                                    {
                                        Holder.crush.setImageResource(R.drawable.circle_heart);
                                        Holder.crush.setEnabled(false);

                                        CrushRef.child(userIDs).child(user_id).addValueEventListener(new ValueEventListener() {
                                            @Override
                                            public void onDataChange(@NonNull DataSnapshot snapshot)
                                            {
                                                if(snapshot.exists());
                                                {
                                                    if(snapshot.hasChild("Crush")) {
                                                        Holder.crush.setImageResource(R.drawable.like);
                                                        Holder.crush.setEnabled(false);
                                                    }
                                                }
                                            }

                                            @Override
                                            public void onCancelled(@NonNull DatabaseError error) {

                                            }
                                        });
                                    }
                                    else{
                                        Holder.crush.setOnClickListener(new View.OnClickListener() {
                                            @Override
                                            public void onClick(View v) {
                                                CrushRef.child(user_id).child(userIDs).child("Crush").setValue("Crushing");
                                            }
                                        });
                                    }
                                }

                                @Override
                                public void onCancelled(@NonNull DatabaseError error) {

                                }
                            });

                        }

                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });
            }

            @Override
            public RateViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.rate, viewGroup, false);
                RateViewHolder viewHolder = new RateViewHolder(view);
                return viewHolder;
            }
        };
        rateadapter.setAdapter(adapter);
        adapter.startListening();
    }

    private void AddtoNotifications(String userid)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Notifications").child(userid);

        FirebaseUser firebaseUser = mAuth.getCurrentUser();

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("userid", firebaseUser.getUid());
        hashMap.put("text", "Has hearted you!");

        ref.push().setValue(hashMap);
    }

    private void notif(String userid)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Notifications").child(userid);

        FirebaseUser firebaseUser = mAuth.getCurrentUser();

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("userid", userid);
        hashMap.put("text", "Has hearted you!");

        ref.push().setValue(hashMap);
    }

    public static class RequestViewHolder extends RecyclerView.ViewHolder
    {

        TextView Username, Reqtype;
        CircleImageView profileimage;
        ImageView AcceptButton, DeclineButton;

        private static final String PROGRESS = "SEEKBAR";
        private int save;

        public RequestViewHolder(@NonNull View itemView)
        {
            super(itemView);


            Username = itemView.findViewById(R.id.addfriends_username);
            profileimage = itemView.findViewById(R.id.addfriend_image);
            AcceptButton = itemView.findViewById(R.id.acceptreq);
            Reqtype = itemView.findViewById(R.id.FriendRequest);
            DeclineButton = itemView.findViewById(R.id.declinereq);
        }
    }

    public static class RateViewHolder extends RecyclerView.ViewHolder
    {
        TextView Username1, friend;
        CircleImageView Profileimage1;
        ImageView rate1, crush;
        SeekBar rateseekbar;

        float x,y;

        public RateViewHolder(@NonNull View itemView)
        {
            super(itemView);



            Username1 = itemView.findViewById(R.id.UsernameRate);
            Profileimage1 = itemView.findViewById(R.id.Rateprofile);
           // rate1 = itemView.findViewById(R.id.Rate);
            crush = itemView.findViewById(R.id.rate_crush);
            friend = itemView.findViewById(R.id.rate_friend);

        }
    }
}