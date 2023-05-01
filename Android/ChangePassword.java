package com.zinging.hobbystar;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDialogFragment;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class ChangePassword extends AppCompatDialogFragment
{
    private EditText CurrentPass, NewPass;
    private Button Confirm;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_change_password, null);

        builder.setView(view);

        CurrentPass = view.findViewById(R.id.passwordEt);
        NewPass = view.findViewById(R.id.passwordEt1);
        Confirm = view.findViewById(R.id.confirm_password);

        Confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String oldpassword = CurrentPass.getText().toString().trim();
                String newpassword = NewPass.getText().toString().trim();
                if(TextUtils.isEmpty(oldpassword))
                {
                    Toast.makeText(getContext(), "Password is empty", Toast.LENGTH_SHORT).show();
                }
                else if(newpassword.length()<8)
                {
                    Toast.makeText(getContext(), "Password Too Short", Toast.LENGTH_SHORT).show();
                }
                else {
                    updatePassword(oldpassword, newpassword);
                }
            }
        });

        return builder.create();
    }

    private void updatePassword(String oldpassword, String newpassword)
    {
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

        AuthCredential authCredential = EmailAuthProvider.getCredential(user.getEmail(), oldpassword);
        user.reauthenticate(authCredential).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void aVoid)
            {
                user.updatePassword(newpassword).addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid) {
                        Toast.makeText(getContext(), "Password Updated", Toast.LENGTH_SHORT).show();
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
