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
import android.widget.TextView;
import android.widget.Toast;

import com.zinging.hobbystar.Model.Requests;
import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.firebase.ui.database.FirebaseRecyclerOptions;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;


import de.hdodenhof.circleimageview.CircleImageView;

public class GatherActivity extends AppCompatActivity {

    RecyclerView GatherView;

    private DatabaseReference FriendRequestRef, MessageRef, UsersRef, PersonalGather;
    private FirebaseAuth mAuth;

    private Toolbar mToolbar;
    String user_id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gather);


        mAuth = FirebaseAuth.getInstance();
        user_id = mAuth.getCurrentUser().getUid();

        MessageRef = FirebaseDatabase.getInstance().getReference().child("Gather");
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");
        FriendRequestRef = FirebaseDatabase.getInstance().getReference().child("GatherRequest");
        PersonalGather = FirebaseDatabase.getInstance().getReference().child("PersonalGather");

        GatherView = (RecyclerView) findViewById(R.id.GatherRecyclerView);
        GatherView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        GatherView.setLayoutManager(linearLayoutManager);

        mToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Gather");
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        FirebaseRecyclerOptions<Requests> options =
                new FirebaseRecyclerOptions.Builder<Requests>()
                .setQuery(FriendRequestRef.child(user_id), Requests.class)
                .build();

        FirebaseRecyclerAdapter<Requests, RequestViewHolder> adapter
                = new FirebaseRecyclerAdapter<Requests, RequestViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull RequestViewHolder holder, int position, @NonNull Requests model)
            {
                final String list_user_id = getRef(position).getKey();

                DatabaseReference getTypeRef = getRef(position).child("gather_type").getRef();

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
                                                    Intent intent = new Intent(GatherActivity.this, AddProfileActivity.class);
                                                    intent.putExtra("visit_user_id", list_user_id);
                                                    startActivity(intent);
                                                }
                                            });
                                            holder.profileimage.setOnClickListener(new View.OnClickListener() {
                                                @Override
                                                public void onClick(View view) {
                                                    Intent intent = new Intent(GatherActivity.this, AddProfileActivity.class);
                                                    intent.putExtra("visit_user_id", list_user_id);
                                                    startActivity(intent);
                                                }
                                            });

                                        }
                                        holder.AcceptButton.setOnClickListener(new View.OnClickListener() {
                                            @Override
                                            public void onClick(View v)
                                            {
                                                MessageRef.child(user_id).child(list_user_id).child("Gathered").setValue("Saved").
                                                        addOnCompleteListener(new OnCompleteListener<Void>() {
                                                            @Override
                                                            public void onComplete(@NonNull Task<Void> task)
                                                            {
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
                                                                                                    PersonalGather.child(list_user_id).child(user_id).child("Gathered").setValue("Saved");
                                                                                                    Toast.makeText(GatherActivity.this, "User has been added to gather!", Toast.LENGTH_SHORT).show();
                                                                                                }
                                                                                            }
                                                                                        });
                                                                            }
                                                                        });
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
                                                                                        Toast.makeText(GatherActivity.this, "Declined Request", Toast.LENGTH_SHORT).show();
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
                                            holder.reqtype.setText("Gather Request Sent");

                                            holder.Username.setOnClickListener(new View.OnClickListener() {
                                                @Override
                                                public void onClick(View view) {
                                                    Intent intent = new Intent(GatherActivity.this, AddProfileActivity.class);
                                                    intent.putExtra("visit_user_id", list_user_id);
                                                    startActivity(intent);
                                                }
                                            });
                                            holder.profileimage.setOnClickListener(new View.OnClickListener() {
                                                @Override
                                                public void onClick(View view) {
                                                    Intent intent = new Intent(GatherActivity.this, AddProfileActivity.class);
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
            public RequestViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
            {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.gather_request, viewGroup, false);
                RequestViewHolder holder = new RequestViewHolder(view);
                return holder;
            }
        };
        GatherView.setAdapter(adapter);
        adapter.startListening();
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

    public static class RequestViewHolder extends RecyclerView.ViewHolder {

        TextView Username, reqtype;
        CircleImageView profileimage;
        ImageView AcceptButton, DeclineButton;

        public RequestViewHolder(@NonNull View itemView) {
            super(itemView);


            Username = itemView.findViewById(R.id.addfriends_username);
            profileimage = itemView.findViewById(R.id.addfriend_image);
            AcceptButton = itemView.findViewById(R.id.acceptreq);
            DeclineButton = itemView.findViewById(R.id.declinereq);
            reqtype = itemView.findViewById(R.id.FriendRequest);
        }
    }
}