package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.zinging.hobbystar.Adapter.ProfileVideoAdapter;
import com.zinging.hobbystar.Adapter.ZingingPicture;
import com.zinging.hobbystar.Model.ZingingModel;
import com.zinging.hobbystar.Model.ZingingPics;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.tabs.TabItem;
import com.google.android.material.tabs.TabLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Zinging extends AppCompatActivity {

    private TextView AllPics, AllVids, zingingReward;
    private ImageView Points, selectGrid;
    private ViewPager viewPager;
    private TabLayout tablayout;
    private TabItem Explore, Interest;
    private RelativeLayout relativeLayout;
    ProgressBar progressBar;

    private FirebaseAuth mAuth;
    String currentUserId, State;

    String LayoutType;

    private List<String> FriendList;

    private RecyclerView zingingpics, zingingvids, gridzinging;
    private ZingingPicture zingingAdapter;
    private ProfileVideoAdapter videoadapter;
    private ArrayList<ZingingPics> zingingList;
    private ArrayList<ZingingModel> videolist;
    private DatabaseReference UsersRef;

    RecyclerView.LayoutManager layoutManager;
    private Toolbar mTopToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_zinging);

        mAuth = FirebaseAuth.getInstance();
        currentUserId = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserId);
        Points = findViewById(R.id.ZingingPoints);
        AllPics = (TextView) findViewById(R.id.All_Pics);
        AllVids = (TextView) findViewById(R.id.All_Vids);
        zingingReward = (TextView) findViewById(R.id.ZingingReward);
        progressBar = findViewById(R.id.ProgressBar);
        selectGrid = findViewById(R.id.SelectGrid);

        relativeLayout = (RelativeLayout) findViewById(R.id.SwipeRelative);
        Explore = (TabItem) findViewById(R.id.unknown1);
        Interest = (TabItem) findViewById(R.id.unknown2);

        tablayout = findViewById(R.id.tabLayout);

        State = "Explore";

        LayoutType = "Normal";

        progressBar.setVisibility(View.VISIBLE);

        tablayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab)
            {
                switch (tab.getPosition())
                {
                    case 0:
                        ZingingPosts();
                        ZingingVidss();
                        break;
                    case 1:
                        checkfriend();
                        break;
                }
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        Points.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(Zinging.this, RewardAd.class);
                startActivity(intent);
            }
        });

        selectGrid.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                configureGrid();
            }
        });

//        relativeLayout.setOnTouchListener(new Swipe(getApplicationContext())
//        {
//            public void onSwipeLeft()
//            {
//                Toast.makeText(Zinging.this, "Wtf am i doing", Toast.LENGTH_SHORT).show();
////                tablayout.getSelectedTabPosition()
//            }
//            public void onSwipeRight() {
//                Toast.makeText(Zinging.this, "right", Toast.LENGTH_SHORT).show();
//            }
//        });


        mTopToolbar = (Toolbar) findViewById(R.id.my_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setTitle("");


        zingingpics = (RecyclerView) findViewById(R.id.ZingingPics);
        zingingpics.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager1 = new LinearLayoutManager(getApplicationContext());
        zingingList = new ArrayList<>();
        linearLayoutManager1.setReverseLayout(true);
        linearLayoutManager1.setStackFromEnd(true);
        zingingpics.setLayoutManager(linearLayoutManager1);

        zingingvids = (RecyclerView) findViewById(R.id.ZingingVids);
        zingingvids.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager2 = new LinearLayoutManager(getApplicationContext());
        videolist = new ArrayList<>();
        linearLayoutManager2.setReverseLayout(true);
        linearLayoutManager2.setStackFromEnd(true);
        zingingvids.setLayoutManager(linearLayoutManager2);

        gridzinging = (RecyclerView) findViewById(R.id.GridZinging);
        layoutManager = new GridLayoutManager(this, 3);
        gridzinging.setLayoutManager(layoutManager);
        gridzinging.setVisibility(View.GONE);

        AllPics.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Zinging.this, ZingingPic.class);
                startActivity(intent);
            }
        });

        AllVids.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                Intent intent = new Intent(Zinging.this, ZingingVideo.class);
                startActivity(intent);
            }
        });

        ZingingPosts();
        ZingingVidss();

        //Initialize and Assign Variable
        BottomNavigationView bottomNavigationView = findViewById(R.id.BottomNavigation);

        Menu menu = bottomNavigationView.getMenu();

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Unread")) {
                        MenuItem menuItem = menu.findItem(R.id.message);
                        menuItem.setIcon(R.drawable.ic_very_dissatisfied_24);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
        //Set Icon Selected
        bottomNavigationView.setSelectedItemId(R.id.zinging);

        //Perform itemSelectedListener
        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem menuItem)
            {
                switch (menuItem.getItemId()) {
                    case R.id.profile:
                        startActivity(new Intent(getApplicationContext(), ProfileActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.home:
                        startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.message:
                        startActivity(new Intent(getApplicationContext(), ChatActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.zinging:
                        return true;
                    case R.id.activity:
                        startActivity(new Intent(getApplicationContext(), FriendActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                }
                return false;
            }
        });

        UsersRef.child("online").setValue("Online");

        long timestamp = System.currentTimeMillis();
        UsersRef.child("online").onDisconnect().setValue(timestamp);

    }

    private void configureGrid()
    {
        if (LayoutType == "Normal")
        {
            LayoutType = "Grid";

            zingingpics.setVisibility(View.GONE);
            zingingvids.setVisibility(View.GONE);

            gridzinging.setVisibility(View.VISIBLE);

            GridPost();
        }else {
            LayoutType = "Normal";
            zingingpics.setVisibility(View.VISIBLE);
            zingingvids.setVisibility(View.VISIBLE);

            gridzinging.setVisibility(View.GONE);


        }

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        //super.onCreateOptionsMenu(menu);
        getMenuInflater().inflate(R.menu.go_back_menu, menu);
        return true;
    }



    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item)
    {
        super.onOptionsItemSelected(item);
        switch (item.getItemId())
        {
            case R.id.add_post:
                String[] options = {"Picture","Videos"};

                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle("upload").setItems(options, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i)
                    {
                        if(i==0)
                        {
                            Intent intent = new Intent(Zinging.this, UploadPics.class);
                            startActivity(intent);
                        }
                        else if(i==1)
                        {
                            Intent intent = new Intent(Zinging.this, UploadVids.class);
                            startActivity(intent);
                        }
                    }
                })
                        .show();
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }

    }

    private void GridPost()
    {
        progressBar.setVisibility(View.INVISIBLE);
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("ZingingPosts");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                zingingList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingPics post = snapshot.getValue(ZingingPics.class);

                    zingingList.add(post);
                }
                zingingAdapter = new ZingingPicture(Zinging.this, zingingList);
                Collections.reverse(zingingList);
                gridzinging.setAdapter(zingingAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void ZingingPosts()
    {
        progressBar.setVisibility(View.INVISIBLE);
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Pics");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                zingingList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingPics post = snapshot.getValue(ZingingPics.class);

                        zingingList.add(post);
                    
                }
                zingingAdapter = new ZingingPicture(Zinging.this, zingingList);

                zingingpics.setAdapter(zingingAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }
    private void ZingingVidss()
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Videos");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                videolist.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingModel model = snapshot.getValue(ZingingModel.class);

                    videolist.add(model);

                }
                videoadapter = new ProfileVideoAdapter(Zinging.this, videolist);

                zingingvids.setAdapter(videoadapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void InterestVids()
    {
        progressBar.setVisibility(View.INVISIBLE);
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Videos");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                videolist.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingModel model = snapshot.getValue(ZingingModel.class);

                    String user = mAuth.getCurrentUser().getUid();

                    if(model.getVideoPublisher().equals(user))
                    {
                        videolist.add(model);
                    }
                    for (String id : FriendList) {
                        if (model.getVideoPublisher().equals(id)) {
                            videolist.add(model);
                        }
                    }
                }
                videoadapter = new ProfileVideoAdapter(Zinging.this, videolist);

                zingingvids.setAdapter(videoadapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void InterestPosts()
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Pics");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                zingingList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingPics post = snapshot.getValue(ZingingPics.class);

                    String user = mAuth.getCurrentUser().getUid();

                    if(post.getPublisher().equals(user))
                    {
                        zingingList.add(post);
                    }
                    for (String id : FriendList) {
                        if (post.getPublisher().equals(id)) {
                            zingingList.add(post);
                            }
                    }
                }
                zingingAdapter = new ZingingPicture(Zinging.this, zingingList);

                zingingpics.setAdapter(zingingAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
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

                InterestPosts();
                InterestVids();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }

        });
    }

}