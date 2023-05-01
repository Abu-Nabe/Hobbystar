package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.zinging.hobbystar.Adapter.ProfilePostsAdapter;
import com.zinging.hobbystar.Adapter.ProfileVideoAdapter;
import com.zinging.hobbystar.Adapter.ProfileZingingAdapter;
import com.zinging.hobbystar.Model.Post;
import com.zinging.hobbystar.Model.ZingingModel;
import com.zinging.hobbystar.Model.ZingingPics;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import de.hdodenhof.circleimageview.CircleImageView;

public class ProfileActivity extends AppCompatActivity {

    private TextView Username, CheckFriends, Gathering, Interest, Points, hobbyname, Click, post1, post2;
    private ImageView Click2;
    private CircleImageView hobbyimage;
    private CircleImageView ProfilePic;
    private ProgressDialog loadingBar;
    private ProgressBar progressBar;
    private Toolbar mTopToolbar;

    private ProfilePostsAdapter postAdapter;
    private ProfileZingingAdapter zingingAdapter;
    private ProfileVideoAdapter profilevideo;
    private ArrayList<Post> postList;
    private ArrayList<ZingingModel> videolist;
    private ArrayList<ZingingPics> zingingList;

    private RecyclerView PersonalPostsRecycler, ZingingRecycler;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef;
    private StorageReference UserProfileImageRef;

    int TAKE_IMAGE_CODE = 1000;

    String currentUserId;

    private static final String TAG = "ProfileActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);


        mAuth = FirebaseAuth.getInstance();
        currentUserId = mAuth.getCurrentUser().getUid();
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserId);
        UserProfileImageRef = FirebaseStorage.getInstance().getReference();

        UsersRef.child("online").setValue("Online");

        long timestamp = System.currentTimeMillis();
        UsersRef.child("online").onDisconnect().setValue(timestamp);



        CheckFriends = (TextView) findViewById(R.id.Profileslist);
        Username = (TextView) findViewById(R.id.Profile_Username);
        Gathering = (TextView) findViewById(R.id.ProfileGathering);
        Interest = (TextView) findViewById(R.id.ProfileInterest);
        ProfilePic = (CircleImageView) findViewById(R.id.profile_image);
        Points = (TextView) findViewById(R.id.ProfilePoints);
        Click = (TextView) findViewById(R.id.ProfilePoints1);
        Click2 = (ImageView) findViewById(R.id.imageview1);
        hobbyimage = (CircleImageView) findViewById(R.id.imageView3);
        hobbyname = (TextView) findViewById(R.id.HobbyName);
        post1 = (TextView) findViewById(R.id.Post1);
        post2 = (TextView) findViewById(R.id.Post2);

        progressBar = (ProgressBar) findViewById(R.id.ProgressBar);

        mTopToolbar = (Toolbar) findViewById(R.id.profile_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setTitle("Profile");

        progressBar.setVisibility(View.INVISIBLE);

        Points.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, PersonZingingVid.class);
                intent.putExtra("visit_user_id", currentUserId);
                startActivity(intent);
            }
        });
        Click.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, PersonZingingVid.class);
                intent.putExtra("visit_user_id", currentUserId);
                startActivity(intent);
            }
        });
        Click2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, PersonZingingVid.class);
                intent.putExtra("visit_user_id", currentUserId);
                startActivity(intent);
            }
        });
        PersonalPostsRecycler = (RecyclerView) findViewById(R.id.personalpostsrecycler);
        PersonalPostsRecycler.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        postList = new ArrayList<>();
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        linearLayoutManager.setOrientation(RecyclerView.HORIZONTAL);
        PersonalPostsRecycler.setLayoutManager(linearLayoutManager);


        ZingingRecycler = (RecyclerView) findViewById(R.id.ZingingPostsRecycler);
        ZingingRecycler.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager1 = new LinearLayoutManager(getApplicationContext());
        zingingList = new ArrayList<>();
        linearLayoutManager1.setReverseLayout(true);
        linearLayoutManager1.setStackFromEnd(true);
        linearLayoutManager1.setOrientation(RecyclerView.HORIZONTAL);
        ZingingRecycler.setLayoutManager(linearLayoutManager1);

        hobbyimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                Intent intent = new Intent(ProfileActivity.this, CountryPickerActivity.class);
                startActivity(intent);
            }
        });

        Interest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, InterestActivity.class);
                startActivity(intent);
            }
        });

        Gathering.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                GoToGatherChats();
            }
        });

        CheckFriends.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProfileActivity.this, FriendRequests.class);
                startActivity(intent);
            }
        });

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

        ProfilePic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                sendtoeditprofile();
            }
        });



        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    String myUsername = snapshot.child("username").getValue().toString();
                    Username.setText(myUsername);

                    if (snapshot.hasChild("profileimage"))
                    {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).placeholder(R.drawable.profile).into(ProfilePic);
                    }
                    if(snapshot.hasChild("gathername"))
                    {
                        String gathername = snapshot.child("gathername").getValue().toString();
                        Gathering.setText(gathername);
                    }
                    if(snapshot.hasChild("hobby"))
                    {
                        String hobby = snapshot.child("hobby").getValue().toString();
                        Picasso.get().load(hobby).fit().centerCrop().into(hobbyimage);
                    }
                    if(snapshot.hasChild("hobbyname"))
                    {
                        String hobby = snapshot.child("hobbyname").getValue().toString();
                        hobbyname.setText(hobby);
                    }
                    if(snapshot.hasChild("post"))
                    {
                        post1.setText(snapshot.child("post").getChildrenCount()+ " Personal Posts");
                    }
                    if(snapshot.hasChild("zingingpost"))
                    {
                        post2.setText(snapshot.child("zingingpost").getChildrenCount()+ " Zinging Posts");
                    }

                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        UsersRef.child("points").addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Points.setText(snapshot.getChildrenCount() + "");
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });


    }

    @Override
    protected void onStart()
    {
        super.onStart();

        ProfilePhotos();

        ZingingPosts();

    }

    private void GoToGatherChats()
    {
        Intent intent = new Intent(ProfileActivity.this, GatherChats.class);
        startActivity(intent);
    }

    private void ProfilePhotos()
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
                    Post post1 = snapshot.getValue(Post.class);
                    if(post1.getPublisher().equals(currentUserId))
                    {
                        postList.add(post1);
                    }
                }
                postAdapter = new ProfilePostsAdapter(ProfileActivity.this, postList);

                PersonalPostsRecycler.setAdapter(postAdapter);
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
                    if(post.getPublisher().equals(currentUserId))
                    {
                        zingingList.add(post);
                    }
                }
                zingingAdapter = new ProfileZingingAdapter(ProfileActivity.this, zingingList);

                ZingingRecycler.setAdapter(zingingAdapter);
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
        getMenuInflater().inflate(R.menu.app_bar_icon, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item)
    {
        super.onOptionsItemSelected(item);
        switch (item.getItemId())
        {
            case R.id.logout:
                FirebaseAuth.getInstance().signOut();
                Intent intent = new Intent(this, LoginActivity.class);
                startActivity(intent);
                return true;
            case R.id.gathericon:
                Intent intent1 = new Intent(this, GatherSettings.class);
                startActivity(intent1);
                return true;
            case R.id.SuggestionIcon:
                Intent intent2 = new Intent(this, SuggestionSettings.class);
                startActivity(intent2);
                return true;
            case R.id.BugIcon:
                Intent intent3 = new Intent(this, BugSettings.class);
                startActivity(intent3);
                return true;
            case R.id.Infoicon:
                Intent intent4 = new Intent(this, InfoSettings.class);
                startActivity(intent4);
                return true;
            case R.id.BlockIcon:
                Intent intent5 = new Intent(this, BlockSettings.class);
                startActivity(intent5);
                return true;
            case R.id.LinkIcon:
                Intent intent6 = new Intent(this, LinkActivity.class);
                intent6.putExtra("LinkID", FirebaseAuth.getInstance().getCurrentUser().getUid());
                startActivity(intent6);
                return true;
            case R.id.HelpIcon:
                Intent intent7 = new Intent(this, HelpActivity.class);
                startActivity(intent7);
                return true;
            case R.id.HobbyIcon:
                Intent intent8 = new Intent(this, HobbiesPicker.class);
                startActivity(intent8);
                return true;
            case R.id.PremiumIcon:
                Intent intent9 = new Intent(this, PremiumActivity.class);
                startActivity(intent9);
                return true;
            case R.id.gathersicon:
                Intent intent10 = new Intent(this, UserGathers.class);
                startActivity(intent10);
                return true;
            case R.id.VideoIcon:
                Intent intent11 = new Intent(this, PersonZingingVid.class);
                intent11.putExtra("visit_user_id", currentUserId);
                startActivity(intent11);
                return true;


            default:
                return super.onOptionsItemSelected(item);
        }

    }

    private void sendtoeditprofile()
    {
        Intent editintent = new Intent(ProfileActivity.this, EditProfile.class);
        startActivity(editintent);
    }


}