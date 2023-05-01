package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.HashMap;

public class SuggestionSettings extends AppCompatActivity
{

    private EditText recommendation;
    private Button confirm;

    private FirebaseAuth mAuth;
    private DatabaseReference ref;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_suggestion_settings);

        recommendation = (EditText) findViewById(R.id.recommend);
        confirm = (Button) findViewById(R.id.confirm_recommend);

        mAuth = FirebaseAuth.getInstance();
        ref = FirebaseDatabase.getInstance().getReference().child("Suggestions");

        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Save();
            }
        });

        recommendation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                recommendation.setText("");
            }
        });
    }

    private void Save()
    {
        String suggest = recommendation.getText().toString();
        if(suggest.equals("Suggestions"))
        {
            Intent intent = new Intent(SuggestionSettings.this, ProfileActivity.class);
            startActivity(intent);
        }else
        {
            HashMap userMap = new HashMap();
            userMap.put("Sugegestion", suggest);

            ref.push().setValue(userMap).addOnCompleteListener(new OnCompleteListener() {
                @Override
                public void onComplete(@NonNull Task task) {
                    Intent intent = new Intent(SuggestionSettings.this, ProfileActivity.class);
                    startActivity(intent);
                }
            });
        }
    }
}