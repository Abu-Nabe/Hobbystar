package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;


import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Spinner;
import android.widget.TextView;
import android.app.ProgressDialog;
import android.widget.Toast;

import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.StorageTask;

import com.squareup.picasso.Picasso;

import java.util.HashMap;

public class UploadPics extends AppCompatActivity
{

    private TextView Pictitle, fillText;
    private ImageView Picimage, fillImage;
    private Button UploadPic;
    private Spinner spinner;

    private static final int Gallery_Pick = 1;
    private Uri ImageUri;
    String myUri = "";
    StorageTask uploadtask;
    StorageReference mStorageReference;

    private FloatingActionButton floatingActionButton, cancel;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_upload_pics);

        Pictitle = (TextView) findViewById(R.id.PicTitle);
        Picimage = (ImageView) findViewById(R.id.PicView);
        UploadPic = (Button) findViewById(R.id.UploadPic);
        fillText = findViewById(R.id.fill_text);
        fillImage = findViewById(R.id.fill_image);

        floatingActionButton = (FloatingActionButton) findViewById(R.id.PickPic);

        mStorageReference = FirebaseStorage.getInstance().getReference("posts");

        cancel = (FloatingActionButton) findViewById(R.id.CancelPic);

        spinner = findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> arrayAdapter = ArrayAdapter
                .createFromResource(this, R.array.Hobbies, android.R.layout.simple_spinner_item);
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(arrayAdapter);

        floatingActionButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectpic();
            }
        });

        UploadPic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Upload();
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    private void Upload()
    {
        ProgressDialog progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Posting");
        progressDialog.show();
        
        if(ImageUri != null)
        {

            StorageReference filereference = mStorageReference.child(System.currentTimeMillis() +
                    "," + getFileExtension(ImageUri));

            uploadtask = filereference.putFile(ImageUri);
            uploadtask.continueWithTask(new Continuation() {
                @Override
                public Object then(@NonNull Task task) throws Exception
                {
                    if(!task.isComplete())
                    {
                        throw task.getException();
                    }
                    return filereference.getDownloadUrl();
                }
            }).addOnCompleteListener(new OnCompleteListener<Uri>() {
                @Override
                public void onComplete(@NonNull Task<Uri> task) {
                    if(task.isSuccessful())
                    {
                        Uri downloaduri = task.getResult();
                        myUri = downloaduri.toString();

                        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Pics");
                        DatabaseReference reference1 = FirebaseDatabase.getInstance().getReference("HobbyPic");

                        String postid = reference.push().getKey();

                        Long timestamp = System.currentTimeMillis();
                        String timestring = String.valueOf(System.currentTimeMillis());

                        HashMap<String, Object> hashMap = new HashMap<>();
                        hashMap.put("picid", postid);
                        hashMap.put("description", Pictitle.getText().toString());
                        hashMap.put("picimage", myUri);
                        hashMap.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                        hashMap.put("hobby", spinner.getSelectedItem().toString());
                        hashMap.put("timestamp", timestamp);
                        hashMap.put("timestring", timestring);


                        reference.child(timestring).setValue(hashMap);

                        reference1.child(spinner.getSelectedItem().toString()).child(timestring).setValue(hashMap);

                        DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users").child(FirebaseAuth.getInstance().getCurrentUser().getUid());

                        ref.child("zingingpost").child(timestring).setValue(true);

                        HashMap<String, Object> notifMap = new HashMap<>();
                        notifMap.put("description", "Has a new post!");
                        notifMap.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                        notifMap.put("post", myUri);
                        notifMap.put("timestamp", timestamp);
                        notifMap.put("timestring", timestring);
                        notifMap.put("posttype", "ZingingPost");

                        DatabaseReference notifref = FirebaseDatabase.getInstance().getReference("PostNotifications").child(timestring);
                        notifref.setValue(notifMap);

                        HashMap<String, Object> hashMap1 = new HashMap<>();
                        hashMap1.put("description", Pictitle.getText().toString());
                        hashMap1.put("postimage", myUri);
                        hashMap1.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                        hashMap1.put("hobby", spinner.getSelectedItem().toString());
                        hashMap1.put("timestamp", timestamp);
                        hashMap1.put("timestring", timestring);

                        DatabaseReference zingref = FirebaseDatabase.getInstance().getReference("ZingingPosts");
                        zingref.child(timestring).setValue(hashMap1);


                        reference.child(timestring).setValue(hashMap);

                        progressDialog.dismiss();

                        SendtoLoginActivity();


                    }else {
                        Toast.makeText(getApplicationContext(), "failed", Toast.LENGTH_SHORT).show();
                    }
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    Toast.makeText(getApplicationContext(), ""+ e.getMessage(), Toast.LENGTH_SHORT).show();
                }
            });

        }else{
            Toast.makeText(getApplicationContext(), "no image selected", Toast.LENGTH_SHORT).show();
        }
    }

    private void SendtoLoginActivity()
    {
        Intent intent = new Intent(UploadPics.this, Zinging.class);
        startActivity(intent);
    }

    private String getFileExtension(Uri uri)
    {
        ContentResolver contentResolver = getContentResolver();
        MimeTypeMap mime = MimeTypeMap.getSingleton();
        return mime.getExtensionFromMimeType(contentResolver.getType(uri));
    }

    private void selectpic()
    {
        Intent galleryIntent = new Intent();
        galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
        galleryIntent.setType("image/*");
        startActivityForResult(galleryIntent, Gallery_Pick);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode==Gallery_Pick && resultCode== Activity.RESULT_OK && data!=null)
        {
            ImageUri = data.getData();
            Picasso.get().load(ImageUri).fit().centerCrop().into(Picimage);

            fillImage.setVisibility(View.INVISIBLE);
            fillText.setVisibility(View.INVISIBLE);
        }else
        {
            Toast.makeText(getApplicationContext(), "Error occured", Toast.LENGTH_SHORT).show();
        }
    }
}