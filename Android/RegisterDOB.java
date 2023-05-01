package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.icu.util.Calendar;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TextView;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.util.HashMap;

public class RegisterDOB extends AppCompatActivity {

    private static final String TAG ="register_dob_activity";

    private TextView mDisplayDate;
    private Button DOBcontinue;
    private DatePickerDialog.OnDateSetListener mDataSetListener;

    private DatabaseReference UsersRef;
    private FirebaseAuth mAuth;

    String currentUserID;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_dob);

        mAuth = FirebaseAuth.getInstance();
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");


        //if(mAuth.getCurrentUser() == null){
        //CurrentUserID = mAuth.getCurrentUser().getUid();
        //}



        mDisplayDate = (TextView) findViewById(R.id.Date);
        DOBcontinue = (Button) findViewById(R.id.DOB_continue);


        DOBcontinue.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                SendUserToRegisterEmail_Password();
            }
        });


        mDisplayDate.setOnClickListener(new View.OnClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.N)
            @Override
            public void onClick(View v)
            {
//                String user_id = mAuth.getCurrentUser().getUid();
//                DatabaseReference current_user_db = FirebaseDatabase.getInstance().getReference().child("Users").child(user_id);
//
//                String dob = mDisplayDate.getText().toString();

                Calendar cal = Calendar.getInstance();
                int year = cal.get(Calendar.YEAR);
                int month = cal.get(Calendar.MONTH);
                int day = cal.get(Calendar.DAY_OF_MONTH);

                DatePickerDialog dialog = new DatePickerDialog(
                        RegisterDOB.this,
                        android.R.style.Theme_Holo_Light_Dialog_MinWidth,
                        mDataSetListener,
                        year, month, day);
                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                dialog.show();


//                HashMap userMap = new HashMap();
//                userMap.put("DOB", dob);
//
//                current_user_db.updateChildren(userMap);

            }
        });

        mDataSetListener = new DatePickerDialog.OnDateSetListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void onDateSet(DatePicker view, int year, int month, int day)
            {
                month = month + 1;
                Log.d(TAG, "onDateSet: mm/dd/yyyy: " + month + "/" + day + "/" + year);

                String date = month + "/" + day + "/" + year;
                mDisplayDate.setText(date);


            }
        };
    }

    private void SendUserToRegisterEmail_Password()
    {
        String user_id = mAuth.getCurrentUser().getUid();
        DatabaseReference current_user_db = FirebaseDatabase.getInstance().getReference().child("Users").child(user_id);

        String dob = mDisplayDate.getText().toString();

            HashMap userMap = new HashMap();
            userMap.put("DOB", dob);

            current_user_db.updateChildren(userMap).addOnCompleteListener(new OnCompleteListener() {
                @Override
                public void onComplete(@NonNull Task task) {
                    Intent EmailIntent = new Intent(RegisterDOB.this, RegisterUsername.class);
                    EmailIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(EmailIntent);
                }
            });
    }
}