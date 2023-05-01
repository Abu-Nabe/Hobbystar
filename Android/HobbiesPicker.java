package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class HobbiesPicker extends AppCompatActivity implements AdapterView.OnItemSelectedListener {

    private Button hobbyselect;
    private DatabaseReference UsersRef;
    private FirebaseAuth mAuth;

    private String userid;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_hobbies_picker);

        mAuth = FirebaseAuth.getInstance();
        hobbyselect = (Button) findViewById(R.id.confirm_hobby);

        userid = mAuth.getCurrentUser().getUid();
        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(userid);

        Spinner spinner = findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> arrayAdapter = ArrayAdapter
                .createFromResource(this, R.array.Hobbies, android.R.layout.simple_spinner_item);
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(arrayAdapter);
        spinner.setOnItemSelectedListener(this);

        hobbyselect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                UsersRef.addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            if(snapshot.hasChild("hobbyname"))
                            {
                                finish();
                            }
                            else{
                                Toast.makeText(HobbiesPicker.this, "Select A Hobby", Toast.LENGTH_SHORT).show();
                            }
                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });
            }
        });
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l)
    {
        String text = adapterView.getItemAtPosition(i).toString();
        
        if(text.equals("Select"))
        {
            Toast.makeText(this, "Select A Hobby", Toast.LENGTH_SHORT).show();
        }
        else {
            HashMap usermap = new HashMap();
            usermap.put("hobbyname", text);

            UsersRef.updateChildren(usermap);
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {

    }
}