package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDialogFragment;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
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

public class  NewInfo extends AppCompatDialogFragment {

    private TextView username, dob, firstname, lastname;
    private Button confirm;
    private DatabaseReference registerRef, UsersRef;

    FirebaseAuth mAuth;
    String userid;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState) {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_new_info, null);

        builder.setView(view);

        username = view.findViewById(R.id.new_username);
        dob = view.findViewById(R.id.new_dob);
        firstname = view.findViewById(R.id.Firstname);
        lastname = view.findViewById(R.id.Lastname);
        confirm = view.findViewById(R.id.new_button);

        mAuth = FirebaseAuth.getInstance();
        userid = mAuth.getCurrentUser().getUid();

        registerRef = FirebaseDatabase.getInstance().getReference("Register").child(userid);
        UsersRef = FirebaseDatabase.getInstance().getReference("Users").child(userid);

        registerRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("username"))
                    {
                        String Username = snapshot.child("username").getValue().toString();
                        username.setText(Username);
                    }if(snapshot.hasChild("DOB"))
                    {
                        String DOB = snapshot.child("DOB").getValue().toString();
                        dob.setText(DOB);
                    }if(snapshot.hasChild("firstname"))
                    {
                        String Firstname = snapshot.child("firstname").getValue().toString();
                        firstname.setText(Firstname);
                    }if(snapshot.hasChild("lastname"))
                    {
                        String Lastname = snapshot.child("lastname").getValue().toString();
                        lastname.setText(Lastname);
                    }
                    confirm.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view)
                        {
                            String Username = username.getText().toString();
                            String DOB = dob.getText().toString();
                            String Firstname = firstname.getText().toString();
                            String Lastname = lastname.getText().toString();

                            if(TextUtils.isEmpty(Username))
                            {
                                Toast.makeText(getContext(), "Username required", Toast.LENGTH_SHORT).show();
                            }else if(TextUtils.isEmpty(DOB))
                            {
                                Toast.makeText(getContext(), "Birthday required", Toast.LENGTH_SHORT).show();
                            }else if(TextUtils.isEmpty(Firstname))
                            {
                                Toast.makeText(getContext(), "Firstname required", Toast.LENGTH_SHORT).show();
                            }else if(TextUtils.isEmpty(Lastname))
                            {
                                Toast.makeText(getContext(), "Lastname required", Toast.LENGTH_SHORT).show();
                            }else{
                                HashMap usermape = new HashMap();
                                usermape.put("username", Username);
                                usermape.put("DOB", DOB);
                                usermape.put("firstname", Firstname);
                                usermape.put("lastname", Lastname);

                                UsersRef.updateChildren(usermape).addOnSuccessListener(new OnSuccessListener() {
                                    @Override
                                    public void onSuccess(Object o) {
                                        registerRef.removeValue();
                                        Intent intent = new Intent(getContext(), HobbiesPicker.class);
                                        startActivity(intent);
                                    }
                                });
                            }

                        }
                    });
                }

            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        return builder.create();
    }
}