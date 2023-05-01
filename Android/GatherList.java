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

public class GatherList extends AppCompatActivity {

    private TextView gatherlistname, gathererlistname, NumberGathers;

    private RecyclerView gatherlist;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, GroupRef, UserRef;
    private Toolbar mToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gather_list);

        gatherlistname = (TextView) findViewById(R.id.GatherListName);
        gathererlistname = (TextView) findViewById(R.id.GathererListName);
        NumberGathers = (TextView) findViewById(R.id.No_Gathers);

        gatherlist = (RecyclerView) findViewById(R.id.GatherListView);
        gatherlist.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

        mToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setTitle("");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String GatherID = getIntent().getStringExtra("gatherid");

        GroupRef = FirebaseDatabase.getInstance().getReference().child("Gather");
        UserRef = FirebaseDatabase.getInstance().getReference().child("Users");

        UserRef.child(GatherID).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("gathername"))
                    {
                        String gathername = snapshot.child("gathername").getValue().toString();
                        gatherlistname.setText(gathername);
                    }
                    if(snapshot.hasChild("gatherername"))
                    {
                        String gatheruser = snapshot.child("gatherername").getValue().toString();
                        gathererlistname.setText(gatheruser);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        GroupRef.child(GatherID).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    NumberGathers.setText(snapshot.getChildrenCount()+ " ");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

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
    protected void onStart() {
        super.onStart();

        String GatherID = getIntent().getStringExtra("gatherid");

        FirebaseRecyclerOptions options
                = new FirebaseRecyclerOptions.Builder<Message>()
                .setQuery(GroupRef.child(GatherID), Message.class)
                .build();

        FirebaseRecyclerAdapter<Message, GatherViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, GatherViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull GatherViewHolder viewHolder, int i, @NonNull Message model)
            {
                final String userIDs = getRef(i).getKey();

                UserRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            String Username = snapshot.child("username").getValue().toString();
                            viewHolder.username.setText(Username);


                            if(snapshot.hasChild("profileimage"))
                            {
                                String Image = snapshot.child("profileimage").getValue().toString();
                                Picasso.get().load(Image).into(viewHolder.image);
                            }
                            if(snapshot.hasChild("points"))
                            {
                                viewHolder.Date.setText(snapshot.getChildrenCount()+" points");
                            }
                            viewHolder.username.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(GatherList.this, AddProfileActivity.class);
                                    intent.putExtra("visit_user_id", userIDs);
                                    startActivity(intent);
                                }
                            });
                            viewHolder.image.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(GatherList.this, AddProfileActivity.class);
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
            public GatherViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
            {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.user_item, viewGroup, false);
                GatherViewHolder viewHolder = new GatherViewHolder(view);
                return viewHolder;
            }
        };
        gatherlist.setAdapter(adapter);
        adapter.startListening();
    }

    public static class GatherViewHolder extends RecyclerView.ViewHolder {

        TextView username, Date;
        CircleImageView image;

        public GatherViewHolder(@NonNull View itemView)
        {
            super(itemView);

            username = itemView.findViewById(R.id.SearchUsername);
            image = itemView.findViewById(R.id.SearchUsers);
            Date = itemView.findViewById(R.id.SearchName);

        }
    }
}