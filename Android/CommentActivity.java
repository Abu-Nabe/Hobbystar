package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import com.zinging.hobbystar.Adapter.CommentsAdapter;
import com.zinging.hobbystar.Model.Comments;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class CommentActivity extends AppCompatActivity
{

    private CircleImageView circleImageView;
    private EditText editText;
    private ImageView textView;

    private RecyclerView recyclerView;
    private CommentsAdapter commentsAdapter;
    private List<Comments> mComment;

    private Toolbar mTopToolbar;

    String postid, publisherid;

    FirebaseUser firebaseUser;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_comment);

        circleImageView = (CircleImageView) findViewById(R.id.comment_profile);
        editText = (EditText) findViewById(R.id.comment);
        textView = (ImageView) findViewById(R.id.add_comment);

        recyclerView = (RecyclerView) findViewById(R.id.comment_recycler);
        recyclerView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        recyclerView.setLayoutManager(linearLayoutManager);
        mComment = new ArrayList<>();
        commentsAdapter = new CommentsAdapter(this, mComment);
        recyclerView.setAdapter(commentsAdapter);

        firebaseUser = FirebaseAuth.getInstance().getCurrentUser();


        mTopToolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Comments");

        Intent intent = getIntent();
        postid = intent.getStringExtra("postid");
        publisherid = intent.getStringExtra("publisherid");

        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(editText.getText().toString().equals(""))
                {
                    Toast.makeText(CommentActivity.this, "Type something", Toast.LENGTH_SHORT).show();
                }
                else
                {
                    addComment();
                }
            }
        });

        getImage();
        readComments();
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

    private void addComment() {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Comments").child(postid);

        String stamptime = String.valueOf(System.currentTimeMillis());
        Long timestamp = System.currentTimeMillis();
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("comment", editText.getText().toString());
        hashMap.put("publisher", firebaseUser.getUid());
        hashMap.put("timestamp", timestamp);
        hashMap.put("timestring", stamptime);

        ref.child(stamptime).setValue(hashMap);
        editText.setText("");
    }

    private void getImage()
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users").child(firebaseUser.getUid());
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if (snapshot.hasChild("profileimage"))
                    {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).placeholder(R.drawable.profile).into(circleImageView);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void readComments()
    {
        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Comments").child(postid);
        ref.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                mComment.clear();
                for(DataSnapshot dataSnapshot: snapshot.getChildren())
                {
                    Comments comment = dataSnapshot.getValue(Comments.class);
                    mComment.add(comment);
                }
                commentsAdapter.notifyDataSetChanged();

            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

    }
}