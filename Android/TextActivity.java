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

import com.zinging.hobbystar.Adapter.TextAdapter;
import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.Texting;
import com.zinging.hobbystar.Model.TimeAgo;
import com.zinging.hobbystar.Notifications.APIService;
import com.zinging.hobbystar.Notifications.Client;
import com.zinging.hobbystar.Notifications.Data;
import com.zinging.hobbystar.Notifications.MyResponse;
import com.zinging.hobbystar.Notifications.Sender;
import com.zinging.hobbystar.Notifications.Token;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.Query;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.StorageTask;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import de.hdodenhof.circleimageview.CircleImageView;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class TextActivity extends AppCompatActivity
{
    private String chatreceiverid, chatreceivename, Chatimage, messagesenderid, myUrl;

    private TextView username, last_seen;
    private CircleImageView chatimage;
    private ImageButton sendbutton, imagebutton;
    private ImageView finishbutton;

    private EditText messageinput;
    private RecyclerView UserMessageslist;

    private FirebaseAuth mAuth;
    private DatabaseReference mRootRef, reference;
    private Uri fileuri;
    private StorageTask uploadtask;

    private static final int Gallery_Pick = 1;
    StorageReference mStorageReference;
    APIService apiService;
    boolean notify = false;

    Message user;

    List<Texting> mText;
    TextAdapter textAdapter;
    Intent intent;

    ValueEventListener seenList;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_text);

        sendbutton = (ImageButton) findViewById(R.id.sendButton);
        messageinput = (EditText) findViewById(R.id.messageArea);
        imagebutton = (ImageButton) findViewById(R.id.ImageButton);
        finishbutton = (ImageView) findViewById(R.id.backtomessage);

        username = (TextView) findViewById(R.id.chat_username);
        last_seen = (TextView) findViewById(R.id.chat_seen);
        chatimage = (CircleImageView) findViewById(R.id.chat_image);

        TimeAgo getTimeAgoObject = new TimeAgo();

        chatreceiverid = getIntent().getStringExtra("chat");
        chatreceivename = getIntent().getStringExtra("chatusername");
        Chatimage = getIntent().getStringExtra("chatimage");

        mAuth = FirebaseAuth.getInstance();
        mRootRef = FirebaseDatabase.getInstance().getReference();
        messagesenderid = mAuth.getCurrentUser().getUid();

        apiService = Client.getClient("https://fcm.googleapis.com/").create(APIService.class);

        UserMessageslist = (RecyclerView) findViewById(R.id.text_recycler);
        UserMessageslist.setHasFixedSize(true);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setStackFromEnd(true);
        UserMessageslist.setLayoutManager(linearLayoutManager);

        messageinput.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//                if(!messageinput.getText().toString().isEmpty()) {
//                    mRootRef.child("Users").child(messagesenderid).child("online").setValue("Texting");
//                }
//                else if(messageinput.getText().toString().isEmpty())
//                {
//                    mRootRef.child("Users").child(messagesenderid).child("online").setValue("Online");
//                }
                mRootRef.child("Users").child(messagesenderid).child("online").setValue("Texting");
            }
        });


        finishbutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        mRootRef.child("Users").child(chatreceiverid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot.exists()) {
                    String name = snapshot.child("username").getValue().toString();
                    username.setText(name);

                    if (snapshot.hasChild("profileimage"))
                    {
                        String profileiamge = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(profileiamge).placeholder(R.drawable.profile).into(chatimage);
                    }

                    String online = snapshot.child("online").getValue().toString();

                    if (online.equals("Online")) {
                        last_seen.setText("Online");
                    } else if (online.equals("Texting")) {
                        last_seen.setText("Is Typing...");
                    } else {
                        String time = snapshot.child("online").getValue().toString();
                        String chattime = getTimeAgoObject.getTimeAgo(Long.parseLong(time), last_seen.getContext());
                        last_seen.setText(chattime);
                    }
                }
            }

                @Override
                public void onCancelled (@NonNull DatabaseError error) {

                }
        });

        seenMessage(chatreceiverid);

        readMessages(messagesenderid, chatreceiverid);

        istexting();

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

        sendbutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                notify = true;
                String msg = messageinput.getText().toString();
                mRootRef.child("Users").child(messagesenderid).child("online").setValue("Online");

                if(!msg.equals(""))
                {
                    sendMessage(messagesenderid, chatreceiverid, msg);
                }

                messageinput.setText("");
            }
        });


        username.setText(chatreceivename);
        Picasso.get().load(Chatimage).placeholder(R.drawable.profile).into(chatimage);

        chatimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(TextActivity.this, AddProfileActivity.class);
                intent.putExtra("visit_user_id", chatreceiverid);
                startActivity(intent);
            }
        });

        username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(TextActivity.this, AddProfileActivity.class);
                intent.putExtra("visit_user_id", chatreceiverid);
                startActivity(intent);
            }
        });

        DatabaseReference unreadMsg = FirebaseDatabase.getInstance().getReference();
        unreadMsg.child("Unread").child(messagesenderid).child(chatreceiverid).child("Unread").removeValue();
    }

    private void istexting()
    {
        if(!messageinput.getText().toString().isEmpty()) {
            mRootRef.child("Users").child(messagesenderid).child("online").setValue("Texting");
        }else if(messageinput.getText().toString().isEmpty())
        {
            mRootRef.child("Users").child(messagesenderid).child("online").setValue("Online");
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == 100 && resultCode == RESULT_OK && data!=null && data.getData() != null)
        {
            fileuri = data.getData();

            StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("Image Files");

            String current_user_Ref = "Chats/" + messagesenderid + "/" + chatreceiverid;
            String chat_user_Ref = "Chats/" + chatreceiverid + "/" + messagesenderid;

            DatabaseReference user_message_push = mRootRef.child("Chats")
                    .child(messagesenderid).child(chatreceiverid).push();

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

                        Map messageUserMap = new HashMap();
                        messageUserMap.put(current_user_Ref + "/" + message_push_id, messageMap);
                        messageUserMap.put(chat_user_Ref + "/" + message_push_id, messageMap);

                        messageinput.setText("");

                        mRootRef.child("Chats").child(messagesenderid).child(chatreceiverid).push().setValue(messageMap);
                        mRootRef.child("Chats").child(chatreceiverid).child(messagesenderid).push().setValue(messageMap);

                        DatabaseReference chatmsg = FirebaseDatabase.getInstance().getReference();

                        mRootRef.child("Users").child(chatreceiverid).child("Unread").setValue(message_push_id);

                        chatmsg.child("Message").child(messagesenderid).child(chatreceiverid).child("Text").setValue("ImageSent")
                                .addOnSuccessListener(new OnSuccessListener<Void>() {
                                    @Override
                                    public void onSuccess(Void aVoid)
                                    {
                                        chatmsg.child("Message").child(chatreceiverid).child(messagesenderid).child("Text").setValue("ImageSent").addOnSuccessListener(new OnSuccessListener<Void>() {
                                            @Override
                                            public void onSuccess(Void aVoid)
                                            {
                                                chatmsg.child("Message").child(messagesenderid).child(chatreceiverid).child("timestamp").setValue(System.currentTimeMillis());
                                                chatmsg.child("Message").child(chatreceiverid).child(messagesenderid).child("timestamp").setValue(System.currentTimeMillis());
                                                chatmsg.child("Message").child(messagesenderid).child(chatreceiverid).child("seen").setValue(false);
                                                chatmsg.child("Message").child(chatreceiverid).child(messagesenderid).child("seen").setValue(false);
                                            }
                                        });
                                    }
                                });
                    }
                }
            });
        }
    }

    private void seenMessage(String userid)
    {
        reference = FirebaseDatabase.getInstance().getReference("Chats");
        seenList = reference.child(chatreceiverid).child(messagesenderid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot) {
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    Texting chat = snapshot.getValue(Texting.class);
                    if(chat.getReceiver().equals(messagesenderid) && chat.getSender().equals(userid))
                    {
                        HashMap<String, Object> hashMap = new HashMap<>();
                        hashMap.put("seen", true);
                        snapshot.getRef().updateChildren(hashMap);

                        DatabaseReference msgref = FirebaseDatabase.getInstance().getReference("Message");
                        msgref.child(messagesenderid).child(chatreceiverid).child("seen").setValue(true);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });


    }


    private void sendMessage(String sender, String receiver, String message)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference();

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("sender", sender);
        hashMap.put("receiver", receiver);
        hashMap.put("message", message);
        hashMap.put("seen", false);

        reference.child("Chats").child(sender).child(receiver).push().setValue(hashMap);
        reference.child("Chats").child(receiver).child(sender).push().setValue(hashMap);

        mRootRef.child("Users").child(chatreceiverid).child("Unread").setValue(message);


        String  msg = message;

        reference = FirebaseDatabase.getInstance().getReference("Users").child(messagesenderid);
        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                Message user = snapshot.getValue(Message.class);
                if (notify) {
                    sendNotifications(receiver, user.getUsername(), msg);
                }
                notify = false;
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        DatabaseReference chatmsg = FirebaseDatabase.getInstance().getReference();

        chatmsg.child("Message").child(messagesenderid).child(chatreceiverid).child("Text").setValue(message)
                .addOnSuccessListener(new OnSuccessListener<Void>() {
                    @Override
                    public void onSuccess(Void aVoid)
                    {
                        chatmsg.child("Message").child(chatreceiverid).child(messagesenderid).child("Text").setValue(message).addOnSuccessListener(new OnSuccessListener<Void>() {
                            @Override
                            public void onSuccess(Void aVoid)
                            {
                                chatmsg.child("Message").child(messagesenderid).child(chatreceiverid).child("timestamp").setValue(System.currentTimeMillis());
                                chatmsg.child("Message").child(chatreceiverid).child(messagesenderid).child("timestamp").setValue(System.currentTimeMillis());
                                chatmsg.child("Message").child(messagesenderid).child(chatreceiverid).child("seen").setValue(false);
                                chatmsg.child("Message").child(chatreceiverid).child(messagesenderid).child("seen").setValue(false);
                            }
                        });
                    }
                });

        DatabaseReference unreadMsg = FirebaseDatabase.getInstance().getReference();

        unreadMsg.child("Unread").child(chatreceiverid).child(messagesenderid).push().setValue(true);
    }

    private void sendNotifications(String receiver, String username, String message)
    {
        DatabaseReference tokens = FirebaseDatabase.getInstance().getReference("Tokens");
        Query query = tokens.orderByKey().equalTo(receiver);
        query.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot)
            {
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    Token token = snapshot.getValue(Token.class);
                    Data data = new Data(messagesenderid, R.drawable.notificationlogo, username+": "+message, "New Message",
                            chatreceiverid);

                    Sender sender = new Sender(data, token.getToken());

                    apiService.sendNotification(sender)
                            .enqueue(new Callback<MyResponse>() {
                                @Override
                                public void onResponse(Call<MyResponse> call, Response<MyResponse> response) {
//                                    Toast.makeText(TextActivity.this, ""+response.message(), Toast.LENGTH_SHORT).show();
                                }

                                @Override
                                public void onFailure(Call<MyResponse> call, Throwable t) {

                                }
                            });
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }


    private void readMessages(String myid, String userid)
    {
        mText = new ArrayList<>();

        reference = FirebaseDatabase.getInstance().getReference("Chats");
        reference.child(myid).child(userid).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot datasnapshot) {
                mText.clear();
                for(DataSnapshot snapshot: datasnapshot.getChildren())
                {
                    Texting text = snapshot.getValue(Texting.class);

                    if(text.getReceiver().equals(myid) && text.getSender().equals(userid) ||
                        text.getReceiver().equals(userid) && text.getSender().equals(myid))
                    {
                        mText.add(text);

                        textAdapter = new TextAdapter(TextActivity.this, mText);
                        UserMessageslist.setAdapter(textAdapter);
                    }

                }

            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

    }

}
