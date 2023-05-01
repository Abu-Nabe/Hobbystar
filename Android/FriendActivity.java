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

import com.zinging.hobbystar.Adapter.NotificationAdapter;
import com.zinging.hobbystar.Adapter.PostNotificationAdapter;
import com.zinging.hobbystar.Model.Notification;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.zinging.hobbystar.Model.PostNotifications;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class FriendActivity extends AppCompatActivity {

    private RecyclerView NotificationList, postNotifList;

    private Toolbar mToolbar;

    private FirebaseAuth mAuth;
    private ArrayList<Notification> mNotification;
    private ArrayList<PostNotifications> mPostNotification;
    private PostNotificationAdapter postnotifAdapter;
    private NotificationAdapter notificationAdapter;
    private DatabaseReference UsersRef, PostNotifRef;

    private List<String> FriendList;

    private static final int ITEM_PER_AD = 1;
    private static final String BANNER_AD_ID = "ca-app-pub-3940256099942544/6300978111";

    String homeid;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_friend);

        mAuth = FirebaseAuth.getInstance();

        mToolbar = (Toolbar) findViewById(R.id.my_toolbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setTitle("Notifications");

        NotificationList = (RecyclerView) findViewById(R.id.NotificationRecyclerView);
        NotificationList.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        NotificationList.setLayoutManager(linearLayoutManager);
        mNotification = new ArrayList<>();
        notificationAdapter = new NotificationAdapter(getApplicationContext(), mNotification);
        NotificationList.setAdapter(notificationAdapter);

        postNotifList = (RecyclerView) findViewById(R.id.PostNotifRecyclerView);
        postNotifList.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager1 = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager1.setOrientation(RecyclerView.HORIZONTAL);
        linearLayoutManager1.setReverseLayout(true);
        linearLayoutManager1.setStackFromEnd(true);
        postNotifList.setLayoutManager(linearLayoutManager1);
        mPostNotification = new ArrayList<>();

        ReadNotifications();
        configureFriend();

        mAuth = FirebaseAuth.getInstance();
        homeid = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(homeid);
        PostNotifRef = FirebaseDatabase.getInstance().getReference("PostNotifications");

        UsersRef.child("online").setValue("Online");

        long timestamp = System.currentTimeMillis();
        UsersRef.child("online").onDisconnect().setValue(timestamp);

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
        //Set Home Selected
        bottomNavigationView.setSelectedItemId(R.id.activity);

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
                        startActivity(new Intent(getApplicationContext(), Zinging.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.activity:
                        return true;
                }
                return false;
            }
        });
    }

    private void configureFriend()
    {
        FriendList = new ArrayList<>();

        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Message")
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

                readPostNotif();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }

        });
    }

    private void readPostNotif()
    {
        PostNotifRef.addValueEventListener(new ValueEventListener() {

            int counter = 0;

            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                for(DataSnapshot snapshot: dataSnapshot.getChildren()) {

                    PostNotifications post = snapshot.getValue(PostNotifications.class);

                    for (String id : FriendList) {
                        if(post.getPublisher().equals(id)) {
                            mPostNotification.add(post);
                            counter ++;
                        }else {

                        }
                    }
                }


                postnotifAdapter = new PostNotificationAdapter(FriendActivity.this, mPostNotification);

                postNotifList.setAdapter(postnotifAdapter);
                postnotifAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void ReadNotifications()
    {
        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Notifications").child(firebaseUser.getUid());
        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                mNotification.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    Notification model = snapshot.getValue(Notification.class);

                    mNotification.add(model);
                }
                Collections.reverse(mNotification);
                notificationAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

//    private void BannerAds()
//    {
//        for(int i = 0; i<mNotification.size(); i += ITEM_PER_AD)
//        {
//            final AdView adView = new AdView(FriendActivity.this);
//            adView.setAdSize(AdSize.BANNER);
//            adView.setAdUnitId(BANNER_AD_ID);
//            mNotification.add(adView);
//        }
//    }

}