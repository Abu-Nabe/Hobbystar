package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class PremiumActivity extends AppCompatActivity {

    private Button private1, public1, premium, regular, confirm;

    FirebaseAuth mAuth;
    DatabaseReference UsersRef;

    String userid;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_premium);

        private1 = (Button) findViewById(R.id.AccountPrivate);
        public1 = (Button) findViewById(R.id.AccountPublic);
        premium = (Button) findViewById(R.id.EnabledPremium);
        regular = (Button) findViewById(R.id.DisabledPremium);
        confirm = (Button) findViewById(R.id.confirm);

        mAuth = FirebaseAuth.getInstance();
        userid = mAuth.getCurrentUser().getUid();
        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(userid);

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("privacy"))
                    {
                        String privacytype = snapshot.child("privacy").getValue().toString();
                        if (privacytype.equals("private"))
                        {
                            private1.setBackgroundResource(R.drawable.grey_corners);
                        }else{
                            public1.setBackgroundResource(R.drawable.grey_corners);
                        }
                    }
                    if(snapshot.hasChild("premium"))
                    {
                        String premiumtype = snapshot.child("premium").getValue().toString();
                        if(premiumtype.equals("enabled"))
                        {
                            premium.setBackgroundResource(R.drawable.grey_corners);
                        }else{
                            regular.setBackgroundResource(R.drawable.grey_corners);
                        }
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
        private1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                public1.setBackgroundResource(R.drawable.button);
                HashMap usermap = new HashMap();
                usermap.put("privacy", "private");

                UsersRef.updateChildren(usermap);
            }
        });


        public1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                private1.setBackgroundResource(R.drawable.button);
                HashMap usermap = new HashMap();
                usermap.put("privacy", "public");

                UsersRef.updateChildren(usermap);
            }
        });

        premium.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                regular.setBackgroundResource(R.drawable.button);
//                HashMap usermap = new HashMap();
//                usermap.put("premium", "enabled");
//
//                UsersRef.updateChildren(usermap);
                Toast.makeText(PremiumActivity.this, "Will soon be available!", Toast.LENGTH_SHORT).show();
            }
        });
        regular.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                premium.setBackgroundResource(R.drawable.button);
//                HashMap usermap = new HashMap();
//                usermap.put("premium", "disabled");
//
//                UsersRef.updateChildren(usermap);
                Toast.makeText(PremiumActivity.this, "Will soon be available!", Toast.LENGTH_SHORT).show();
            }
        });


        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }
}