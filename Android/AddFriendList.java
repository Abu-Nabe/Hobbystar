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
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.zinging.hobbystar.Model.Message;
import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.firebase.ui.database.FirebaseRecyclerOptions;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import de.hdodenhof.circleimageview.CircleImageView;

public class AddFriendList extends AppCompatActivity
{
    private Button Unfriend, Message1;
    private TextView No_Friends;
    private CircleImageView profile;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, MessageRef, FriendRequestRef;
    private Toolbar mTopToolbar;
    private RecyclerView addrecycler;

    private String chatreceiverid, chatreceivename, userid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_friend_list);

        mAuth = FirebaseAuth.getInstance();

        userid = mAuth.getCurrentUser().getUid();

        Unfriend = (Button) findViewById(R.id.Add_Unfriend);
        Message1 = (Button) findViewById(R.id.Add_Message);
        profile = (CircleImageView) findViewById(R.id.AddInterestProfile);
        No_Friends = (TextView) findViewById(R.id.Add_No_Friends);

        chatreceiverid = getIntent().getExtras().get("chat").toString();
        chatreceivename = getIntent().getExtras().get("chatusername").toString();
        UsersRef = FirebaseDatabase.getInstance().getReference("Users");
        MessageRef = FirebaseDatabase.getInstance().getReference("Message");
        FriendRequestRef = FirebaseDatabase.getInstance().getReference().child("FriendRequest");

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Friendlist");

        UsersRef.child(chatreceiverid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("profileimage"))
                    {
                        String IntProfile = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(IntProfile).into(profile);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        MessageRef.child(chatreceiverid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    No_Friends.setText(snapshot.getChildrenCount()+ " Friends");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        addrecycler = (RecyclerView) findViewById(R.id.Add_Recycler);
        addrecycler.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

        Unfriend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                MessageRef.child(userid).child(chatreceiverid).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if(snapshot.exists())
                        {
                            MessageRef.child(userid).child(chatreceiverid).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                @Override
                                public void onSuccess(Void aVoid) {
                                    MessageRef.child(chatreceiverid).child(userid).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                        @Override
                                        public void onSuccess(Void aVoid) {
                                            Unfriend.setText("Add Friend");
                                        }
                                    });
                                }
                            });
                        }
                        else
                            {
                                FriendRequestRef.child(userid).child(chatreceiverid).child("request_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                                    @Override
                                    public void onComplete(@NonNull Task<Void> task) {
                                        if (task.isSuccessful()) {
                                            FriendRequestRef.child(chatreceiverid).child(userid).child("request_type")
                                                    .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                                @Override
                                                public void onSuccess(Void aVoid) {
                                                    Unfriend.setText("Cancel");
                                                    Toast.makeText(AddFriendList.this, "Request Sent", Toast.LENGTH_SHORT).show();
                                                }
                                            });
                                        } else {
                                            Toast.makeText(AddFriendList.this, "Message", Toast.LENGTH_SHORT).show();
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
        });


        Message1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                UsersRef.child(chatreceiverid).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if(snapshot.exists())
                        {
                            String username = snapshot.child("username").getValue().toString();
                            if(snapshot.hasChild("profileimage"))
                            {
                                String image = snapshot.child("profileimage").getValue().toString();

                                Intent intent = new Intent(AddFriendList.this, TextActivity.class);
                                intent.putExtra("chat", chatreceiverid);
                                intent.putExtra("chatusername", username);
                                intent.putExtra("chatimage", image);
                                startActivity(intent);
                            }
                            else
                            {
                                Intent intent = new Intent(AddFriendList.this, TextActivity.class);
                                intent.putExtra("chat", chatreceiverid);
                                intent.putExtra("chatusername", username);
                                intent.putExtra("chatimage", R.drawable.profile);
                                startActivity(intent);
                            }
                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();

        FirebaseRecyclerOptions options =
                new FirebaseRecyclerOptions.Builder<Message>()
                        .setQuery(MessageRef.child(chatreceiverid), Message.class)
                        .build();

        FirebaseRecyclerAdapter<Message, AddRecyclerViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, AddRecyclerViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull AddRecyclerViewHolder viewHolder, int i, @NonNull Message message)
            {
                final String userIDs = getRef(i).getKey();

                UsersRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            String Username = snapshot.child("username").getValue().toString();
                            viewHolder.Username1.setText(Username);
                            if(snapshot.hasChild("profileimage"))
                            {
                                String profileimage = snapshot.child("profileimage").getValue().toString();

                                Picasso.get().load(profileimage).into(viewHolder.Profileimage1);
                            }
                            if(snapshot.hasChild("points"))
                            {
                                viewHolder.friend.setText(snapshot.child("points").getChildrenCount()+ "");
                            }

                            viewHolder.Username1.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(AddFriendList.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });
                            viewHolder.Profileimage1.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(AddFriendList.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });

                            if (userIDs.equals(userid))
                            {
                                viewHolder.addfriend.setText("");
                            }

                                viewHolder.addfriend.setOnClickListener(new View.OnClickListener() {
                                    @Override
                                    public void onClick(View view) {
                                        if (viewHolder.addfriend.getText().equals("Add Friend")) {
                                            FriendRequestRef.child(userid).child(userIDs).child("request_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                                                @Override
                                                public void onComplete(@NonNull Task<Void> task) {
                                                    if (task.isSuccessful()) {
                                                        FriendRequestRef.child(userIDs).child(userid).child("request_type")
                                                                .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                                            @Override
                                                            public void onSuccess(Void aVoid) {
                                                                viewHolder.addfriend.setText("Pending");
                                                                Toast.makeText(AddFriendList.this, "Request Sent", Toast.LENGTH_SHORT).show();
                                                            }
                                                        });
                                                    }
                                                }
                                            });
                                        }
                                    }
                                });

                            MessageRef.child(FirebaseAuth.getInstance().getCurrentUser().getUid()).child(userIDs).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot) {
                                    if(snapshot.exists())
                                    {
                                        viewHolder.addfriend.setText("Friends");
                                    }
                                    else if(userid.equals(userIDs))
                                    {
                                        viewHolder.addfriend.setText("Friends");
                                    }
                                }

                                @Override
                                public void onCancelled(@NonNull DatabaseError error) {

                                }
                            });

                            FriendRequestRef.child(mAuth.getCurrentUser().getUid()).child(userIDs).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot)
                                {
                                    if(snapshot.exists())
                                    {
                                        if(snapshot.hasChild("request_type"))
                                        {
                                            String reqtype = snapshot.child("request_type").getValue().toString();

                                            if(reqtype.equals("received"))
                                            {
                                                viewHolder.addfriend.setText("Respond");
                                                viewHolder.addfriend.setOnClickListener(new View.OnClickListener() {
                                                    @Override
                                                    public void onClick(View view) {
                                                        Intent intent = new Intent(AddFriendList.this, FriendRequests.class);
                                                        startActivity(intent);
                                                    }
                                                });
                                            }
                                            else if(reqtype.equals("sent"))
                                            {
                                                viewHolder.addfriend.setText("Pending");
                                                viewHolder.addfriend.setOnClickListener(new View.OnClickListener() {
                                                    @Override
                                                    public void onClick(View view) {
                                                        FriendRequestRef.child(mAuth.getCurrentUser().getUid()).child(userIDs).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                                            @Override
                                                            public void onSuccess(Void aVoid) {
                                                                FriendRequestRef.child(userIDs).child(mAuth.getCurrentUser().getUid()).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                                                    @Override
                                                                    public void onSuccess(Void aVoid) {
                                                                        viewHolder.addfriend.setText("Add Friend");
                                                                        viewHolder.addfriend.setOnClickListener(new View.OnClickListener() {
                                                                            @Override
                                                                            public void onClick(View view)
                                                                            {

                                                                                FriendRequestRef.child(userid).child(userIDs).child("request_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                                    @Override
                                                                                    public void onComplete(@NonNull Task<Void> task)
                                                                                    {
                                                                                        if(task.isSuccessful())
                                                                                        {
                                                                                            FriendRequestRef.child(userIDs).child(userid).child("request_type")
                                                                                                    .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                                                                                @Override
                                                                                                public void onSuccess(Void aVoid)
                                                                                                {
                                                                                                    viewHolder.addfriend.setText("Pending");
                                                                                                    Toast.makeText(AddFriendList.this, "Request Sent", Toast.LENGTH_SHORT).show();
                                                                                                }
                                                                                            });
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            Toast.makeText(AddFriendList.this, "Message", Toast.LENGTH_SHORT).show();
                                                                                        }
                                                                                    }
                                                                                });
                                                                            }
                                                                        });
                                                                    }
                                                                });
                                                            }
                                                        });
                                                    }
                                                });
                                            }
                                        }
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

            @NonNull
            @Override
            public AddRecyclerViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
            {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.add_friend_list, viewGroup, false);
                AddRecyclerViewHolder viewHolder = new AddRecyclerViewHolder(view);
                return viewHolder;
            }
        };
        addrecycler.setAdapter(adapter);
        adapter.startListening();
    }

    public static class AddRecyclerViewHolder extends RecyclerView.ViewHolder
    {
        TextView Username1, friend, addfriend;
        CircleImageView Profileimage1;

        public AddRecyclerViewHolder(@NonNull View itemView)
        {
            super(itemView);



            Username1 = itemView.findViewById(R.id.FriendUsername);
            Profileimage1 = itemView.findViewById(R.id.FriendProfile);
            addfriend = itemView.findViewById(R.id.Friend_status);
            friend = itemView.findViewById(R.id.FriendPoints);

        }
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
}