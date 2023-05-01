package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

import com.zinging.hobbystar.Adapter.ZingingVideoAdapter;
import com.zinging.hobbystar.Model.ZingingModel;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class CategoryVid extends AppCompatActivity
{
    private RecyclerView recyclerView;

    private FirebaseAuth mAuth;
    private DatabaseReference VidRef;

    private ZingingVideoAdapter zingingVideoAdapter;
    private List<ZingingModel> VidsList;

    private List<String> FriendList;
    private Toolbar mTopToolbar;
    String State;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_zinging_video);

        mAuth = FirebaseAuth.getInstance();

        String hobby = getIntent().getStringExtra("Hobby");

        recyclerView = (RecyclerView) findViewById(R.id.ZingingVideosRecycler);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);

        VidRef = FirebaseDatabase.getInstance().getReference("HobbyVid");

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle(hobby);

        VidsList = new ArrayList<>();
        State = "Explore";

        CheckVids(hobby);
    }

    private void CheckVids(String hobby)
    {
        VidRef.child(hobby).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingModel video = snapshot.getValue(ZingingModel.class);
                    VidsList.add(video);
                }
                zingingVideoAdapter = new ZingingVideoAdapter(CategoryVid.this, VidsList);
                recyclerView.setAdapter(zingingVideoAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
}