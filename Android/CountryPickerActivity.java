package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import java.util.HashMap;

public class CountryPickerActivity extends AppCompatActivity implements AdapterView.OnItemSelectedListener  {

    private ImageView countryFlag;
    private Button countrySelect;

    private DatabaseReference UsersRef, CountryRef;
    private FirebaseAuth mAuth;

    private String userid;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_country_picker);

        countryFlag = findViewById(R.id.CountryFlag);
        countrySelect = findViewById(R.id.confirm_country);

        mAuth = FirebaseAuth.getInstance();

        userid = mAuth.getCurrentUser().getUid();
        CountryRef = FirebaseDatabase.getInstance().getReference("Countries");
        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(userid);


        Spinner spinner = findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> arrayAdapter = ArrayAdapter
                .createFromResource(this, R.array.Countries, android.R.layout.simple_spinner_item);
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(arrayAdapter);
        spinner.setOnItemSelectedListener(this);

        countrySelect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                UsersRef.addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            if(snapshot.hasChild("hobby"))
                            {
                                finish();
                            }
                            else{
                                Toast.makeText(CountryPickerActivity.this, "Select A Country", Toast.LENGTH_SHORT).show();
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
            Toast.makeText(this, "Select A Country", Toast.LENGTH_SHORT).show();
        }
        else {

            countrySelected(text);


        }
    }

    private void countrySelected(String text)
    {
        CountryRef.child(text).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    String country = snapshot.getValue().toString();
                    Picasso.get().load(country).fit().centerCrop().into(countryFlag);

                    HashMap usermap = new HashMap();
                    usermap.put("hobby", country);

                    UsersRef.updateChildren(usermap);

                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {

    }
}