package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

public class PointActivity extends AppCompatActivity {

    private TextView childPoints, zingPoints;
    private ImageView Convert;
    private Button confirm;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef;

    private String userid;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_point);

        childPoints = (TextView) findViewById(R.id.ChildPoints);
        zingPoints = (TextView) findViewById(R.id.ActualPoints);

        Convert = (ImageView) findViewById(R.id.ClickPoint);
        confirm = (Button) findViewById(R.id.confirm_bug);

        mAuth = FirebaseAuth.getInstance();

        userid = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(userid);

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("points"))
                    {
                        childPoints.setText(snapshot.child("points").getChildrenCount()+ "");
                    }
                    if(snapshot.hasChild("zings"))
                    {
                        String whatthefuck = snapshot.child("zings").getValue().toString();
                        zingPoints.setText(whatthefuck);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        Convert.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                int i =1;
                zingPoints.setText(i++);

//                UsersRef.child("points").addValueEventListener(new ValueEventListener() {
//                    @Override
//                    public void onDataChange(@NonNull DataSnapshot snapshot)
//                    {
//                        if(snapshot.exists()) {
//                            if (snapshot.getChildrenCount() > 1) {
//                                int i = 1;
//                                //Integer i1 = Integer.parseInt(zingPoints.getText().toString());
//
//                                //Integer i2 = i + i1;
////                                UsersRef.child("points").setValue(ServerValue.increment(i));
//                                HashMap usermap = new HashMap();
//                                usermap.put("zings", zingPoints.getText().toString() + fuck++);
//                                UsersRef.updateChildren(usermap).addOnSuccessListener(new OnSuccessListener() {
//                                    @Override
//                                    public void onSuccess(Object o) {
//
//                                       // UsersRef.child("points").removeValue();
//                                    }
//                                });
//                            }
//                        }
//                        else{
//                            Toast.makeText(PointActivity.this, "1000 points required to convert", Toast.LENGTH_SHORT).show();
//                        }
//                    }
//
//                    @Override
//                    public void onCancelled(@NonNull DatabaseError error) {
//
//                    }
//                });
////              if(childPoints.getInputType()z>1)
////              {
////              }
////              else{
////                  Toast.makeText(PointActivity.this, "1000 points required to convert", Toast.LENGTH_SHORT).show();
////              }
            }
        });

        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                finish();
            }
        });
    }
}