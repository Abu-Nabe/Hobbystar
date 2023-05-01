package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.zinging.hobbystar.Adapter.GatherAdapter;
import com.zinging.hobbystar.Model.Gather;
import com.zinging.hobbystar.Model.Message;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.StorageTask;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GatherMessage extends AppCompatActivity {

    private String chatreceiverid, chatreceivename, Chatimage, messagesenderid, myUrl, Gatherusername;

    private TextView Gathername;
    private String usernameData;
    private ImageButton sendbutton, imagebutton;
    private ImageView GatherBack;

    private EditText messageinput;
    private RecyclerView GatherList;

    private FirebaseAuth mAuth;
    private FirebaseUser fuser;
    private DatabaseReference mRootRef, reference, Gather;
    private Uri fileuri;
    private StorageTask uploadtask;

    private static final int Gallery_Pick = 1;
    StorageReference mStorageReference;

    Message user;

    List<Gather> mGather;
    GatherAdapter textAdapter;
    Intent intent;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gather_message);


        sendbutton = (ImageButton) findViewById(R.id.SendGatherButton);
        messageinput = (EditText) findViewById(R.id.GatherArea);
        imagebutton = (ImageButton) findViewById(R.id.GatherImageButton);
        GatherBack = (ImageView) findViewById(R.id.backtoprofile);
        Gathername = (TextView) findViewById(R.id.gather_name);

        mAuth = FirebaseAuth.getInstance();
        mRootRef = FirebaseDatabase.getInstance().getReference();
        messagesenderid = mAuth.getCurrentUser().getUid();

        Gather = FirebaseDatabase.getInstance().getReference("Users");

        GatherList = (RecyclerView) findViewById(R.id.gather_recycler);
        GatherList.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setStackFromEnd(true);
        GatherList.setLayoutManager(linearLayoutManager);

        chatreceiverid = getIntent().getExtras().get("gatheruser").toString();
        Gatherusername = getIntent().getExtras().get("gatherusername").toString();

        readMessages(chatreceiverid);

        Gather.child(messagesenderid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists());
                {
                    String name = snapshot.child("username").getValue().toString();
                    usernameData = name;
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        Gather.child(chatreceiverid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("gathername"))
                    {
                        String gathername = snapshot.child("gathername").getValue().toString();
                        Gathername.setText(gathername);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        Gathername.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(chatreceiverid.equals(messagesenderid))
                {
                    Intent intent = new Intent(GatherMessage.this, GatherSettings.class);
                    startActivity(intent);
                }
                else{
                    Intent intent = new Intent(GatherMessage.this, GatherList.class);
                    intent.putExtra("gatherid", chatreceiverid);
                    startActivity(intent);
                }
            }
        });

        GatherBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               finishit();
            }
        });

        sendbutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                String msg = messageinput.getText().toString();

                if(!msg.equals(""))
                {
                    sendMessage(messagesenderid, chatreceiverid, msg, Gatherusername);
                }else
                {
                    Toast.makeText(GatherMessage.this, "Send a message", Toast.LENGTH_SHORT).show();
                }

                messageinput.setText("");
            }
        });

        imagebutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                Intent galleryIntent = new Intent();
                galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
                galleryIntent.setType("image/*");
                startActivityForResult(galleryIntent.createChooser(galleryIntent, "Select Image"), 100);
            }
        });
    }

    private void finishit()
    {
        finish();
    }

    private void sendMessage(String sender, String receiver, String message, String username)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference();


        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("sender", sender);
        hashMap.put("receiver", receiver);
        hashMap.put("message", message);
        hashMap.put("username", username);
        hashMap.put("seen", false);

        reference.child("Gathers").child(chatreceiverid).push().setValue(hashMap);

        final String msg = message;
    }

    private void readMessages(String userid)
    {
        mGather = new ArrayList<>();

        reference = FirebaseDatabase.getInstance().getReference("Gathers").child(userid);
        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                mGather.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    Gather text = snapshot.getValue(Gather.class);

                    mGather.add(text);

                    textAdapter = new GatherAdapter(GatherMessage.this, mGather);
                    GatherList.setAdapter(textAdapter);

                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == 100 && resultCode == RESULT_OK && data!=null && data.getData() != null)
        {
            fileuri = data.getData();

            StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("Image Files");

            String current_user_Ref = "Gathers/" + messagesenderid + "/" + chatreceiverid;
            String chat_user_Ref = "Gathers/" + chatreceiverid + "/" + messagesenderid;

            DatabaseReference user_message_push = mRootRef.child("Gathers")
                    .child(chatreceiverid).push();

            final String message_push_id = user_message_push.getKey();

            StorageReference filepath = storageReference.child(message_push_id + "," + "jpg");

            uploadtask = filepath.putFile(fileuri);

            uploadtask.continueWithTask(new Continuation() {
                @Override
                public Object then(@NonNull Task task) throws Exception
                {
                    if(!task.isSuccessful())
                    {
                        throw task.getException();
                    }

                    return filepath.getDownloadUrl();
                }
            }).addOnCompleteListener(new OnCompleteListener<Uri>() {
                @Override
                public void onComplete(@NonNull Task<Uri> task)
                {
                    if(task.isSuccessful())
                    {
                        Uri downloadUri = task.getResult();
                        myUrl = downloadUri.toString();

                        Map messageMap = new HashMap();
                        messageMap.put("sender", messagesenderid);
                        messageMap.put("receiver", chatreceiverid);
                        messageMap.put("image", myUrl);
                        messageMap.put("messageid", message_push_id);
                        messageMap.put("seen", false);
                        messageMap.put("username", usernameData);

                        messageinput.setText("");

                        mRootRef.child("Gathers").child(chatreceiverid).push().setValue(messageMap);
                    }
                }
            });
        }
    }


}