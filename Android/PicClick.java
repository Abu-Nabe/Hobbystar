package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.view.MenuItem;

import com.zinging.hobbystar.Adapter.ZingingPicAdapter;
import com.zinging.hobbystar.Adapter.ZingingVideoAdapter;
import com.zinging.hobbystar.Model.ZingingModel;
import com.zinging.hobbystar.Model.ZingingPics;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class PicClick extends AppCompatActivity
{
    RecyclerView clickrecyclerview;

    ZingingPicAdapter zingingPicAdapter;
    ZingingVideoAdapter zingingVideoAdapter;
    private DatabaseReference PicsRef, VidsRef;
    private List<ZingingPics> postList;
    private List<ZingingModel> videoList;

    private Toolbar mToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pic_click);

        clickrecyclerview = (RecyclerView) findViewById(R.id.ClickRecyclerView);
        clickrecyclerview.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        clickrecyclerview.setLayoutManager(linearLayoutManager);

        PicsRef = FirebaseDatabase.getInstance().getReference().child("Pics");
        VidsRef = FirebaseDatabase.getInstance().getReference().child("Videos");
        postList = new ArrayList<>();
        videoList = new ArrayList<>();

        mToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String click = getIntent().getStringExtra("PicId");
//        String click1 = getIntent().getStringExtra("VidId");

        PicsRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                for(DataSnapshot snapshot:datasnapshot.getChildren())
                {
                        ZingingPics post = snapshot.getValue(ZingingPics.class);
                        if(post.getTimestring().equals(click)) {
                            postList.add(post);
                        }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
        zingingPicAdapter = new ZingingPicAdapter(PicClick.this, postList);
        clickrecyclerview.setAdapter(zingingPicAdapter);

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
}