package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

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
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import de.hdodenhof.circleimageview.CircleImageView;

public class BlockSettings extends AppCompatActivity
{
    private RecyclerView interestrecycler;

    private DatabaseReference BlockRef, UsersRef;
    private FirebaseAuth mAuth;

    private Toolbar mTopToolbar;

    String currentuser;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_block_settings);

        mAuth = FirebaseAuth.getInstance();
        currentuser = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");
        BlockRef = FirebaseDatabase.getInstance().getReference("Block");

        interestrecycler = (RecyclerView) findViewById(R.id.interest_recycler);
        interestrecycler.setLayoutManager(new LinearLayoutManager(getApplicationContext()));


        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Blocklist");
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        FirebaseRecyclerOptions options =
                new FirebaseRecyclerOptions.Builder<Message>()
                        .setQuery(BlockRef.child(currentuser), Message.class)
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
                                viewHolder.points.setText(snapshot.getChildrenCount()+" points");
                            }

                            viewHolder.uninterest.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    BlockRef.child(currentuser).child(userIDs).removeValue();
                                    BlockRef.child(userIDs).child(currentuser).removeValue();
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
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.block_list, viewGroup, false);
                InterestViewHolder viewHolder = new InterestViewHolder(view);
                return viewHolder;
            }
        };
        interestrecycler.setAdapter(adapter);
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

    public static class InterestViewHolder extends RecyclerView.ViewHolder
    {
        TextView username, points;
        CircleImageView image;
        Button uninterest;
        public InterestViewHolder(@NonNull View itemView)
        {
            super(itemView);

            username = itemView.findViewById(R.id.InterestUsername);
            image = itemView.findViewById(R.id.InterestProfile);
            uninterest = itemView.findViewById(R.id.Interest_status);
            points = itemView.findViewById(R.id.InterestPoints);


        }
    }
}