package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

import com.zinging.hobbystar.Adapter.ZingingPicAdapter;
import com.zinging.hobbystar.Model.ZingingPics;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class CategoryPic extends AppCompatActivity
{
    ZingingPicAdapter zingingPicAdapter;
    private List<ZingingPics> postList;

    private FirebaseAuth mAuth;
    private DatabaseReference PicsRef;

    private RecyclerView recyclerView;

    private Toolbar mTopToolbar;

    String homeid, State;
    private List<String> FriendList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_category_pic);

        mAuth = FirebaseAuth.getInstance();
        homeid = mAuth.getCurrentUser().getUid();
        PicsRef = FirebaseDatabase.getInstance().getReference().child("HobbyPic");


        recyclerView = (RecyclerView) findViewById(R.id.ZingingPicRecycler);
        recyclerView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);

        String hobby = getIntent().getStringExtra("Hobby");

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle(hobby);

        postList = new ArrayList<>();

    }

    @Override
    protected void onStart() {
        super.onStart();
        String hobby = getIntent().getStringExtra("Hobby");

        checkpics(hobby);
    }

    private void checkpics(String hobby)
    {
        PicsRef.child(hobby).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot) {
                postList.clear();
                for (DataSnapshot snapshot : datasnapshot.getChildren()) {

                    ZingingPics post = snapshot.getValue(ZingingPics.class);
                        postList.add(post);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
        zingingPicAdapter = new ZingingPicAdapter(CategoryPic.this, postList);
        recyclerView.setAdapter(zingingPicAdapter);
    }
}