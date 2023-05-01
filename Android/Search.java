package com.zinging.hobbystar;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.Model.Users;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;

public class Search extends AppCompatActivity
{

    private ImageView searchimage, cancelimage;
    private EditText searchuser;
    private RecyclerView searchlist;
    private Users.RecyclerViewClickListener listener;

    private DatabaseReference mUserDatabase;
    private FirebaseUser firebaseUser;
    ArrayList<String> Usernamelist;
    ArrayList<String> Profilepiclist;
    ArrayList<String> VisitUID;
    ArrayList<String> Points;
    Users searchadapter;

    String BsID;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.user_search);

        mUserDatabase = FirebaseDatabase.getInstance().getReference().child("Users");

//        searchimage = (ImageView) findViewById(R.id.SearchUsers1);
        searchuser = (EditText) findViewById(R.id.Searchforusers);
        cancelimage = (ImageView) findViewById(R.id.CancelSearch);


        mUserDatabase = FirebaseDatabase.getInstance().getReference();
        firebaseUser = FirebaseAuth.getInstance().getCurrentUser();

        searchlist = (RecyclerView) findViewById(R.id.SearchRecycler);
        searchlist.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        searchlist.setLayoutManager(linearLayoutManager);

        Usernamelist = new ArrayList<>();
        Profilepiclist = new ArrayList<>();
        VisitUID = new ArrayList<>();
        Points = new ArrayList<>();

        searchuser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                searchuser.setText("");
            }
        });

        cancelimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        searchuser.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after)
            {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s)
            {
                if(!s.toString().isEmpty())
                {
                    setAdapter(s.toString());
                } else {
                    Usernamelist.clear();
                    searchlist.removeAllViews();
                }
            }
        });
    }

    private void setAdapter(String searchedString)
    {

        mUserDatabase.child("Users").addValueEventListener(new ValueEventListener() {

            int counter = 0;

            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {

                Profilepiclist.clear();
                Usernamelist.clear();
                VisitUID.clear();
                Points.clear();
                searchlist.removeAllViews();

                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    String uid = snapshot.getKey();
                    String username = snapshot.child("username").getValue(String.class);
                    String profilepic = snapshot.child("profileimage").getValue(String.class);
                    String points = snapshot.child("hobbyname").getValue(String.class);


                    if(snapshot.hasChild("username")) {
                        if (username.toLowerCase().contains(searchedString)) {
                            VisitUID.add(uid);
                            Usernamelist.add(username);
                            Profilepiclist.add(profilepic);
                            Points.add(points);
                            counter++;
                        }

                        if (counter == 30)
                            break;
                    }
                }

                setOnClickListener();
                searchadapter = new Users(Search.this, Usernamelist, Profilepiclist, VisitUID, Points, listener);
                searchlist.setAdapter(searchadapter);

            }





            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void setOnClickListener()
    {
        listener = new Users.RecyclerViewClickListener() {
            @Override
            public void onClick(View v, int position)
            {
                String addUsername= VisitUID.get(position);
                Intent intent = new Intent(getApplicationContext(), AddProfileActivity.class);
                intent.putExtra("visit_user_id", addUsername);
                startActivity(intent);
            }
        };
    }


}




