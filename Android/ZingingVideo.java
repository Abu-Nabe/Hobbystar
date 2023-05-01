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

public class ZingingVideo extends AppCompatActivity
{
    private RecyclerView recyclerView;
    private TextView category;

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

        category = findViewById(R.id.Category);

        recyclerView = (RecyclerView) findViewById(R.id.ZingingVideosRecycler);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);

        VidRef = FirebaseDatabase.getInstance().getReference("Videos");

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("");

        VidsList = new ArrayList<>();
        State = "Explore";

        category.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(ZingingVideo.this, CategorySpinner1.class);
                startActivity(intent);
            }
        });

        CheckVids();
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
                    CheckVids();
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

                InterestVids();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }

        });
    }

    private void InterestVids()
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Videos");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                VidsList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingModel model = snapshot.getValue(ZingingModel.class);

                    String user = mAuth.getCurrentUser().getUid();

                    if(model.getVideoPublisher().equals(user))
                    {
                        VidsList.add(model);
                    }
                    for (String id : FriendList) {
                        if (model.getVideoPublisher().equals(id)) {
                            VidsList.add(model);
                        }
                    }
                }
                zingingVideoAdapter = new ZingingVideoAdapter(ZingingVideo.this, VidsList);
                recyclerView.setAdapter(zingingVideoAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void CheckVids()
    {
        VidRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingModel video = snapshot.getValue(ZingingModel.class);
                    VidsList.add(video);
                }
                zingingVideoAdapter = new ZingingVideoAdapter(ZingingVideo.this, VidsList);
                recyclerView.setAdapter(zingingVideoAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
}