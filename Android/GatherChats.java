package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
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

public class GatherChats extends AppCompatActivity {

    private TextView GroupName, points, GroupUsers, NumberGather;
    private LinearLayout itemclick;

    private RecyclerView recyclerView;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, GroupRef, UserRef;

    String currentuser;
    private Toolbar mToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gather_chats);

        GroupName = (TextView) findViewById(R.id.GatherGroupName);
        GroupUsers = (TextView) findViewById(R.id.TV1);
        points = (TextView) findViewById(R.id.GatherChatPoints);
        NumberGather = (TextView) findViewById(R.id.No_Gathers);
        itemclick = (LinearLayout) findViewById(R.id.PersonalGatherLinear);

        mAuth = FirebaseAuth.getInstance();

        currentuser = mAuth.getCurrentUser().getUid();
        GroupRef = FirebaseDatabase.getInstance().getReference().child("Gather");
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentuser);
        UserRef = FirebaseDatabase.getInstance().getReference().child("Users");

        recyclerView = (RecyclerView) findViewById(R.id.GatherChatRecycler);
        recyclerView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

        mToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Gather");

        GroupRef.child(currentuser).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()) {
                    NumberGather.setText(snapshot.getChildrenCount() + " ");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()) {
                    if (snapshot.hasChild("gathername")) {
                        String gathername = snapshot.child("gathername").getValue().toString();
                        GroupName.setText(gathername);
                    }
                    if (snapshot.hasChild("gatherername")) {
                        String gatheruser = snapshot.child("gatherername").getValue().toString();
                        GroupUsers.setText(gatheruser);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        itemclick.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                UsersRef.addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if (snapshot.exists()) {
                            String username = snapshot.child("username").getValue().toString();

                            Intent intent = new Intent(GatherChats.this, GatherMessage.class);
                            intent.putExtra("gatherusername", username);
                            intent.putExtra("gatheruser", currentuser);
                            startActivity(intent);
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
    public boolean onCreateOptionsMenu(Menu menu) {
        //super.onCreateOptionsMenu(menu);
        getMenuInflater().inflate(R.menu.message_icon, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        super.onOptionsItemSelected(item);
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return true;
            case R.id.AddFriend:
                Intent intent = new Intent(this, GatherActivity.class);
                startActivity(intent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }

    }

    @Override
    protected void onStart() {
        super.onStart();

        FirebaseRecyclerOptions options
                = new FirebaseRecyclerOptions.Builder<Message>()
                .setQuery(GroupRef.child(currentuser), Message.class)
                .build();

        FirebaseRecyclerAdapter<Message, GatherViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, GatherViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull GatherViewHolder viewHolder, int i, @NonNull Message model) {
                final String userIDs = getRef(i).getKey();

                UserRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if (snapshot.exists()) {
                            String Username = snapshot.child("username").getValue().toString();
                            viewHolder.username.setText(Username);


                            if (snapshot.hasChild("profileimage")) {
                                String Image = snapshot.child("profileimage").getValue().toString();
                                Picasso.get().load(Image).into(viewHolder.image);
                            }
                            if(snapshot.hasChild("points"))
                            {
                                viewHolder.Date.setText(snapshot.child("points").getChildrenCount()+"");
                            }
                        }
                        viewHolder.username.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                Intent intent = new Intent(GatherChats.this, AddProfileActivity.class);
                                intent.putExtra("visit_user_id", userIDs);
                                startActivity(intent);
                            }
                        });
                        viewHolder.image.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                Intent intent = new Intent(GatherChats.this, AddProfileActivity.class);
                                intent.putExtra("visit_user_id", userIDs);
                                startActivity(intent);
                            }
                        });
                        viewHolder.remove.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                GroupRef.child(FirebaseAuth.getInstance().getCurrentUser().getUid()).child(userIDs).removeValue();
                                DatabaseReference ref = FirebaseDatabase.getInstance().getReference("PersonalGather");
                                ref.removeValue();
                            }
                        });
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });
            }

            @NonNull
            @Override
            public GatherViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType) {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.gather_item, viewGroup, false);
                GatherViewHolder viewHolder = new GatherViewHolder(view);
                return viewHolder;
            }
        };
        recyclerView.setAdapter(adapter);
        adapter.startListening();
    }

    public static class GatherViewHolder extends RecyclerView.ViewHolder {

        TextView username, Date;
        CircleImageView image;
        ImageView remove;

        public GatherViewHolder(@NonNull View itemView) {
            super(itemView);

            username = itemView.findViewById(R.id.SearchUsername);
            image = itemView.findViewById(R.id.SearchUsers);
            Date = itemView.findViewById(R.id.SearchName);
            remove = itemView.findViewById(R.id.RemoveGatherer);

        }
    }
}