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

public class add_interest_activity extends AppCompatActivity
{

    private Button Message1;
    private TextView Add_No_Interests;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, InterestRef, FriendRequestRef;
    private Toolbar mTopToolbar;
    private RecyclerView addrecycler;
    private CircleImageView profile;

    private String chatreceiverid, chatreceivename, userid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_interest_activity);

        mAuth = FirebaseAuth.getInstance();

        userid = mAuth.getCurrentUser().getUid();

        Message1 = (Button) findViewById(R.id.Add_Message);
        profile = (CircleImageView) findViewById(R.id.AddInterestProfile);
        Add_No_Interests = (TextView) findViewById(R.id.Add_No_Interests);

        chatreceiverid = getIntent().getExtras().get("chat").toString();
        UsersRef = FirebaseDatabase.getInstance().getReference("Users");
        InterestRef = FirebaseDatabase.getInstance().getReference("Interest");
        FriendRequestRef = FirebaseDatabase.getInstance().getReference().child("FriendRequest");

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Friendlist");

        addrecycler = (RecyclerView) findViewById(R.id.Add_Recycler);
        addrecycler.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

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

        InterestRef.child(chatreceiverid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    Add_No_Interests.setText(snapshot.getChildrenCount()+ " Interests");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        InterestRef.child(userid).child(chatreceiverid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    Message1.setText("Interested");
                }else{
                    Message1.setText("Interest");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        Message1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                if(Message1.getText().equals("Interest"))
                    {
                    InterestRef.child(userid).child(chatreceiverid).child("Interest").setValue("Saved").addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task)
                        {
                            Message1.setText("Interested");
                        }
                    });
                }else if(Message1.getText().equals("Interested"))
                {
                    InterestRef.child(userid).child(chatreceiverid).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                        @Override
                        public void onSuccess(Void aVoid) {
                            Message1.setText("Interest");
                        }
                    });
                }
            }
        });
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        FirebaseRecyclerOptions options =
                new FirebaseRecyclerOptions.Builder<Message>()
                        .setQuery(InterestRef.child(chatreceiverid), Message.class)
                        .build();

        FirebaseRecyclerAdapter<Message, InterestViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, InterestViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull InterestViewHolder viewHolder, int position, @NonNull Message model)
            {
                final String userIDs = getRef(position).getKey();

                UsersRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            String Username = snapshot.child("username").getValue().toString();
                            viewHolder.username.setText(Username);
                            if(snapshot.hasChild("profileimage"))
                            {
                                String profileimage = snapshot.child("profileimage").getValue().toString();

                                Picasso.get().load(profileimage).into(viewHolder.image);
                            }
                            if(snapshot.hasChild("points"))
                            {
                                viewHolder.points.setText(snapshot.child("points").getChildrenCount()+ "");
                            }

                            viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(add_interest_activity.this, PersonZingingVid.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });

                            InterestRef.child(userid).child(userIDs).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot)
                                {
                                    if(snapshot.exists())
                                    {
                                        viewHolder.uninterest.setText("Interested");
                                    }else{
                                        viewHolder.uninterest.setText("Interest");
                                    }
                                }

                                @Override
                                public void onCancelled(@NonNull DatabaseError error) {

                                }
                            });

                            if(userIDs.equals(userid))
                            {
                                viewHolder.uninterest.setText("");
                            }

                            viewHolder.uninterest.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    if(viewHolder.uninterest.getText().equals("Interested")) {
                                        InterestRef.child(userid).child(userIDs).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                            @Override
                                            public void onSuccess(Void aVoid) {
                                                viewHolder.uninterest.setText("Interest");
                                            }
                                        });
                                    }else{
                                        InterestRef.child(userid).child(userIDs).child("Interest").setValue("Saved").addOnSuccessListener(new OnSuccessListener<Void>() {
                                            @Override
                                            public void onSuccess(Void aVoid) {
                                                viewHolder.uninterest.setText("Interested");
                                            }
                                        });
                                    }
                                }
                            });

                            viewHolder.username.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(add_interest_activity.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });
                            viewHolder.image.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(add_interest_activity.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
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

            @NonNull
            @Override
            public InterestViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType) {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.interest, viewGroup, false);
                InterestViewHolder viewHolder = new InterestViewHolder(view);
                return viewHolder;
            }
        };
        addrecycler.setAdapter(adapter);
        adapter.startListening();
    }

    public static class InterestViewHolder extends RecyclerView.ViewHolder
    {
        TextView username, points, uninterest;
        CircleImageView image;
        public InterestViewHolder(@NonNull View itemView)
        {
            super(itemView);

            username = itemView.findViewById(R.id.InterestUsername);
            image = itemView.findViewById(R.id.InterestProfile);
            uninterest = itemView.findViewById(R.id.Interest_status);
            points = itemView.findViewById(R.id.InterestPoints);


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