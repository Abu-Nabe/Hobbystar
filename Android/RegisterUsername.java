package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.Query;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class RegisterUsername extends AppCompatActivity
{

    private EditText Username;
    private Button CreateAccountButton;

    private DatabaseReference UsersRef;
    private FirebaseAuth mAuth;
    private ProgressBar progressBar;

    String currentUserID;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_username);


        mAuth = FirebaseAuth.getInstance();
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child("CurrentUserID");


        Username = (EditText) findViewById(R.id.register_usernamee);
        CreateAccountButton = (Button) findViewById(R.id.register_usercontinue);
        progressBar = (ProgressBar) findViewById(R.id.ProgressBar);

        progressBar.setVisibility(View.INVISIBLE);


        CreateAccountButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                gotoLogin();
            }
        });

        Username.setFilters(new InputFilter[] {
                new InputFilter.AllCaps() {
                    @Override
                    public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
                        return String.valueOf(source).toLowerCase();
                    }
                }
        });

    }



    private void gotoLogin()
    {
        String username = Username.getText().toString();

        Query firebaseQuery = FirebaseDatabase.getInstance().getReference("Users").orderByChild("username")
                .equalTo(username);

        firebaseQuery.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(TextUtils.isEmpty(username))
                {
                    Toast.makeText(getApplicationContext(), "Username required!", Toast.LENGTH_SHORT).show();
                }
                else if(snapshot.getChildrenCount()>0)
                {
                    Toast.makeText(RegisterUsername.this, "Username already taken", Toast.LENGTH_SHORT).show();
                }else if (Username.getText().toString().contains(" "))
                {
                    Toast.makeText(RegisterUsername.this, "No Space Allowed", Toast.LENGTH_SHORT).show();
                }
                else if(Username.getText().toString().matches("[\"[<>,.?/:;{}|!@#$%^&*+=] ]*\"]*"))
                {
                    Toast.makeText(RegisterUsername.this, "Characters not allowed", Toast.LENGTH_SHORT).show();
                }
                else if (Username.getText().toString().matches("[\"[a-zA-Z0-9 _ ]*\"]*"))
                {
                    String user_id = mAuth.getCurrentUser().getUid();
                    DatabaseReference current_user_db = FirebaseDatabase.getInstance().getReference().child("Users").child(user_id);

                    HashMap userMap = new HashMap();
                    userMap.put("username", username);

                    DatabaseReference ref = FirebaseDatabase.getInstance().getReference().child("active_usernames");

                    ref.child(username).setValue(true);


                    current_user_db.updateChildren(userMap).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task)
                        {
                            progressBar.setVisibility(View.VISIBLE);
                            if(task.isSuccessful())
                            {
                                Toast.makeText(RegisterUsername.this, "Registration Successful, we've sent you an email. Please check and verify your account.", Toast.LENGTH_SHORT).show();
                                SendUserToLoginActivity();
                            }
                        }
                    });

                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

    }


    private void SendUserToLoginActivity()
    {
        progressBar.setVisibility(View.INVISIBLE);
        Intent mainIntent = new Intent(RegisterUsername.this, LoginActivity.class);
        mainIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(mainIntent);
    }
}