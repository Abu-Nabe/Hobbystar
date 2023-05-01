package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;

import com.zinging.hobbystar.Adapter.RatesAdapter;
import com.zinging.hobbystar.Model.Ratelikes;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

public class RatesActivity extends AppCompatActivity {

    String rate;

    List<String> idlist;

    private RecyclerView recyclerView;
    ArrayList<Ratelikes> ratelist;
    RatesAdapter ratesAdapter;

    private FirebaseAuth mAuth;
    private DatabaseReference RatesRef, UsersRef, rootref;

    private Toolbar mToolbar;

    String currentuser;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rates);


        mAuth = FirebaseAuth.getInstance();

        currentuser = mAuth.getUid();

        String id = getIntent().getStringExtra("rateid");

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");
        RatesRef = FirebaseDatabase.getInstance().getReference().child("Rates");

        mToolbar = (Toolbar) findViewById(R.id.rate_toolbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Rates");

        recyclerView = findViewById(R.id.RatesView);
        recyclerView.setLayoutManager(new LinearLayoutManager (getApplicationContext()));


        RatesRef.child(id).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                for(DataSnapshot dataSnapshot: snapshot.getChildren())
                {
                    Ratelikes rate = dataSnapshot.getValue(Ratelikes.class);

                    ratelist.add(rate);
                }
                ratesAdapter = new RatesAdapter(RatesActivity.this, ratelist);
                recyclerView.setAdapter(ratesAdapter);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

    }

}