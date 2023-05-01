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
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.zinging.hobbystar.Adapter.ProfilePostsAdapter;
import com.zinging.hobbystar.Adapter.ProfileZingingAdapter;
import com.zinging.hobbystar.Model.Post;
import com.zinging.hobbystar.Model.ZingingPics;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class AddProfileActivity extends AppCompatActivity {

    private TextView AddUser, MessageUser, AddUsername, AddInterest, Points, Hobbyname, Post1, Post2, privatename;
    private CircleImageView UserImage;
    private CircleImageView hobbyimage;
    private ImageView privateimage;
    private RecyclerView recyclerView, zingingrecycler;
    ProgressBar progressBar;

    private DatabaseReference FriendRequestRef, UsersRef, GatherRequestRef, VisitRef, MessageRef, GatherRef, InterestRef,
    BlockRef;
    private FirebaseAuth mAuth;
    private FirebaseUser mCurrentUser;
    private String Interest, Gather, CURRENT_STATE, saveCurrentDate;

    private ProfilePostsAdapter postAdapter;
    private List<String> FriendList;
    private ArrayList<Post> postList;
    private ProfileZingingAdapter zingingAdapter;
    private ArrayList<ZingingPics> zingingList;

    private Toolbar mTopToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_profile);

        mAuth = FirebaseAuth.getInstance();

        recyclerView = (RecyclerView) findViewById(R.id.AddRecycler);
        recyclerView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        postList = new ArrayList<>();
        linearLayoutManager.setStackFromEnd(true);
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setOrientation(RecyclerView.HORIZONTAL);
        recyclerView.setLayoutManager(linearLayoutManager);

        zingingrecycler = (RecyclerView) findViewById(R.id.ZingingPostsRecycler);
        zingingrecycler.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager1 = new LinearLayoutManager(getApplicationContext());
        zingingList = new ArrayList<>();
        linearLayoutManager1.setStackFromEnd(true);
        linearLayoutManager1.setReverseLayout(true);
        linearLayoutManager1.setOrientation(RecyclerView.HORIZONTAL);
        zingingrecycler.setLayoutManager(linearLayoutManager1);

        String user_id = getIntent().getStringExtra("visit_user_id");

        //receiverUserId = getIntent().getExtras().get("visit_user_id").toString();
        VisitRef = FirebaseDatabase.getInstance().getReference().child("Users");
        GatherRef = FirebaseDatabase.getInstance().getReference().child("Gather");
        BlockRef = FirebaseDatabase.getInstance().getReference().child("Block");
        InterestRef = FirebaseDatabase.getInstance().getReference().child("Interest");
        GatherRequestRef = FirebaseDatabase.getInstance().getReference().child("GatherRequest");
        MessageRef = FirebaseDatabase.getInstance().getReference("Message");
        mCurrentUser = mAuth.getCurrentUser();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");
        FriendRequestRef = FirebaseDatabase.getInstance().getReference().child("FriendRequest");

        CURRENT_STATE = "Not Friends";

        Gather = "Not Gathered";

        Interest = "Not Interested";

        mTopToolbar = (Toolbar) findViewById(R.id.profile_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Profile");

        AddUser = (TextView) findViewById(R.id.Add_friend);
        Points = (TextView) findViewById(R.id.AddProfilePoints);
        MessageUser = (TextView) findViewById(R.id.ClubMessage);
        UserImage = (CircleImageView) findViewById(R.id.addprofile_image);
        AddUsername = (TextView) findViewById(R.id.addProfile_Username);
        AddInterest = (TextView) findViewById(R.id.Add_Interest);
        hobbyimage = (CircleImageView) findViewById(R.id.imageView3);
        Hobbyname = (TextView) findViewById(R.id.hobbyname);
        Post1 = (TextView) findViewById(R.id.post1);
        Post2 = (TextView) findViewById(R.id.post2);
        privatename = (TextView) findViewById(R.id.private_friends);
        privateimage = (ImageView) findViewById(R.id.private_lock);
        progressBar = findViewById(R.id.ProgressBar);

        progressBar.setVisibility(View.VISIBLE);

        privateimage.setVisibility(View.INVISIBLE);
        privatename.setVisibility(View.INVISIBLE);

        BottomNavigationView bottomNavigationView = findViewById(R.id.BottomNavigation);

        Menu menu = bottomNavigationView.getMenu();

        UsersRef.child(mCurrentUser.getUid()).addValueEventListener(new ValueEventListener() {
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
        bottomNavigationView.setSelectedItemId(R.id.profile);

        //Perform itemSelectedListener
        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem menuItem)
            {
                switch (menuItem.getItemId()){
                    case R.id.profile:
                        return true;
                    case R.id.home:
                        startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                        overridePendingTransition(0,0);
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


        UserImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                StoryActivity storyActivity = new StoryActivity();
                Bundle bundle = new Bundle();
                bundle.putString("UserInfo", user_id);
                storyActivity.setArguments(bundle);
                storyActivity.show(getSupportFragmentManager(), "home icon");
            }
        });

        hobbyimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                Intent intent = new Intent(AddProfileActivity.this, PersonZingingVid.class);
                intent.putExtra("visit_user_id", user_id);
                startActivity(intent);
            }
        });


        VisitRef.child(user_id).child("points").addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    Points.setText(snapshot.getChildrenCount()+"");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        FriendRequestRef.child(mAuth.getCurrentUser().getUid()).child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("request_type"))
                    {
                        String reqtype = snapshot.child("request_type").getValue().toString();

                        if(reqtype.equals("received"))
                        {
                            AddUser.setText("Respond");
                            AddUser.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(AddProfileActivity.this, FriendRequests.class);
                                    startActivity(intent);
                                }
                            });
                        }
                        else if(reqtype.equals("sent"))
                        {
                            AddUser.setText("Pending");
                            AddUser.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    FriendRequestRef.child(mAuth.getCurrentUser().getUid()).child(user_id).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                        @Override
                                        public void onSuccess(Void aVoid) {
                                            FriendRequestRef.child(user_id).child(mAuth.getCurrentUser().getUid()).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                                @Override
                                                public void onSuccess(Void aVoid) {
                                                    AddUser.setText("Add Friend");
                                                    AddUser.setOnClickListener(new View.OnClickListener() {
                                                        @Override
                                                        public void onClick(View view)
                                                        {

                                                            FriendRequestRef.child(mCurrentUser.getUid()).child(user_id).child("request_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                                                                @Override
                                                                public void onComplete(@NonNull Task<Void> task)
                                                                {
                                                                    if(task.isSuccessful())
                                                                    {
                                                                        FriendRequestRef.child(user_id).child(mCurrentUser.getUid()).child("request_type")
                                                                                .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                                                            @Override
                                                                            public void onSuccess(Void aVoid)
                                                                            {
                                                                                AddUser.setEnabled(true);
                                                                                CURRENT_STATE = "Requested";
                                                                                AddUser.setText("Cancel");
                                                                                Toast.makeText(AddProfileActivity.this, "Request Sent", Toast.LENGTH_SHORT).show();
                                                                            }
                                                                        });
                                                                    }
                                                                    else
                                                                    {
                                                                        Toast.makeText(AddProfileActivity.this, "Message", Toast.LENGTH_SHORT).show();
                                                                    }
                                                                }
                                                            });
                                                        }
                                                    });
                                                }
                                            });
                                        }
                                    });
                                }
                            });
                        }
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });


        if(user_id.equals(mCurrentUser.getUid()))
        {
            Intent intent = new Intent(AddProfileActivity.this, ProfileActivity.class);
            startActivity(intent);
        }

        VisitRef.child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    String myUsername = snapshot.child("username").getValue().toString();
                    AddUsername.setText(myUsername);

                    if (snapshot.hasChild("profileimage"))
                    {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).placeholder(R.drawable.profile).into(UserImage);
                    }
                    if(snapshot.hasChild("gathername"))
                    {
                        String gathername = snapshot.child("gathername").getValue().toString();
                        MessageUser.setText(gathername);
                    }
                    if (snapshot.hasChild("hobby"))
                    {
                        String hobby = snapshot.child("hobby").getValue().toString();
                        Picasso.get().load(hobby).placeholder(R.drawable.trophy).into(hobbyimage);
                    }
                    if(snapshot.hasChild("hobbyname"))
                    {
                        String hobby = snapshot.child("hobbyname").getValue().toString();
                        Hobbyname.setText(hobby);
                    }
                    if(snapshot.hasChild("post"))
                    {
                        Post1.setText(snapshot.child("post").getChildrenCount()+ " Personal Posts");
                    }
                    if(snapshot.hasChild("zingingpost"))
                    {
                        Post2.setText(snapshot.child("zingingpost").getChildrenCount()+ " Zinging Posts");
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        GatherRef.child(user_id).child(mCurrentUser.getUid()).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.hasChild("Gathered"))
                {
                    Gather = "Gathered";
                    MessageUser.setText("Gather");
                    MessageUser.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            VisitRef.child(mCurrentUser.getUid()).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot)
                                {
                                    if(snapshot.exists())
                                    {
                                        String username = snapshot.child("username").getValue().toString();

                                        Intent intent = new Intent(AddProfileActivity.this, GatherMessage.class);
                                        intent.putExtra("gatheruser", user_id);
                                        intent.putExtra("gatherusername", username);
                                        startActivity(intent);
                                    }
                                }

                                @Override
                                public void onCancelled(@NonNull DatabaseError error) {

                                }
                            });

                        }
                    });
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        InterestRef.child(mCurrentUser.getUid()).child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists()) {
                    if (snapshot.hasChild("Interest"))
                    {
                        AddInterest.setText("Interested");
                    }
                }else{
                    AddInterest.setText("Interest");
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        MessageRef.child(mCurrentUser.getUid()).child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.hasChild("Message"))
                {
                    CURRENT_STATE = "Friends";
                    AddUser.setText("Friends");
                    AddUser.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            VisitRef.child(user_id).addValueEventListener(new ValueEventListener() {
                                @Override
                                public void onDataChange(@NonNull DataSnapshot snapshot) {
                                    if(snapshot.exists())
                                    {
                                        String username = snapshot.child("username").getValue().toString();
                                        if(snapshot.hasChild("profileimage"))
                                        {
                                            String image = snapshot.child("profileimage").getValue().toString();
                                            Picasso.get().load(image).placeholder(R.drawable.profile).into(UserImage);

                                            Intent intent = new Intent(AddProfileActivity.this, AddFriendList.class);
                                            intent.putExtra("chat", user_id);
                                            intent.putExtra("chatusername", username);
                                            intent.putExtra("chatimage", image);
                                            startActivity(intent);
                                        }
                                        else
                                        {
                                            Intent intent = new Intent(AddProfileActivity.this, AddFriendList.class);
                                            intent.putExtra("chat", user_id);
                                            intent.putExtra("chatusername", username);
                                            intent.putExtra("chatimage", R.drawable.profile);
                                            startActivity(intent);
                                        }
                                    }
                                }

                                @Override
                                public void onCancelled(@NonNull DatabaseError error) {

                                }
                            });
                        }
                    });
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        AddInterest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                Intent intent = new Intent(AddProfileActivity.this, add_interest_activity.class);
                intent.putExtra("chat", user_id);
                startActivity(intent);
            }
        });

        BlockRef.child(mCurrentUser.getUid()).child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    Intent intent = new Intent(AddProfileActivity.this, Search.class);
                    startActivity(intent);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
        MessageUser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                VisitRef.child(user_id).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            if(snapshot.hasChild("premium"))
                            {
                                String type = snapshot.child("premium").getValue().toString();
                                if(type.equals("enabled"))
                                {
                                    PaymentInfo paymentinfo = new PaymentInfo();
                                    Bundle args = new Bundle();
                                    args.putString("userid", user_id);
                                    paymentinfo.setArguments(args);
                                    paymentinfo.show(getSupportFragmentManager(), "paymentinfo");
                                }else if(type.equals("disabled"))
                                {
                                    MessageUser.setEnabled(false);

                                    GatherRequestRef.child(mCurrentUser.getUid()).child(user_id).child("gather_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                                        @Override
                                        public void onComplete(@NonNull Task<Void> task) {
                                            if (task.isSuccessful()) {
                                                GatherRequestRef.child(user_id).child(mCurrentUser.getUid()).child("gather_type")
                                                        .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                                    @Override
                                                    public void onSuccess(Void aVoid) {
                                                        MessageUser.setEnabled(true);
                                                        CURRENT_STATE = "Gather Sent";
                                                        MessageUser.setText("Cancel Request");
                                                        Toast.makeText(AddProfileActivity.this, "Gather Sent", Toast.LENGTH_SHORT).show();
                                                    }
                                                });
                                            } else {
                                                Toast.makeText(AddProfileActivity.this, "Message", Toast.LENGTH_SHORT).show();
                                            }
                                        }
                                    });
                                }
                            }else {
                                MessageUser.setEnabled(false);

                                GatherRequestRef.child(mCurrentUser.getUid()).child(user_id).child("gather_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                                    @Override
                                    public void onComplete(@NonNull Task<Void> task) {
                                        if (task.isSuccessful()) {
                                            GatherRequestRef.child(user_id).child(mCurrentUser.getUid()).child("gather_type")
                                                    .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                                @Override
                                                public void onSuccess(Void aVoid) {
                                                    MessageUser.setEnabled(true);
                                                    CURRENT_STATE = "Gather Sent";
                                                    MessageUser.setText("Cancel Request");
                                                    Toast.makeText(AddProfileActivity.this, "Gather Sent", Toast.LENGTH_SHORT).show();
                                                }
                                            });
                                        } else {
                                            Toast.makeText(AddProfileActivity.this, "Message", Toast.LENGTH_SHORT).show();
                                        }
                                    }
                                });
                            }

                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });

                if(mCurrentUser.equals("Gather Sent"))
                {
                    GatherRequestRef.child(mCurrentUser.getUid()).child(user_id).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                        @Override
                        public void onSuccess(Void aVoid)
                        {
                            GatherRequestRef.child(user_id).child(mCurrentUser.getUid()).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                @Override
                                public void onSuccess(Void aVoid)
                                {
                                    MessageUser.setEnabled(true);
                                    CURRENT_STATE = "Not_Friends";
                                    MessageUser.setText("Gather");
                                }
                            });
                        }
                    });
                }
            }
        });

        GatherRequestRef.child(mCurrentUser.getUid()).child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("gather_type"))
                    {
                        String reqtype = snapshot.child("gather_type").getValue().toString();

                        if(reqtype.equals("received"))
                        {
                            MessageUser.setText("Respond");
                            MessageUser.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    Intent intent = new Intent(AddProfileActivity.this, GatherActivity.class);
                                    startActivity(intent);
                                }
                            });
                        }
                        else if(reqtype.equals("sent"))
                        {
                            MessageUser.setText("Pending");
                            MessageUser.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    GatherRequestRef.child(mAuth.getCurrentUser().getUid()).child(user_id).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                        @Override
                                        public void onSuccess(Void aVoid) {
                                            GatherRequestRef.child(user_id).child(mAuth.getCurrentUser().getUid()).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                                                @Override
                                                public void onSuccess(Void aVoid) {
                                                    MessageUser.setText("Gathering");
                                                }
                                            });
                                        }
                                    });
                                }
                            });
                        }
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        AddUser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
               if(CURRENT_STATE == "Not Friends")
                {

                    AddUser.setEnabled(false);

                    FriendRequestRef.child(mCurrentUser.getUid()).child(user_id).child("request_type").setValue("sent").addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task)
                        {
                            if(task.isSuccessful())
                            {
                                FriendRequestRef.child(user_id).child(mCurrentUser.getUid()).child("request_type")
                                        .setValue("received").addOnSuccessListener(new OnSuccessListener<Void>() {
                                    @Override
                                    public void onSuccess(Void aVoid)
                                    {
                                        AddUser.setEnabled(true);
                                        CURRENT_STATE = "Requested";
                                        AddUser.setText("Cancel");
                                        Toast.makeText(AddProfileActivity.this, "Request Sent", Toast.LENGTH_SHORT).show();
                                    }
                                });
                            }
                            else
                            {
                                Toast.makeText(AddProfileActivity.this, "Message", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });

                }

               if(mCurrentUser.equals("Request Sent"))
               {
                   FriendRequestRef.child(mCurrentUser.getUid()).child(user_id).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                       @Override
                       public void onSuccess(Void aVoid)
                       {
                           FriendRequestRef.child(user_id).child(mCurrentUser.getUid()).removeValue().addOnSuccessListener(new OnSuccessListener<Void>() {
                               @Override
                               public void onSuccess(Void aVoid)
                               {
                                   AddUser.setEnabled(true);
                                   CURRENT_STATE = "Not_Friends";
                                   AddUser.setText("Add Friend");
                               }
                           });
                       }
                   });
               }

            }
        });

        DatabaseReference ref3 = FirebaseDatabase.getInstance().getReference("Users").child(user_id);
        ref3.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists()) {
                    progressBar.setVisibility(View.INVISIBLE);
                    if (snapshot.hasChild("privacy"))
                    {
                        String privacytype = snapshot.child("privacy").getValue().toString();
                        if(privacytype.equals("private"))
                        {
                            checkfriend(user_id);
                            ZingingVid(user_id);
                        }
                        else{
                            Profilevid(user_id);
                            ZingingVid(user_id);
                        }
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void checkfriend(String user_id)
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Message");
        ref.child(mCurrentUser.getUid()).child(user_id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    Profilevid(user_id);
                }
                else{
                    privateimage.setVisibility(View.VISIBLE);
                    privatename.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void ZingingVid(String user_id)
    {
        progressBar.setVisibility(View.INVISIBLE);
        DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference("Pics");
        ref1.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                zingingList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    ZingingPics post = snapshot.getValue(ZingingPics.class);
                    if(post.getPublisher().equals(user_id))
                    {
                        zingingList.add(post);
                    }
                }
                zingingAdapter = new ProfileZingingAdapter(AddProfileActivity.this, zingingList);

                zingingrecycler.setAdapter(zingingAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void Profilevid(String user_id)
    {
        progressBar.setVisibility(View.INVISIBLE);
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Posts");
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                postList.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    Post post = snapshot.getValue(Post.class);
                    if(post.getPublisher().equals(user_id))
                    {
                        postList.add(post);
                    }
                }
                postAdapter = new ProfilePostsAdapter(AddProfileActivity.this, postList);

                recyclerView.setAdapter(postAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        //super.onCreateOptionsMenu(menu);
        getMenuInflater().inflate(R.menu.add_profile_menu, menu);
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
            case R.id.ReportIcon:
                String user_id = getIntent().getStringExtra("visit_user_id");
                DatabaseReference ref = FirebaseDatabase.getInstance().getReference().child("Report");
                ref.child(user_id).child(mAuth.getCurrentUser().getUid()).child("report").setValue("true").addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        Toast.makeText(AddProfileActivity.this, "Reported", Toast.LENGTH_SHORT).show();
                    }
                });
                return true;
            case R.id.BlockIcon:
                String user_id1 = getIntent().getStringExtra("visit_user_id");
                DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference().child("Block");
                ref1.child(mAuth.getCurrentUser().getUid()).child(user_id1).child("blocked").setValue("true").addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        ref1.child(user_id1).child("blocked").setValue("true").addOnSuccessListener(new OnSuccessListener<Void>() {
                            @Override
                            public void onSuccess(Void aVoid) {
                                MessageRef.child(mAuth.getCurrentUser().getUid()).child(user_id1).removeValue();
                                MessageRef.child(user_id1).child(mAuth.getCurrentUser().getUid()).removeValue();
                                Toast.makeText(AddProfileActivity.this, "User has been blocked", Toast.LENGTH_SHORT).show();

                            }
                        });
                    }
                });
                return true;
            case R.id.VideoIcon:
                String user_id2 = getIntent().getStringExtra("visit_user_id");
                Intent intent11 = new Intent(this, PersonZingingVid.class);
                intent11.putExtra("visit_user_id", user_id2);
                startActivity(intent11);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }

    }

}