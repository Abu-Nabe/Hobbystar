package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.zinging.hobbystar.Model.Message;
import com.zinging.hobbystar.Model.TimeAgo;
import com.firebase.ui.database.FirebaseRecyclerAdapter;
import com.firebase.ui.database.FirebaseRecyclerOptions;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.Query;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import de.hdodenhof.circleimageview.CircleImageView;

public class ChatActivity extends AppCompatActivity
{

    private RecyclerView chat_view;
    private SwipeRefreshLayout Chat_refresh;
    private Toolbar mTopToolbar;

    private DatabaseReference MessageRef, UsersRef, ChatsRef, UnreadRef;
    private FirebaseAuth mAuth;

    private int mCurrentPage = 1;

    String currentUserID;

    private String Image = "chat_image";


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);

        mTopToolbar = (Toolbar) findViewById(R.id.chat_toolbar);
        setSupportActionBar(mTopToolbar);
        getSupportActionBar().setTitle("Message");


        chat_view = (RecyclerView) findViewById(R.id.MessageRecyclerView);
        chat_view.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        chat_view.setLayoutManager(linearLayoutManager);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();


        MessageRef = FirebaseDatabase.getInstance().getReference().child("Message").child(currentUserID);
        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users");
        UnreadRef = FirebaseDatabase.getInstance().getReference().child("Unread").child(currentUserID);

        UsersRef.child(currentUserID).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                long timestamp = System.currentTimeMillis();
                UsersRef.child(currentUserID).child("online").onDisconnect().setValue(timestamp);
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Unread"))
                    {
                        UsersRef.child(currentUserID).child("Unread").removeValue();
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

    //Initialize and Assign Variable
        BottomNavigationView bottomNavigationView = findViewById(R.id.BottomNavigation);

        //Set Home Selected
        bottomNavigationView.setSelectedItemId(R.id.message);

        //Perform itemSelectedListener
        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem menuItem)
            {
                switch (menuItem.getItemId()) {
                    case R.id.profile:
                        startActivity(new Intent(getApplicationContext(), ProfileActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.home:
                        startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.message:
                        return true;
                    case R.id.zinging:
                        startActivity(new Intent(getApplicationContext(), Zinging.class));
                        overridePendingTransition(0, 0);
                        return true;
                    case R.id.activity:
                        startActivity(new Intent(getApplicationContext(), FriendActivity.class));
                        overridePendingTransition(0, 0);
                        return true;
                }
                return false;
            }
        });


    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        //super.onCreateOptionsMenu(menu);
        getMenuInflater().inflate(R.menu.message_icon, menu);
        return true;
    }



    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item)
    {
        super.onOptionsItemSelected(item);
        switch (item.getItemId())
        {
            case R.id.AddFriend:
                Intent intent = new Intent(this, FriendRequests.class);
                startActivity(intent);
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }

    }

    @Override
    protected void onStart()
    {
        super.onStart();

        UsersRef.child(currentUserID).child("online").setValue("Online");

        Query message = MessageRef.orderByChild("timestamp");
        FirebaseRecyclerOptions options =
                new FirebaseRecyclerOptions.Builder<Message>()
                .setQuery(message, Message.class)
                .build();

        FirebaseRecyclerAdapter<Message, MessageViewHolder> adapter
                = new FirebaseRecyclerAdapter<Message, MessageViewHolder>(options) {
            @Override
            protected void onBindViewHolder(@NonNull MessageViewHolder Holder, int position, @NonNull Message model)
            {
                final String userIDs = getRef(position).getKey();

                TimeAgo getTimeAgoObject = new TimeAgo();

                MessageRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if(snapshot.hasChild("Text"))
                        {
                            String chatmsg = snapshot.child("Text").getValue().toString();
                            Holder.newmessage.setText(chatmsg);
                        }
                        if(snapshot.hasChild("seen"))
                        {
                            if(snapshot.child("seen").getValue().equals(true)) {
                                Holder.newmessage.setTextColor(Color.parseColor("#000000"));
                            }
                        }
                        if(snapshot.hasChild("timestamp"))
                        {
                            String time = snapshot.child("timestamp").getValue().toString();
                            String chattime = getTimeAgoObject.getTimeAgo(Long.parseLong(time), Holder.chatdate.getContext());
                            Holder.chatdate.setText(chattime);
                        }

                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });

                UnreadRef.child(currentUserID).child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot) {
                        if (snapshot.exists()){
                            Holder.unreadmsg.setText(snapshot.getChildrenCount()+ " +");
                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });

                UsersRef.child(userIDs).addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot snapshot)
                    {
                        if(snapshot.exists())
                        {
                            String Username = snapshot.child("username").getValue().toString();
                            Holder.username.setText(Username);


                            if(snapshot.hasChild("profileimage")) {
                                Image = snapshot.child("profileimage").getValue().toString();
                                Picasso.get().load(Image).into(Holder.image);
                            }

                            if(snapshot.hasChild("online")) {
                                String status = snapshot.child("online").getValue().toString();

                                if (status.equals("Online")) {
                                    Holder.username.setTextColor(Color.GREEN);
                                    Holder.Date.setText(status);
                                }else if(status.equals("Texting"))
                                {
                                    Holder.username.setTextColor(Color.GREEN);
                                    Holder.Date.setText("Texting...");
                                }
                                else {
                                    String NotifTime = getTimeAgoObject.getTimeAgo(Long.parseLong(status), Holder.Date.getContext());
                                    Holder.Date.setText(NotifTime);
                                }
                            }

                            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Chats").child(currentUserID).child(userIDs);


                            Holder.itemView.setOnLongClickListener(new View.OnLongClickListener() {
                                @Override
                                public boolean onLongClick(View view)
                                {
                                    String[] options = {"Clear Chat", "Cancel"};

                                    AlertDialog.Builder builder = new AlertDialog.Builder(ChatActivity.this);
                                    builder.setItems(options, new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int i)
                                        {
                                            if(i==0)
                                            {
                                                ref.removeValue();
                                            }
                                            if(i==1)
                                            {
                                                dialog.cancel();
                                            }
                                        }
                                    }).show();

                                    return true;
                                }
                            });

                            Holder.itemView.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v)
                                {
                                    if (snapshot.hasChild("profileimage"))
                                    {
                                        String profimage = snapshot.child("profileimage").getValue().toString();
                                        Picasso.get().load(profimage).into(Holder.image);

                                        Intent intent = new Intent(ChatActivity.this, TextActivity.class);
                                        intent.putExtra("chat", userIDs);
                                        intent.putExtra("chatusername", Username);
                                        intent.putExtra("chatimage", profimage);
                                        startActivity(intent);
                                    }else{
                                    Intent intent = new Intent(ChatActivity.this, TextActivity.class);
                                    intent.putExtra("chat", userIDs);
                                    intent.putExtra("chatusername", Username);
                                    intent.putExtra("chatimage", R.drawable.profile);
                                    startActivity(intent);
                                    }
                                }

                            });
                        }
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {

                    }
                });

            }

            @NonNull
            @Override
            public MessageViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
            {
                View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.chat_list, viewGroup, false);
                MessageViewHolder viewHolder = new MessageViewHolder(view);
                return viewHolder;
            }
        };
        chat_view.setAdapter(adapter);
//        adapter.notifyDataSetChanged();
        adapter.startListening();
    }

    public static class MessageViewHolder extends RecyclerView.ViewHolder
    {
        TextView username, Date, newmessage, chatdate, unreadmsg;
        CircleImageView image;
        public MessageViewHolder(@NonNull View itemView)
        {
            super(itemView);

            username = itemView.findViewById(R.id.SearchUsername);
            image = itemView.findViewById(R.id.SearchUsers);
            Date = itemView.findViewById(R.id.SearchName);
            newmessage = itemView.findViewById(R.id.ChatMessage);
            chatdate = itemView.findViewById(R.id.ChatDate);
            unreadmsg = itemView.findViewById(R.id.Unreadmsg);


        }
    }
}