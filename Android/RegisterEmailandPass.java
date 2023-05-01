package com.zinging.hobbystar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class RegisterEmailandPass extends AppCompatActivity
{

    private EditText Username, Password;
    private Button CreateAccountButton;

    private DatabaseReference UsersRef, currentUser;
    private FirebaseAuth mAuth;
    private Boolean emailAddressChecker;

    String userID;



    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_emailandpass);

        mAuth = FirebaseAuth.getInstance();
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");

        Username = (EditText) findViewById(R.id.register_username);
        Password = (EditText) findViewById(R.id.register_password);
        CreateAccountButton = (Button) findViewById(R.id.user_passContinue);


        CreateAccountButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                GoToEmail();
            }
        });

    }

    private void SendUserToLoginActivity()
    {

        Intent mainIntent = new Intent(RegisterEmailandPass.this, RegisterActivity.class);
        mainIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(mainIntent);
    }


    private boolean Email_Validate(String email)
    {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }
    private void GoToEmail()
    {
        String email = Username.getText().toString();
        String password = Password.getText().toString();

        if(TextUtils.isEmpty(email))
        {
            Toast.makeText(RegisterEmailandPass.this, "Email required!", Toast.LENGTH_SHORT).show();
        }
        else if(password.length() < 8 && password.length() > 32)
        {
            Toast.makeText(RegisterEmailandPass.this, "Password too Short or Long", Toast.LENGTH_SHORT).show();
        }
        else
        {
            mAuth.createUserWithEmailAndPassword(email, password)
                    .addOnCompleteListener(task -> {
                        if(task.isSuccessful())
                        {
                            FirebaseUser user = mAuth.getCurrentUser();
                            user.sendEmailVerification();

                            SendUserToLoginActivity();
                        }
                    });
        }
    }



}