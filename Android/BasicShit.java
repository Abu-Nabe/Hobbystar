//package com.example.afinal;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//
//import android.os.Bundle;
//import android.text.format.DateUtils;
//import android.view.View;
//import android.widget.Button;
//import android.widget.TextView;
//
//import com.example.afinal.Model.TimeAgo;
//import com.google.android.gms.tasks.OnCompleteListener;
//import com.google.android.gms.tasks.Task;
//import com.google.firebase.auth.FirebaseAuth;
//import com.google.firebase.database.DataSnapshot;
//import com.google.firebase.database.DatabaseError;
//import com.google.firebase.database.DatabaseReference;
//import com.google.firebase.database.FirebaseDatabase;
//import com.google.firebase.database.ValueEventListener;
//
//import java.util.Date;
//import java.util.HashMap;
//
//public class BasicShit extends AppCompatActivity {
//
//    private TextView fkin;
//    private Button hell;
//
//    DatabaseReference UsersRef;
//    String userid;
//    FirebaseAuth mAuth;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_basic_shit);
//
//        mAuth = FirebaseAuth.getInstance();
//
//        UsersRef = FirebaseDatabase.getInstance().getReference("Time");
//        Long tsLong = System.currentTimeMillis();
//
//        String timeAgo = TimeAgo.getTimeAgo(tsLong);
//
//        fkin = (TextView) findViewById(R.id.time);
//        hell = (Button) findViewById(R.id.confirm);
//
//
//
//        UsersRef.addValueEventListener(new ValueEventListener() {
//            @Override
//            public void onDataChange(@NonNull DataSnapshot snapshot) {
//                if(snapshot.hasChild("date"))
//                {
//                    fkin.setText(timeAgo);
//                }
//            }
//
//            @Override
//            public void onCancelled(@NonNull DatabaseError error) {
//
//            }
//        });
//
//        hell.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view)
//            {
//                HashMap usermap = new HashMap();
//                usermap.put("date", tsLong);
//
//                UsersRef.setValue(usermap);
//            }
//        });
//
//
//
//        TimeAgo timeAgo1 = new TimeAgo();
//        CharSequence prettyTime = DateUtils.getRelativeDateTimeString(BasicShit,
//                timeAgo.getTimestamp(), DateUtils.SECOND_IN_MILLIS, DateUtils.WEEK_IN_MILLIS, 0);
//        holder.time.setText(prettyTime);
//    }
//
//}