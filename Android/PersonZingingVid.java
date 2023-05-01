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

public class PersonZingingVid extends AppCompatActivity
{
    private RecyclerView recyclerView;

    private FirebaseAuth mAuth;
    private DatabaseReference VidRef;

    private ZingingVideoAdapter zingingVideoAdapter;
    private List<ZingingModel> VidsList;

    private Toolbar mTopToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person_zinging_vid);

        mAuth = FirebaseAuth.getInstance();

        recyclerView = (RecyclerView) findViewById(R.id.ZingingVideosRecycler);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);

        VidRef = FirebaseDatabase.getInstance().getReference("Videos");

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Videos");

        VidsList = new ArrayList<>();

        String user_id = getIntent().getStringExtra("visit_user_id");

        VidRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingModel video = snapshot.getValue(ZingingModel.class);
                    if(video.getVideoPublisher().equals(user_id)) {
                    VidsList.add(video);
                    }
                }
                zingingVideoAdapter = new ZingingVideoAdapter(PersonZingingVid.this, VidsList);
                recyclerView.setAdapter(zingingVideoAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
}