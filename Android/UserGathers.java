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

public class UserGathers extends AppCompatActivity
{

    private RecyclerView chat_view;
    private Toolbar mTopToolbar;

    private DatabaseReference PersonalGather;
    private FirebaseAuth mAuth;

    String currentUserID;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_gathers);

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Gathers");

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        PersonalGather = FirebaseDatabase.getInstance().getReference("PersonalGather").child(currentUserID);

        chat_view = (RecyclerView) findViewById(R.id.MessageRecyclerView);
        chat_view.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        chat_view.setLayoutManager(linearLayoutManager);
    }


    @Override
    protected void onStart()
    {
        super.onStart();

        FirebaseRecyclerOptions options =
                new FirebaseRecyclerOptions.Builder<Message>()
                        .setQuery(PersonalGather, Message.class)
                        .build();

        FirebaseRecyclerAdapter<Message, MessageViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, MessageViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull MessageViewHolder Holder, int i, @NonNull Message message)
            {
                final String userIDs = getRef(i).getKey();
                DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users");
                ref.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if(snapshot.exists()) {
                            String Username = snapshot.child("username").getValue().toString();
                            Holder.username.setText(Username);
                            if (snapshot.hasChild("profileimage")) {
                                String Image = snapshot.child("profileimage").getValue().toString();
                                Picasso.get().load(Image).into(Holder.image);
                            }
                            if (snapshot.hasChild("gathername")) {
                                String gather = snapshot.child("gathername").getValue().toString();
                                Holder.Date.setText(gather);
                            }
                            Holder.itemView.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {

                                    ref.child(currentUserID).addValueEventListener(new ValueEventListener() {
                                        @Override
                                        public void onDataChange(@NonNull DataSnapshot snapshot)
                                        {
                                            String username = snapshot.child("username").getValue().toString();

                                            Intent intent = new Intent(UserGathers.this, GatherMessage.class);
                                            intent.putExtra("gatheruser", userIDs);
                                            intent.putExtra("gatherusername", username);
                                            startActivity(intent);
                                        }

                                        @Override
                                        public void onCancelled(@NonNull DatabaseError error) {

                                        }
                                    });
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
            public MessageViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
            {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.user_gathers, viewGroup, false);
                MessageViewHolder viewHolder = new MessageViewHolder(view);
                return viewHolder;
            }
        };
        chat_view.setAdapter(adapter);
        adapter.notifyDataSetChanged();
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

    public static class MessageViewHolder extends RecyclerView.ViewHolder
    {
        TextView username, Date;
        CircleImageView image;
        public MessageViewHolder(@NonNull View itemView)
        {
            super(itemView);

            username = itemView.findViewById(R.id.SearchUsername);
            image = itemView.findViewById(R.id.SearchUsers);
            Date = itemView.findViewById(R.id.SearchName);
        }
    }
}