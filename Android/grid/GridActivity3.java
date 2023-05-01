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

public class GridActivity3 extends AppCompatDialogFragment
{


    private String currentUserID;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, Hobbies;
    private StorageReference UserProfileImageRef;
    private OutputStream outputStream;
    private Button next, back;

    private ImageView grenada, guatemala, guinea, guineabissau, guyana, haiti, honduras, hongkong,
            hungary, iceland, india, indonesia, iran, iraq, ireland, israel, italy, jamaica, japan;

    private ImageView jordan, kazakhstan, kenya, kiribaiti, kuwait, kyrgyzstan, laos, latvia, lebanon, lesotho, liberia, libya, liechtenstein;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_grid3, null);

        builder.setView(view);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserID);
        Hobbies = FirebaseDatabase.getInstance().getReference("Countries");
        UserProfileImageRef = FirebaseStorage.getInstance().getReference().child("hobby");

        grenada = view.findViewById(R.id.Lithuania);
        guatemala = view.findViewById(R.id.Guatemala);
        guinea = view.findViewById(R.id.Guinea);
        guineabissau = view.findViewById(R.id.GuineaBissau);
        guyana = view.findViewById(R.id.Guyana);
        haiti = view.findViewById(R.id.Haiti);
        honduras = view.findViewById(R.id.Honduras);
        hongkong = view.findViewById(R.id.Hongkong);
        hungary = view.findViewById(R.id.Hungary);
        iceland = view.findViewById(R.id.Iceland);
        india = view.findViewById(R.id.India);
        indonesia = view.findViewById(R.id.Indonesia);
        iran = view.findViewById(R.id.Iran);
        iraq = view.findViewById(R.id.Iraq);
        ireland = view.findViewById(R.id.Ireland);
        israel = view.findViewById(R.id.Israel);
        italy = view.findViewById(R.id.Italy);
        jamaica = view.findViewById(R.id.Jamaica);
        japan = view.findViewById(R.id.Japan);
        jordan = view.findViewById(R.id.Jordan);
        kazakhstan = view.findViewById(R.id.Kazakhstan);
        kenya = view.findViewById(R.id.Kenya);
        kiribaiti = view.findViewById(R.id.Kiribati);
        kuwait = view.findViewById(R.id.Kuwait);
        kyrgyzstan = view.findViewById(R.id.Kyrgyzstan);
        laos = view.findViewById(R.id.Laos);
        latvia = view.findViewById(R.id.Latvia);
        lebanon = view.findViewById(R.id.Lebanon);
        lesotho = view.findViewById(R.id.Lesotho);
        liberia = view.findViewById(R.id.Liberia);
        libya = view.findViewById(R.id.Libya);
        liechtenstein = view.findViewById(R.id.Liechtenstein);


        back = view.findViewById(R.id.back_grid);
        next = view.findViewById(R.id.confirm_grid);

        return builder.create();
    }

    @Override
    public void onStart() {
        super.onStart();

        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                back.setVisibility(View.INVISIBLE);
                next.setVisibility(View.INVISIBLE);
                GridActivity4 gridActivity = new GridActivity4();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                back.setVisibility(View.INVISIBLE);
                next.setVisibility(View.INVISIBLE);
                GridActivity2 gridActivity = new GridActivity2();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        Hobbies.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Lithuania")) {
                        String hobby = snapshot.child("Lithuania").getValue().toString();
                        grenada.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Guatemala")) {
                        String hobby = snapshot.child("Guatemala").getValue().toString();
                        guatemala.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Guinea")) {
                        String hobby = snapshot.child("Guinea").getValue().toString();
                        guinea.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }if(snapshot.hasChild("Guinea Bissau")) {
                    String hobby = snapshot.child("Guinea Bissau").getValue().toString();
                    guineabissau.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Guyana")) {
                    String hobby = snapshot.child("Guyana").getValue().toString();
                    guyana.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Haiti")) {
                    String hobby = snapshot.child("Haiti").getValue().toString();
                    haiti.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Honduras")) {
                    String hobby = snapshot.child("Honduras").getValue().toString();
                    honduras.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Hongkong")) {
                    String hobby = snapshot.child("Hongkong").getValue().toString();
                    hongkong.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Hungary")) {
                    String hobby = snapshot.child("Hungary").getValue().toString();
                    hungary.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Iceland")) {
                    String hobby = snapshot.child("Iceland").getValue().toString();
                    iceland.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("India")) {
                    String hobby = snapshot.child("India").getValue().toString();
                    india.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Indonesia")) {
                    String hobby = snapshot.child("Indonesia").getValue().toString();
                    indonesia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Iran")) {
                    String hobby = snapshot.child("Iran").getValue().toString();
                    iran.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Iraq")) {
                    String hobby = snapshot.child("Iraq").getValue().toString();
                    iraq.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Ireland")) {
                    String hobby = snapshot.child("Ireland").getValue().toString();
                    ireland.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Israel")) {
                    String hobby = snapshot.child("Israel").getValue().toString();
                    israel.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Italy")) {
                    String hobby = snapshot.child("Italy").getValue().toString();
                    italy.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Jamaican")) {
                    String hobby = snapshot.child("Jamaican").getValue().toString();
                    jamaica.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Japan")) {
                    String hobby = snapshot.child("Japan").getValue().toString();
                    japan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Jordan")) {
                    String hobby = snapshot.child("Jordan").getValue().toString();
                    jordan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Kazakhstan")) {
                    String hobby = snapshot.child("Kazakhstan").getValue().toString();
                    kazakhstan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Kenya")) {
                    String hobby = snapshot.child("Kenya").getValue().toString();
                    kenya.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Kiribati")) {
                    String hobby = snapshot.child("Kiribati").getValue().toString();
                    kiribaiti.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Kuwait")) {
                    String hobby = snapshot.child("Kuwait").getValue().toString();
                    kuwait.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Kyrgyzstan")) {
                    String hobby = snapshot.child("Kyrgyzstan").getValue().toString();
                    kyrgyzstan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Laos")) {
                    String hobby = snapshot.child("Laos").getValue().toString();
                    laos.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Latvia")) {
                    String hobby = snapshot.child("Latvia").getValue().toString();
                    latvia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Lebanon")) {
                    String hobby = snapshot.child("Lebanon").getValue().toString();
                    lebanon.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Lesotho")) {
                    String hobby = snapshot.child("Lesotho").getValue().toString();
                    lesotho.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Liberia")) {
                    String hobby = snapshot.child("Liberia").getValue().toString();
                    liberia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Liechtenstein")) {
                    String hobby = snapshot.child("Liechtenstein").getValue().toString();
                    liechtenstein.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Libya")) {
                    String hobby = snapshot.child("Libya").getValue().toString();
                    libya.setOnClickListener(new View.OnClickListener() {
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

