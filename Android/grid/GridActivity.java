package com.zinging.hobbystar.grid;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDialogFragment;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.zinging.hobbystar.ProfileActivity;
import com.zinging.hobbystar.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;

import java.io.OutputStream;
import java.util.HashMap;

public class GridActivity extends AppCompatDialogFragment
{


    private String currentUserID;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, Hobbies;
    private StorageReference UserProfileImageRef;
    private OutputStream outputStream;
    private Button next;
    private ProgressBar progressBar;

    private ImageView Anime, Artist, Basketball, andorra, angola, antigua, argentina, armenia,
    australia, austria, azerbaijan, bahamas, bahrain, barbados, bangladesh, belarus, belgium, belize, benin,
    bhutan, bolivia, bosnia, botswana, brazil, brunei, bulgaria, burkina, burundi, cabo, cambodia, cameroon, canada;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_grid, null);

        builder.setView(view);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserID);
        Hobbies = FirebaseDatabase.getInstance().getReference("Countries");
        UserProfileImageRef = FirebaseStorage.getInstance().getReference().child("hobby");

        progressBar = view.findViewById(R.id.ProgressBar);

        Anime = view.findViewById(R.id.anime);
        Artist = view.findViewById(R.id.artist);
        Basketball = view.findViewById(R.id.basketball);
        belarus = view.findViewById(R.id.Belarus);
        botswana = view.findViewById(R.id.Botswana);
        brazil = view.findViewById(R.id.Brazil);
        brunei = view.findViewById(R.id.Brunei);
        bulgaria = view.findViewById(R.id.Bulgaria);
        burkina = view.findViewById(R.id.Burkina_Faso);
        burundi = view.findViewById(R.id.Burundi);
        cabo = view.findViewById(R.id.Cabo_Verde);
        cambodia = view.findViewById(R.id.Cambodia);
        cameroon = view.findViewById(R.id.Cameroon);
        canada = view.findViewById(R.id.Canada);
        bhutan = view.findViewById(R.id.Bhutan);
        bolivia = view.findViewById(R.id.Bolivia);
        bosnia = view.findViewById(R.id.Bosnia);
        belgium = view.findViewById(R.id.Belgium);
        belize = view.findViewById(R.id.Belize);
        benin = view.findViewById(R.id.Benin);
        andorra = view.findViewById(R.id.Andorra);
        angola = view.findViewById(R.id.Angola);
        antigua = view.findViewById(R.id.Antigua);
        argentina = view.findViewById(R.id.Argentina);
        armenia = view.findViewById(R.id.Armenia);
        australia = view.findViewById(R.id.Australia);
        austria = view.findViewById(R.id.Austria);
        azerbaijan = view.findViewById(R.id.Azerbaijan);
        bahamas = view.findViewById(R.id.Bahamas);
        bahrain = view.findViewById(R.id.Bahrain);
        barbados = view.findViewById(R.id.Barbados);
        bangladesh = view.findViewById(R.id.Bangladesh);

        next = view.findViewById(R.id.confirm_grid);

        return builder.create();
    }

    @Override
    public void onStart() {
        super.onStart();

        next.setVisibility(View.INVISIBLE);

        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                next.setVisibility(View.INVISIBLE);
                GridActivity2 gridActivity2 = new GridActivity2();
                gridActivity2.show(getParentFragmentManager(), "fuck");
            }
        });

        Hobbies.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Afghanistan")) {
                        String hobby = snapshot.child("Afghanistan").getValue().toString();
                        Anime.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Albania")) {
                        String hobby = snapshot.child("Albania").getValue().toString();
                        Artist.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Algeria")) {
                        String hobby = snapshot.child("Algeria").getValue().toString();
                        Basketball.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }if(snapshot.hasChild("Andorra")) {
                    String hobby = snapshot.child("Andorra").getValue().toString();
                    andorra.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Angola")) {
                    String hobby = snapshot.child("Angola").getValue().toString();
                    angola.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Antigua and Barbuda")) {
                    String hobby = snapshot.child("Antigua and Barbuda").getValue().toString();
                    antigua.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Argentina")) {
                    String hobby = snapshot.child("Argentina").getValue().toString();
                    argentina.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Armenia")) {
                    String hobby = snapshot.child("Armenia").getValue().toString();
                    armenia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Australia")) {
                    String hobby = snapshot.child("Australia").getValue().toString();
                    australia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Austria")) {
                    String hobby = snapshot.child("Austria").getValue().toString();
                    austria.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Azerbaijan")) {
                    String hobby = snapshot.child("Azerbaijan").getValue().toString();
                    azerbaijan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bahamas")) {
                    String hobby = snapshot.child("Bahamas").getValue().toString();
                    bahamas.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bahrain")) {
                    String hobby = snapshot.child("Bahrain").getValue().toString();
                    bahrain.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bangladesh")) {
                    String hobby = snapshot.child("Bangladesh").getValue().toString();
                    bangladesh.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Barbados")) {
                    String hobby = snapshot.child("Barbados").getValue().toString();
                    barbados.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Belarus")) {
                    String hobby = snapshot.child("Belarus").getValue().toString();
                    belarus.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Belgium")) {
                    String hobby = snapshot.child("Belgium").getValue().toString();
                    belgium.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Belize")) {
                    String hobby = snapshot.child("Belize").getValue().toString();
                    belize.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Benin")) {
                    String hobby = snapshot.child("Benin").getValue().toString();
                    benin.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bhutan")) {
                    String hobby = snapshot.child("Bhutan").getValue().toString();
                    bhutan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bolivia")) {
                    String hobby = snapshot.child("Bolivia").getValue().toString();
                    bolivia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bosnia and Herzegovinia")) {
                    String hobby = snapshot.child("Bosnia and Herzegovinia").getValue().toString();
                    bosnia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Botswana")) {
                    String hobby = snapshot.child("Botswana").getValue().toString();
                    botswana.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Brazil")) {
                    String hobby = snapshot.child("Brazil").getValue().toString();
                    brazil.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Brunei")) {
                    String hobby = snapshot.child("Brunei").getValue().toString();
                    brunei.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Bulgaria")) {
                    String hobby = snapshot.child("Bulgaria").getValue().toString();
                    bulgaria.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Burkina Faso")) {
                    String hobby = snapshot.child("Burkina Faso").getValue().toString();
                    burkina.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Burundi")) {
                    String hobby = snapshot.child("Burundi").getValue().toString();
                    burundi.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Cabo Verde")) {
                    String hobby = snapshot.child("Cabo Verde").getValue().toString();
                    cabo.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Cambodia")) {
                    String hobby = snapshot.child("Cambodia").getValue().toString();
                    cambodia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Cameroon")) {
                    String hobby = snapshot.child("Cameroon").getValue().toString();
                    cameroon.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Canada")) {
                    String hobby = snapshot.child("Canada").getValue().toString();
                    canada.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        next.setVisibility(View.VISIBLE);

        progressBar.setVisibility(View.INVISIBLE);
    }

    private void SaveToProfile(String hobby)
    {
        String user_id = mAuth.getCurrentUser().getUid();
        DatabaseReference current_user_db = FirebaseDatabase.getInstance().getReference().child("Users").child(user_id);

        HashMap userMap = new HashMap();
        userMap.put("hobby", hobby);

        current_user_db.updateChildren(userMap).addOnCompleteListener(new OnCompleteListener() {
            @Override
            public void onComplete(@NonNull Task task) {
                Intent intent = new Intent(getActivity(), ProfileActivity.class);
                startActivity(intent);
            }
        });
    }
}

