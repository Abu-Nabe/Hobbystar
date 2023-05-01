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
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class ChangeEmail extends AppCompatDialogFragment
{

    private EditText CurrentEmail, NewEmail;
    private Button Confirm;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_change_email, null);

        builder.setView(view);

        CurrentEmail = view.findViewById(R.id.emailEt);
        NewEmail = view.findViewById(R.id.emailEt1);
        Confirm = view.findViewById(R.id.confirm_email);

        Confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                String oldemail = CurrentEmail.getText().toString().trim();
                String newemail = NewEmail.getText().toString().trim();
                if(TextUtils.isEmpty(oldemail))
                {
                    Toast.makeText(getContext(), "Password is empty", Toast.LENGTH_SHORT).show();
                }
                else if(newemail.length()<8)
                {
                    Toast.makeText(getContext(), "Password Too Short", Toast.LENGTH_SHORT).show();
                }else {
                    updateEmail(oldemail, newemail);
                }
            }
        });

        return builder.create();
    }

    private void updateEmail(String oldemail, String newemail)
    {
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

        AuthCredential authCredential = EmailAuthProvider.getCredential(user.getEmail(), oldemail);
        user.reauthenticate(authCredential).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void aVoid)
            {
                user.updateEmail(newemail).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        Toast.makeText(getContext(), "Email Updated", Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent(getContext(), InfoSettings.class);
                        startActivity(intent);
                    }
                });
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Toast.makeText(getContext(), "Failed to Update", Toast.LENGTH_SHORT).show();
            }
        });
    }
}