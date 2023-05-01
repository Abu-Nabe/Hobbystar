package com.zinging.hobbystar;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.HashMap;

public class RegisterActivity extends AppCompatActivity
{
    private EditText FirstName, LastName;
    private Button CreateAccountButton;
    private ProgressDialog loadingBar;

    private DatabaseReference UsersRef;
    private FirebaseAuth mAuth;


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);


        mAuth = FirebaseAuth.getInstance();
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child("currentUserID");

        FirstName = (EditText) findViewById(R.id.register_first_name);
        LastName = (EditText) findViewById(R.id.register_last_name);
        CreateAccountButton = (Button) findViewById(R.id.register_create_account);
        loadingBar = new ProgressDialog(this);





        CreateAccountButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                CreateNewAccount();
            }
        });
    }




    private void SendUserToMainActivity()
    {
        Intent mainIntent = new Intent(RegisterActivity.this, HomeActivity.class);
        mainIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(mainIntent);
        finish();
    }



    private void CreateNewAccount()
    {
        String firstname = FirstName.getText().toString();
        String lastname = LastName.getText().toString();

        if(TextUtils.isEmpty(firstname))
        {
            Toast.makeText(this, "Firstname required!", Toast.LENGTH_SHORT).show();
        }
        else if(TextUtils.isEmpty(lastname))
        {
            Toast.makeText(this, "Lastname required!", Toast.LENGTH_SHORT).show();
        }
        else
        {
            String user_id = mAuth.getCurrentUser().getUid();
            DatabaseReference current_user_db = FirebaseDatabase.getInstance().getReference().child("Users").child(user_id);

            HashMap userMap = new HashMap();
            userMap.put("firstname", firstname);
            userMap.put("lastname", lastname);

            current_user_db.setValue(userMap);

                SendUserToSetupActivity();


        }
    }



    private void SendUserToSetupActivity()
    {
        Intent setupIntent = new Intent(RegisterActivity.this, RegisterDOB.class);
        setupIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(setupIntent);
    }
}