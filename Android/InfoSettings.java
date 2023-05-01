package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class InfoSettings extends AppCompatActivity
{

    private TextView InfoEmail, InfoPassword, usernameinfo, fullnameinfo, dobinfo, surnameinfo, verify;
    private Button InfoButton;

    private Toolbar mTopToolbar;
    private FirebaseAuth mAuth;
    private boolean emailAddressChecker;

    private DatabaseReference UsersRef;
    String UID;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_info_settings);

        InfoEmail = (TextView) findViewById(R.id.info_email);
        InfoPassword = (TextView) findViewById(R.id.info_password);
        usernameinfo = (TextView) findViewById(R.id.username_info);
        fullnameinfo = (TextView) findViewById(R.id.name_info);
        dobinfo = (TextView) findViewById(R.id.dob_info);
        surnameinfo = (TextView) findViewById(R.id.surnamename_info);
        verify = findViewById(R.id.emailverify);

        InfoButton = (Button) findViewById(R.id.info_continue);

        mAuth = FirebaseAuth.getInstance();
        UID = mAuth.getCurrentUser().getUid();

        verify.setVisibility(View.INVISIBLE);
        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setTitle("Personal Information");

        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(UID);

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                   String username = snapshot.child("username").getValue().toString();
                   usernameinfo.setText(username);

                   String firstname = snapshot.child("firstname").getValue().toString();
                   fullnameinfo.setText(firstname);

                   String surname = snapshot.child("lastname").getValue().toString();
                   surnameinfo.setText(surname);

                   String DOB = snapshot.child("DOB").getValue().toString();
                   dobinfo.setText(DOB);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
        InfoPassword.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ShowPasswordChange();
            }
        });

        InfoButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        InfoEmail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ShowEmailChange();
            }
        });

        checkverify();
    }

    private void checkverify()
    {
        FirebaseUser user = mAuth.getCurrentUser();
        emailAddressChecker = user.isEmailVerified();

        if(!emailAddressChecker)
        {
            verify.setVisibility(View.VISIBLE);
            verify.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    FirebaseUser user = mAuth.getCurrentUser();
                    user.sendEmailVerification();
                }
            });
        }
    }

    private void ShowEmailChange()
    {
        ChangeEmail changeEmail = new ChangeEmail();
        changeEmail.show(getSupportFragmentManager(), "Change Email");
    }

    private void ShowPasswordChange()
    {
        ChangePassword changePassword = new ChangePassword();
        changePassword.show(getSupportFragmentManager(), "Change Password");
    }
}