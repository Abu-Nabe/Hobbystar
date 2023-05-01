package com.zinging.hobbystar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentResolver;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.StorageTask;

import java.util.HashMap;

public class BugSettings extends AppCompatActivity
{
    private EditText typebug;
    private ImageView ImageBug;
    private Button confirmbug;

    private static final int Gallery_Pick = 1;
    private ContentResolver contentResolver;

    private Uri ImageUri;
    String myUri = "";
    StorageTask uploadtask;
    StorageReference mStorageReference;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bug_settings);

        typebug = (EditText) findViewById(R.id.editbug);
        ImageBug = (ImageView) findViewById(R.id.imagebug);
        confirmbug = (Button) findViewById(R.id.confirm_bug);

        mStorageReference = FirebaseStorage.getInstance().getReference("bugs");


        typebug.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                typebug.setText("");
            }
        });

        confirmbug.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Save();
            }
        });

        ImageBug.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AddImage();
            }
        });
    }

    private void AddImage()
    {
        Intent galleryIntent = new Intent();
        galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
        galleryIntent.setType("image/*");
        startActivityForResult(galleryIntent, Gallery_Pick);
    }

    private String getFileExtension(Uri uri)
    {
        ContentResolver contentResolver = getContentResolver();
        MimeTypeMap mime = MimeTypeMap.getSingleton();
        return mime.getExtensionFromMimeType(contentResolver.getType(uri));
    }



    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode==Gallery_Pick && resultCode== Activity.RESULT_OK && data!=null)
        {
            ImageUri = data.getData();
            ImageBug.setImageURI(ImageUri);
        }else
        {
            Toast.makeText(getApplicationContext(), "Error occured", Toast.LENGTH_SHORT).show();
        }
    }

    private void Save()
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

                        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Bugs");

                        String postid = reference.push().getKey();

                        HashMap<String, Object> hashMap = new HashMap<>();
                        hashMap.put("bugimage", myUri);
                        hashMap.put("bugtype", typebug.getText().toString());
                        hashMap.put("UserID", FirebaseAuth.getInstance().getCurrentUser().getUid());


                        reference.child(postid).setValue(hashMap).addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull Task<Void> task) {
                                progressDialog.dismiss();
                                Intent intent = new Intent(BugSettings.this, ProfileActivity.class);
                                startActivity(intent);
                            }
                        });


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

        } else if(typebug.equals("Description of Bug")){
        Intent intent = new Intent(BugSettings.this, ProfileActivity.class);
        startActivity(intent);
    }else {
        String Bug = typebug.getText().toString();

        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Bugs");
        String postid = reference.push().getKey();

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("bugimage", Bug);

        reference.child(postid).setValue(hashMap).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                Intent intent = new Intent(BugSettings.this, ProfileActivity.class);
                startActivity(intent);
            }
        });
      }
    }
}



