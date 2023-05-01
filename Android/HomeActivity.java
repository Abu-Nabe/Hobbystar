package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.Query;
import com.google.firebase.iid.FirebaseInstanceId;
import com.zinging.hobbystar.Adapter.PostAdapter;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.Post;
import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.firebase.ui.database.FirebaseRecyclerOptions;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;
import com.zinging.hobbystar.Notifications.Token;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class HomeActivity extends AppCompatActivity
{

    private Toolbar mTopToolbar;
    private HomeIconDialog homeIconFragment;
    private PostAdapter postAdapter;
    private List<Post> postList;

    private List<String> FriendList;
    private RecyclerView PostRecycler, StoryRecycler;

    private CircleImageView ProfileImage;
    ProgressDialog progressDialog;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, PostsRef, PostID, StoryID, StoryRef;
    private ProgressBar progressBar;

    private long CountPost = 0;
    private Boolean emailAddressChecker;

    String homeid;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        mAuth = FirebaseAuth.getInstance();

        homeid = mAuth.getCurrentUser().getUid();
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(homeid);
        PostsRef = FirebaseDatabase.getInstance().getReference().child("Posts");
        PostID = FirebaseDatabase.getInstance().getReference().child("Users");
        StoryID = FirebaseDatabase.getInstance().getReference().child("Message").child(homeid);

        ProfileImage = (CircleImageView) findViewById(R.id.HomeIcon);
        progressBar = (ProgressBar) findViewById(R.id.ProgressBar);

        PostRecycler = (RecyclerView) findViewById(R.id.HomePosts);
        PostRecycler.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        PostRecycler.setLayoutManager(linearLayoutManager);

        postList = new ArrayList<>();

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                String SaveCurrentTime;

                Calendar CallForTime = Calendar.getInstance();
                SimpleDateFormat CurrentTime = new SimpleDateFormat("hh:mm:ss a");
                SaveCurrentTime = CurrentTime.format(CallForTime.getTime());

                long timestring = System.currentTimeMillis();
                UsersRef.child("online").onDisconnect().setValue(timestring);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error)
            {

            }
        });

        checkfriend();

        StoryRecycler = (RecyclerView) findViewById(R.id.StoryRecycler);
        StoryRecycler.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager1 = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager1.setOrientation(RecyclerView.HORIZONTAL);
        linearLayoutManager1.setReverseLayout(true);
        linearLayoutManager1.setStackFromEnd(true);
        StoryRecycler.setLayoutManager(linearLayoutManager1);

        ProfileImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                ProgressDialog progressDialog = new ProgressDialog(HomeActivity.this);
                progressDialog.setMessage("Opening");
                progressDialog.show();
                SendToHomeIcon();
            }
        });


        mTopToolbar = (Toolbar) findViewById(R.id.my_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setTitle("");


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
        bottomNavigationView.setSelectedItemId(R.id.home);

        //Perform itemSelectedListener
        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem menuItem)
            {
                switch (menuItem.getItemId()){
                    case R.id.profile:
                        startActivity(new Intent(getApplicationContext(),ProfileActivity.class));
                        overridePendingTransition(0,0);
                        return true;
                    case R.id.home:
                        return true;
                    case R.id.message:
                        startActivity(new Intent(getApplicationContext(),ChatActivity.class));
                        overridePendingTransition(0,0);
                        return true;
                    case R.id.zinging:
                        startActivity(new Intent(getApplicationContext(),Zinging.class));
                        overridePendingTransition(0,0);
                        return true;
                    case R.id.activity:
                        startActivity(new Intent(getApplicationContext(),FriendActivity.class));
                        overridePendingTransition(0,0);
                        return true;
                }
                return false;
            }
        });

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                    if (snapshot.hasChild("profileimage"))
                    {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).into(ProfileImage);
                    }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        updateToken(FirebaseInstanceId.getInstance().getToken());
    }

     @Override
     protected void onResume() {
         super.onResume();
         getSharedPref();
     }

    @Override
    protected void onStart() {
        super.onStart();

//        EmailChecker();
        getSharedPref();

        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users").child(homeid);
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(!snapshot.hasChild("username"))
                    {
                        Intent intent = new Intent(HomeActivity.this, RegisterUsername.class);
                        startActivity(intent);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("hobbyname"))
                    {
                        UsersRef.child("online").setValue("Online");
                    }else{
                        Intent intent = new Intent(HomeActivity.this, HobbiesPicker.class);
                        startActivity(intent);
                    }
                    if(!snapshot.hasChild("privacy"))
                    {
                        UsersRef.child("privacy").setValue("public");
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        progressBar.setVisibility(View.VISIBLE);
        //dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);

        // dialog.setVisibility(View.VISIBLE);
//
//        Handler handler = new Handler();
//        handler.postDelayed(new Runnable() {
//            public void run() {
//                progressBar.setVisibility(View.INVISIBLE);
//            }
//        }, 3000); // 3000 milliseconds delay

        StoryID.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    CheckStory();
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void getSharedPref()
    {
        SharedPreferences sp = getSharedPreferences("SP_USER", MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putString("Current_USERID", homeid);
        editor.apply();
    }

    private void EmailChecker()
    {
        FirebaseUser user = mAuth.getCurrentUser();
        emailAddressChecker = user.isEmailVerified();

        if(emailAddressChecker)
        {

        }else{
            Intent intent = new Intent(HomeActivity.this, LoginActivity.class);
            startActivity(intent);
        }

    }

    private void CheckStory()
    {
        Query story = StoryID.orderByChild("timestamp");

        FirebaseRecyclerOptions<Message> options =
                new FirebaseRecyclerOptions.Builder<Message>()
                .setQuery(story, Message.class)
                .build();

        FirebaseRecyclerAdapter<Message, StoryViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, StoryViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull StoryViewHolder viewHolder, int position, @NonNull Message model)
            {
                final String userIDs = getRef(position).getKey();
//                FriendList = new ArrayList<>();

                    PostID.child(userIDs).addValueEventListener(new ValueEventListener() {
                        @Override
                        public void onDataChange(@NonNull DataSnapshot snapshot)
                        {
                            if(snapshot.exists())
                            {
                                String username = snapshot.child("username").getValue().toString();
                                viewHolder.StoryUsername.setText(username);
                                if(snapshot.hasChild("profileimage"))
                                {
                                    String profileimage = snapshot.child("profileimage").getValue().toString();
                                    Picasso.get().load(profileimage).placeholder(R.drawable.profile).into(viewHolder.StoryImage);
                                }
                            }
                            viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    StoryActivity storyActivity = new StoryActivity();
                                    Bundle bundle = new Bundle();
                                    bundle.putString("UserInfo", userIDs);
                                    storyActivity.setArguments(bundle);
                                    storyActivity.show(getSupportFragmentManager(), "home icon");
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
            public StoryViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
            {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.home_story, viewGroup, false);
                StoryViewHolder viewHolder = new StoryViewHolder(view);
                return viewHolder;
            }
        };
        StoryRecycler.setAdapter(adapter);
        adapter.startListening();
    }

    private void checkfriend()
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

                readposts();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }

        });
    }

    private void readposts()
    {
        progressBar.setVisibility(View.INVISIBLE);

        PostsRef.addValueEventListener(new ValueEventListener() {

            int counter = 0;

            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot)
            {
                for(DataSnapshot snapshot: dataSnapshot.getChildren()) {

                    Post post = snapshot.getValue(Post.class);

                    String user = mAuth.getCurrentUser().getUid();

                    if(post.getPublisher().equals(user))
                    {
                        postList.add(post);
                        counter ++;
                    }
                    for (String id : FriendList) {
                        if(post.getPublisher().equals(id)) {
                            postList.add(post);
                            counter ++;
                        }
                        if(counter == 30)
                            break;
                    }
                    if(counter == 30)
                        break;
                }


                postAdapter = new PostAdapter(HomeActivity.this, postList);

                PostRecycler.setAdapter(postAdapter);
                postAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
                Toast.makeText(HomeActivity.this, "Failed", Toast.LENGTH_SHORT).show();
            }
        });
    }



    private void updateToken(String token)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Tokens");
        Token token1 = new Token(token);
        reference.child(homeid).setValue(token1);
    }

    public static class StoryViewHolder extends RecyclerView.ViewHolder
    {
        TextView StoryUsername;
        CircleImageView StoryImage;
        public StoryViewHolder(@NonNull View itemView)
        {
            super(itemView);

            StoryImage = itemView.findViewById(R.id.HomeStory);
            StoryUsername = itemView.findViewById(R.id.StoryUsername);

        }
    }

    private void SendToHomeIcon()
    {
        HomeIconDialog homeIconDialog = new HomeIconDialog();
        homeIconDialog.show(getSupportFragmentManager(), "home icon");
    }

}