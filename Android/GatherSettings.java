package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class GatherSettings extends AppCompatActivity
{
    private TextView GatherEdit, GathererEdit;
    private Button Confirm;

    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gather_settings);

        GatherEdit = (TextView) findViewById(R.id.Gather_EditName);
        GathererEdit = (TextView) findViewById(R.id.Gather_EditBase);

        Confirm = (Button) findViewById(R.id.ConfirmGatherChanges);

        mAuth = FirebaseAuth.getInstance();

        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(mAuth.getCurrentUser().getUid());

        Confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CreateNewAccount();
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();

        UsersRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("gathername"))
                    {
                        String gather = snapshot.child("gathername").getValue().toString();
                        GatherEdit.setText(gather);
                    } if(snapshot.hasChild("gatherername"))
                    {
                        String gatherer = snapshot.child("gatherername").getValue().toString();
                        GathererEdit.setText(gatherer);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    private void CreateNewAccount()
    {
        String Gather = GatherEdit.getText().toString();
        String Gatherer = GathererEdit.getText().toString();

            String user_id = mAuth.getCurrentUser().getUid();
            DatabaseReference current_user_db = FirebaseDatabase.getInstance().getReference().child("Users").child(user_id);

            HashMap userMap = new HashMap();
            userMap.put("gathername", Gather);
            userMap.put("gatherername", Gatherer);

            current_user_db.updateChildren(userMap).addOnCompleteListener(new OnCompleteListener() {
                @Override
                public void onComplete(@NonNull Task task) {
                    finish();
                }
            });

    }
}