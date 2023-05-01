package com.zinging.hobbystar;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDialogFragment;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import de.hdodenhof.circleimageview.CircleImageView;

public class StoryActivity extends AppCompatDialogFragment
{

    private TextView Bio, Points, Username;
    private CircleImageView imageview;

    private DatabaseReference UsersRef;


    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.story, null);

        builder.setView(view);

        Bio = view.findViewById(R.id.StoryWriting);
        Points = view.findViewById(R.id.StoryPoints);
        Username = view.findViewById(R.id.StoryUsername);
        imageview = view.findViewById(R.id.Story_profileimg);


        Bundle bundle = getArguments();
        String userid = bundle.getString("UserInfo","");

        UsersRef = FirebaseDatabase.getInstance().getReference("Users");


        UsersRef.child(userid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Bio"))
                    {
                        String bio = snapshot.child("Bio").getValue().toString();
                        Bio.setText(bio);
                    }
                    if(snapshot.hasChild("profileimage"))
                    {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).into(imageview);
                    }
                    if(snapshot.hasChild("points"))
                    {
                        Points.setText(snapshot.child("points").getChildrenCount()+" points");
                    }
                    String username = snapshot.child("username").getValue().toString();
                    Username.setText(username);

                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        imageview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getActivity(), AddProfileActivity.class);
                intent.putExtra("visit_user_id", userid);
                startActivity(intent);
            }
        });

        Username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getActivity(), AddProfileActivity.class);
                intent.putExtra("visit_user_id", userid);
                startActivity(intent);
            }
        });

        return builder.create();



    }
}
