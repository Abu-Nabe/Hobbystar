package com.zinging.hobbystar;

import android.app.Activity;
import android.app.Dialog;
import android.content.ContentResolver;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.Button;
import android.widget.ImageView;
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

import java.util.HashMap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDialogFragment;

public class HomeIconDialog extends AppCompatDialogFragment
{
    private TextView Username, Search;
    private ImageView Postimage;
    private Button Publish;
    private FloatingActionButton cancel;

    private static final int Gallery_Pick = 1;
    private ContentResolver contentResolver;

    private Uri ImageUri;
    String myUri = "";
    StorageTask uploadtask;
    StorageReference mStorageReference;


    private FirebaseAuth mAuth;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.homeicon_dialog, null);

        builder.setView(view);

            Username = view.findViewById(R.id.Home_Username);
            Publish = view.findViewById(R.id.Home_publish);
            Search = view.findViewById(R.id.Home_Username);
            Postimage = view.findViewById(R.id.post_image1);
            cancel = view.findViewById(R.id.CancelPic);

            mStorageReference = FirebaseStorage.getInstance().getReference("posts");


        Search.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v)
            {
                Sendtosearch();
            }
        });

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
              getActivity().finish();
            }
        });

        Postimage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectpost();
            }
        });

        Publish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                uploadimage();
            }
        });


        return builder.create();



    }

    private String getFileExtension(Uri uri)
    {
        ContentResolver contentResolver = getActivity().getContentResolver();
        MimeTypeMap mime = MimeTypeMap.getSingleton();
        return mime.getExtensionFromMimeType(contentResolver.getType(uri));
    }

    private void uploadimage()
    {
        ProgressDialog progressDialog = new ProgressDialog(getContext());
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

                        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Posts");


                        String postid = reference.push().getKey();
                        long timestamp = System.currentTimeMillis();
                        String timestring = String.valueOf(System.currentTimeMillis());


                        DatabaseReference countref = FirebaseDatabase.getInstance().getReference("Users").child(FirebaseAuth.getInstance().getCurrentUser().getUid());
                        countref.child("post").child(timestring).setValue(true);


                        HashMap<String, Object> hashMap = new HashMap<>();
                        hashMap.put("postid", postid);
                        hashMap.put("postimage", myUri);
                        hashMap.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                        hashMap.put("timestamp", timestamp);
                        hashMap.put("timestring", timestring);


                        reference.child(timestring).setValue(hashMap);

                        HashMap<String, Object> notifMap = new HashMap<>();
                        notifMap.put("description", "Has a new post!");
                        notifMap.put("publisher", FirebaseAuth.getInstance().getCurrentUser().getUid());
                        notifMap.put("post", myUri);
                        notifMap.put("timestamp", timestamp);
                        notifMap.put("timestring", timestring);
                        notifMap.put("posttype", "Post");

                        DatabaseReference notifref = FirebaseDatabase.getInstance().getReference("PostNotifications").child(timestring);
                        notifref.setValue(notifMap);

                        DatabaseReference feedref = FirebaseDatabase.getInstance().getReference("feed").child(FirebaseAuth.getInstance().getCurrentUser().getUid()).child("posts");

                        feedref.child(timestring).setValue(true);

                        progressDialog.dismiss();

                        SendtoLoginActivity();


                    }else {
                        Toast.makeText(getContext(), "failed", Toast.LENGTH_SHORT).show();
                    }
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    Toast.makeText(getContext(), ""+ e.getMessage(), Toast.LENGTH_SHORT).show();
                }
            });

        }else{
            Toast.makeText(getContext(), "no image selected", Toast.LENGTH_SHORT).show();
        }
    }

    private void SendtoLoginActivity()
    {
        Intent intent = new Intent(getContext(), HomeActivity.class);
        startActivity(intent);
    }

    private void selectpost()
    {
        Intent galleryIntent = new Intent();
        galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
        galleryIntent.setType("image/*");
        startActivityForResult(galleryIntent, Gallery_Pick);
    }

    private void Sendtosearch()
    {
        Intent mainIntent = new Intent(getContext(), Search.class);
        startActivity(mainIntent);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode==Gallery_Pick && resultCode==Activity.RESULT_OK && data!=null)
        {
            ImageUri = data.getData();
            Postimage.setImageURI(ImageUri);
        }else
        {
            Toast.makeText(getContext(), "Error occured", Toast.LENGTH_SHORT).show();
        }
    }
}




