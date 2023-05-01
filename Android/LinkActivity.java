package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Bundle;
import android.text.util.Linkify;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.HashMap;

public class LinkActivity extends AppCompatActivity
{
    private TextView link1, link2, link3, link4;
    private ImageView copy1, copy2, copy3, copy4;
    private Button confirm;

    private FirebaseAuth mAuth;
    private DatabaseReference LinkRef;
    String userid;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_link);

        link1 = (TextView) findViewById(R.id.Link1);
        link2 = (TextView) findViewById(R.id.Link2);
        link3 = (TextView) findViewById(R.id.Link3);
        link4 = (TextView) findViewById(R.id.Link4);

        copy1 = (ImageView) findViewById(R.id.Copy1);
        copy2 = (ImageView) findViewById(R.id.Copy2);
        copy3 = (ImageView) findViewById(R.id.Copy3);
        copy4 = (ImageView) findViewById(R.id.Copy4);

        mAuth = FirebaseAuth.getInstance();
        //userid = mAuth.getCurrentUser().getUid();
        String userid = getIntent().getStringExtra("LinkID");

        confirm = (Button) findViewById(R.id.new_button);

        LinkRef = FirebaseDatabase.getInstance().getReference("Links").child(userid);

        if(FirebaseAuth.getInstance().getCurrentUser().getUid().equals(userid))
        {

        }
        else{
            link1.setEnabled(false);
            link2.setEnabled(false);
            link3.setEnabled(false);
            link4.setEnabled(false);
        }

        LinkRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    String uLink1 = snapshot.child("link1").getValue().toString();
                    String uLink2 = snapshot.child("link2").getValue().toString();
                    String uLink3 = snapshot.child("link3").getValue().toString();
                    String uLink4 = snapshot.child("link4").getValue().toString();

                    link1.setText(uLink1);
                    link2.setText(uLink2);
                    link3.setText(uLink3);
                    link4.setText(uLink4);

                    Linkify.addLinks(link1, Linkify.ALL);
                    Linkify.addLinks(link2, Linkify.ALL);
                    Linkify.addLinks(link3, Linkify.ALL);
                    Linkify.addLinks(link4, Linkify.ALL);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (FirebaseAuth.getInstance().getCurrentUser().getUid().equals(userid)) {
                    String Link1 = link1.getText().toString();
                    String Link2 = link2.getText().toString();
                    String Link3 = link3.getText().toString();
                    String Link4 = link4.getText().toString();

                    LinkRef.addValueEventListener(new ValueEventListener() {
                        @Override
                        public void onDataChange(@NonNull DataSnapshot snapshot) {
                            HashMap userMap = new HashMap();
                            userMap.put("link1", Link1);
                            userMap.put("link2", Link2);
                            userMap.put("link3", Link3);
                            userMap.put("link4", Link4);

                            LinkRef.updateChildren(userMap).addOnSuccessListener(new OnSuccessListener() {
                                @Override
                                public void onSuccess(Object o) {
                                    finish();
                                }
                            });
                        }

                        @Override
                        public void onCancelled(@NonNull DatabaseError error) {

                        }
                    });
                }else {
                    finish();
                }
            }
        });

        copy1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                ClipData clip = ClipData.newPlainText("Copy", link3.getText().toString());
                clipboard.setPrimaryClip(clip);

                Toast.makeText(LinkActivity.this, "Link Copied", Toast.LENGTH_SHORT).show();
            }
        });

        copy2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                ClipData clip = ClipData.newPlainText("Copy", link1.getText().toString());
                clipboard.setPrimaryClip(clip);

                Toast.makeText(LinkActivity.this, "Link Copied", Toast.LENGTH_SHORT).show();
            }
        });

        copy3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                ClipData clip = ClipData.newPlainText("Copy", link2.getText().toString());
                clipboard.setPrimaryClip(clip);

                Toast.makeText(LinkActivity.this, "Link Copied", Toast.LENGTH_SHORT).show();
            }
        });

        copy4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                ClipData clip = ClipData.newPlainText("Copy", link4.getText().toString());
                clipboard.setPrimaryClip(clip);

                Toast.makeText(LinkActivity.this, "Link Copied", Toast.LENGTH_SHORT).show();
            }
        });
    }
}