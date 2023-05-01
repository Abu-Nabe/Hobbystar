package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import com.zinging.hobbystar.Model.ZingingModel;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.util.HashMap;

public class UploadVids extends AppCompatActivity
{
    private EditText VideoDescription;
    private VideoView videoView;
    private Button UploadVideoButton;
    private Spinner spinner;
    private FloatingActionButton PickVideo, cancel;
    private ProgressBar progressBar;
    private ZingingModel member;
    private TextView fillText;
    private ImageView fillImage;

    private static final int VIDEO_PICK_GALLERY_CODE=100;
//    private static final int VIDEO_PICK_CAMERA_CODE=101;

    private DatabaseReference databaseReference, videoref;
    private StorageReference storageReference;

    private Uri videourl;
    private UploadTask uploadTask;

    private String title;

    private ProgressDialog progressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.zingingposts);

        VideoDescription = (EditText) findViewById(R.id.VideoTitle);
        videoView = (VideoView) findViewById(R.id.VideoView);
        UploadVideoButton = (Button) findViewById(R.id.UploadVideo);
        fillText = findViewById(R.id.fill_text);
        fillImage = findViewById(R.id.fill_image);

        storageReference = FirebaseStorage.getInstance().getReference("videos");
        databaseReference = FirebaseDatabase.getInstance().getReference("Videos");
        videoref = FirebaseDatabase.getInstance().getReference("UserVideos");

        progressDialog = new ProgressDialog(this);
        progressDialog.setTitle("Please wait");
        progressDialog.setMessage("Uploading Video");
        progressDialog.setCanceledOnTouchOutside(false);

        PickVideo = (FloatingActionButton) findViewById(R.id.PicVid);
        cancel = (FloatingActionButton) findViewById(R.id.CancelPic);

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        UploadVideoButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                    UploadVideo();
            }
        });

        PickVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                VideoPickDialog();
            }
        });

        spinner = findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> arrayAdapter = ArrayAdapter
                .createFromResource(this, R.array.Hobbies, android.R.layout.simple_spinner_item);
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(arrayAdapter);
    }

    private void UploadVideo()
    {
       if(videourl != null)
       {
           progressDialog.show();
           final StorageReference reference = storageReference.child(System.currentTimeMillis() + "." + getFileExit(videourl));
           uploadTask = reference.putFile(videourl);

           Task<Uri> uriTask = uploadTask.continueWithTask(new Continuation<UploadTask.TaskSnapshot, Task<Uri>>() {
               @Override
               public Task<Uri> then(@NonNull Task<UploadTask.TaskSnapshot> task) throws Exception
               {
                   if(!task.isSuccessful())
                   {
                       throw task.getException();
                   }
                   return reference.getDownloadUrl();
               }
           }).addOnCompleteListener(new OnCompleteListener<Uri>() {
               @Override
               public void onComplete(@NonNull Task<Uri> task) {
                   if(task.isSuccessful()) {

                       Uri downloadUrl = task.getResult();
                       String currentuser = FirebaseAuth.getInstance().getCurrentUser().getUid();
                       String upload = databaseReference.push().getKey();

                       String text = spinner.getSelectedItem().toString();
                       long timestamp = System.currentTimeMillis();
                       String timestring = String.valueOf(System.currentTimeMillis());

                       Toast.makeText(UploadVids.this, "Upload Successful", Toast.LENGTH_SHORT).show();
                       member = new ZingingModel(VideoDescription.getText().toString().trim(),
                               downloadUrl.toString(), currentuser, upload, text, timestring, timestamp);

                       DatabaseReference reference1 = FirebaseDatabase.getInstance().getReference("HobbyVid");

                       reference1.child(text).child(timestring).setValue(member);

                       DatabaseReference ref = FirebaseDatabase.getInstance().getReference("Users").child(FirebaseAuth.getInstance().getCurrentUser().getUid());

                       ref.child("videos").child(timestring).setValue(true);

                       HashMap<String, Object> notifMap = new HashMap<>();
                       notifMap.put("description", "Has a new post!");
                       notifMap.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                       notifMap.put("post", downloadUrl.toString());
                       notifMap.put("timestamp", timestamp);
                       notifMap.put("timestring", timestring);
                       notifMap.put("posttype", "ZingingVideo");

                       DatabaseReference notifref = FirebaseDatabase.getInstance().getReference("PostNotifications").child(timestring);
                       notifref.setValue(notifMap);


                       HashMap<String, Object> hashMap1 = new HashMap<>();
                       hashMap1.put("description", VideoDescription.getText().toString());
                       hashMap1.put("postimage", downloadUrl.toString());
                       hashMap1.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                       hashMap1.put("hobby", spinner.getSelectedItem().toString());
                       hashMap1.put("timestamp", timestamp);
                       hashMap1.put("timestring", timestring);

                       DatabaseReference zingref = FirebaseDatabase.getInstance().getReference("ZingingPosts");
                       zingref.child(timestring).setValue(hashMap1);

                       DatabaseReference ref1 = FirebaseDatabase.getInstance().getReference("Users").child(FirebaseAuth.getInstance().getCurrentUser().getUid());

                       ref1.child("zingingvid").child(timestring).setValue(true);

                       databaseReference.child(timestring).setValue(member).addOnSuccessListener(new OnSuccessListener<Void>() {
                           @Override
                           public void onSuccess(Void aVoid) {
                               SendToZingingActivity();
                               progressDialog.dismiss();
                           }
                       });

                   }
               }
           });
       }else
       {
           Toast.makeText(this, "Choose a video", Toast.LENGTH_SHORT).show();
       }
    }

    private void SendToZingingActivity()
    {
        Intent intent = new Intent(UploadVids.this, Zinging.class);
        startActivity(intent);
    }

    private void VideoPickDialog()
    {
        videoPickGallery();
    }

    private String getFileExit(Uri videourl)
    {
        ContentResolver contentResolver = getContentResolver();
        MimeTypeMap mimeTypeMap = MimeTypeMap.getSingleton();
        return mimeTypeMap.getExtensionFromMimeType(contentResolver.getType(videourl));
    }

//    private boolean checkCameraPermission()
//    {
//        boolean result1 = ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED;
//        boolean result2 = ContextCompat.checkSelfPermission(this, Manifest.permission.WAKE_LOCK) == PackageManager.PERMISSION_GRANTED;
//
//        return result1 && result2;
//    }

    private void videoPickGallery()
    {
        Intent intent = new Intent();
        intent.setType("video/+");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select Videos"), VIDEO_PICK_GALLERY_CODE);
    }

    private void videoPickCamera()
    {
        Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
//        startActivityForResult(intent, VIDEO_PICK_CAMERA_CODE);
    }

    private void SetVideo()
    {
        MediaController mediaController = new MediaController(this);
        mediaController.setAnchorView(videoView);

        videoView.setMediaController(mediaController);
        videoView.setVideoURI(videourl);
        videoView.requestFocus();
        videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp)
            {
                videoView.pause();
            }
        });
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data)
    {
        if(resultCode == RESULT_OK)
        {
            if(requestCode == VIDEO_PICK_GALLERY_CODE)
            {
                videourl = data.getData();

                SetVideo();

                fillImage.setVisibility(View.INVISIBLE);
                fillText.setVisibility(View.INVISIBLE);
            }
//            else if(requestCode == VIDEO_PICK_CAMERA_CODE)
//            {
//                videourl = data.getData();
//
//
//                fillImage.setVisibility(View.INVISIBLE);
//                fillText.setVisibility(View.INVISIBLE);
//                SetVideo();
//            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }
}