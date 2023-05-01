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

public class GridActivity4 extends AppCompatDialogFragment
{


    private String currentUserID;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, Hobbies;
    private StorageReference UserProfileImageRef;
    private OutputStream outputStream;
    private Button next, back;

    private ImageView lithuania, luxembourg, madagascar, malawi, malaysia, maldives, mali, malta,
            marshallislands, mauritania, mexico, micronesia, moldova, monaco, montenegro, mongolia, morocco, mozambique, myanmar;

    private ImageView namibia, nauru, nepal, netherlands, newzealand, nicaragua, niger, nigeria, northkorea, northmacedonia, norway, oman, mauritius;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_grid4, null);

        builder.setView(view);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserID);
        Hobbies = FirebaseDatabase.getInstance().getReference("Countries");
        UserProfileImageRef = FirebaseStorage.getInstance().getReference().child("hobby");

        lithuania = view.findViewById(R.id.Lithuania);
        luxembourg = view.findViewById(R.id.Luxembourg);
        madagascar = view.findViewById(R.id.Madagascar);
        malawi = view.findViewById(R.id.Malawi);
        malaysia = view.findViewById(R.id.Malaysia);
        maldives = view.findViewById(R.id.Maldives);
        mali = view.findViewById(R.id.Mali);
        malta = view.findViewById(R.id.Malta);
        marshallislands = view.findViewById(R.id.MarshallIslands);
        mauritania = view.findViewById(R.id.Mauritania);
        mexico = view.findViewById(R.id.Mexico);
        micronesia = view.findViewById(R.id.Micronesia);
        moldova = view.findViewById(R.id.Moldova);
        monaco = view.findViewById(R.id.Monaco);
        montenegro = view.findViewById(R.id.Montenegro);
        mongolia = view.findViewById(R.id.Mongolia);
        morocco = view.findViewById(R.id.Morocco);
        mozambique = view.findViewById(R.id.Mozambique);
        myanmar = view.findViewById(R.id.Myanmar);
        namibia = view.findViewById(R.id.Namibia);
        nauru = view.findViewById(R.id.Nauru);
        nepal = view.findViewById(R.id.Nepal);
        netherlands = view.findViewById(R.id.Netherlands);
        newzealand = view.findViewById(R.id.NewZealand);
        nicaragua = view.findViewById(R.id.Nicaragua);
        niger = view.findViewById(R.id.Niger);
        nigeria = view.findViewById(R.id.Nigeria);
        northkorea = view.findViewById(R.id.NorthKorea);
        northmacedonia = view.findViewById(R.id.NorthMacedonia);
        norway = view.findViewById(R.id.Norway);
        oman = view.findViewById(R.id.Oman);
        mauritius = view.findViewById(R.id.Mauritius);


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
                GridActivity5 gridActivity = new GridActivity5();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                back.setVisibility(View.INVISIBLE);
                next.setVisibility(View.INVISIBLE);
                GridActivity3 gridActivity = new GridActivity3();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        Hobbies.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Pakistan")) {
                        String hobby = snapshot.child("Pakistan").getValue().toString();
                        lithuania.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Luxembourg")) {
                        String hobby = snapshot.child("Luxembourg").getValue().toString();
                        luxembourg.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Madagascar")) {
                        String hobby = snapshot.child("Madagascar").getValue().toString();
                        madagascar.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }if(snapshot.hasChild("Malawi")) {
                    String hobby = snapshot.child("Malawi").getValue().toString();
                    malawi.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Malaysia")) {
                    String hobby = snapshot.child("Malaysia").getValue().toString();
                    malaysia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Maldives")) {
                    String hobby = snapshot.child("Maldives").getValue().toString();
                    maldives.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Mali")) {
                    String hobby = snapshot.child("Mali").getValue().toString();
                    mali.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Malta")) {
                    String hobby = snapshot.child("Malta").getValue().toString();
                    malta.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Marshall Islands")) {
                    String hobby = snapshot.child("Marshall Islands").getValue().toString();
                    marshallislands.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Mauritania")) {
                    String hobby = snapshot.child("Mauritania").getValue().toString();
                    mauritania.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Mauritius")) {
                    String hobby = snapshot.child("Mauritius").getValue().toString();
                    mauritius.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Mexico")) {
                    String hobby = snapshot.child("Mexico").getValue().toString();
                    mexico.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Micronesia")) {
                    String hobby = snapshot.child("Micronesia").getValue().toString();
                    micronesia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Moldova")) {
                    String hobby = snapshot.child("Moldova").getValue().toString();
                    moldova.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Monaco")) {
                    String hobby = snapshot.child("Monaco").getValue().toString();
                    monaco.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Mongolia")) {
                    String hobby = snapshot.child("Mongolia").getValue().toString();
                    mongolia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Montenegro")) {
                    String hobby = snapshot.child("Montenegro").getValue().toString();
                    montenegro.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Morocco")) {
                    String hobby = snapshot.child("Morocco").getValue().toString();
                    morocco.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Mozambique")) {
                    String hobby = snapshot.child("Mozambique").getValue().toString();
                    mozambique.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Namibia")) {
                    String hobby = snapshot.child("Namibia").getValue().toString();
                    namibia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Nauru")) {
                    String hobby = snapshot.child("Nauru").getValue().toString();
                    nauru.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Nepal")) {
                    String hobby = snapshot.child("Nepal").getValue().toString();
                    nepal.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Netherlands")) {
                    String hobby = snapshot.child("Netherlands").getValue().toString();
                    netherlands.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("New Zealand")) {
                    String hobby = snapshot.child("New Zealand").getValue().toString();
                    newzealand.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Nicaragua")) {
                    String hobby = snapshot.child("Nicaragua").getValue().toString();
                    nicaragua.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Niger")) {
                    String hobby = snapshot.child("Niger").getValue().toString();
                    niger.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Nigeria")) {
                    String hobby = snapshot.child("Nigeria").getValue().toString();
                    nigeria.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("North Korea")) {
                    String hobby = snapshot.child("North Korea").getValue().toString();
                    northkorea.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("North Macedonia")) {
                    String hobby = snapshot.child("North Macedonia").getValue().toString();
                    northmacedonia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Norway")) {
                    String hobby = snapshot.child("Norway").getValue().toString();
                    norway.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Oman")) {
                    String hobby = snapshot.child("Oman").getValue().toString();
                    oman.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Myanmar")) {
                    String hobby = snapshot.child("Myanmar").getValue().toString();
                    myanmar.setOnClickListener(new View.OnClickListener() {
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

