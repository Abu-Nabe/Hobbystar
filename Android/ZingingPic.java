package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

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

public class ZingingPic extends AppCompatActivity
{
    ZingingPicAdapter zingingPicAdapter;
    private List<ZingingPics> postList;

    private TextView Category;
    private FirebaseAuth mAuth;
    private DatabaseReference PicsRef;

    private RecyclerView recyclerView;

    private Toolbar mTopToolbar;

    String homeid, State;
    private List<String> FriendList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_zinging_pic);

        mAuth = FirebaseAuth.getInstance();
        homeid = mAuth.getCurrentUser().getUid();
        PicsRef = FirebaseDatabase.getInstance().getReference().child("Pics");

        Category = (TextView) findViewById(R.id.Category);

        recyclerView = (RecyclerView) findViewById(R.id.ZingingPicRecycler);
        recyclerView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("");

        Category.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                Intent intent = new Intent(ZingingPic.this, CategorySpinner.class);
                startActivity(intent);
            }
        });
        State = "Explore";
        postList = new ArrayList<>();
    }

    @Override
    protected void onStart() {
        super.onStart();

        checkpics();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        //super.onCreateOptionsMenu(menu);
        getMenuInflater().inflate(R.menu.zinging_menu, menu);
        return true;
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
            case R.id.InterestButton:
                if(State == "Explore")
                {
                    State = "Interest";
                    checkfriend();
                }
                else if(State == "Interest"){
                    State = "Explore";
                    checkpics();
                }
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }

    }

    private void checkfriend() 
    {
        FriendList = new ArrayList<>();

        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Interest")
                .child(FirebaseAuth.getInstance().getCurrentUser().getUid());

        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                FriendList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    FriendList.add(snapshot.getKey());
                }

                InterestPics();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }

        });
    }

    private void InterestPics() 
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Pics");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                postList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingPics post = snapshot.getValue(ZingingPics.class);

                    String user = mAuth.getCurrentUser().getUid();

                    if(post.getPublisher().equals(user))
                    {
                        postList.add(post);
                    }
                    for (String id : FriendList) {
                        if (post.getPublisher().equals(id)) {
                            postList.add(post);
                        }
                    }
                }
                zingingPicAdapter = new ZingingPicAdapter(ZingingPic.this, postList);
                recyclerView.setAdapter(zingingPicAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void checkpics()
    {
            PicsRef.addValueEventListener(new ValueEventListener() {
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
            zingingPicAdapter = new ZingingPicAdapter(ZingingPic.this, postList);
            recyclerView.setAdapter(zingingPicAdapter);
    }
}