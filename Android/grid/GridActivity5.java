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

public class GridActivity5 extends AppCompatDialogFragment
{


    private String currentUserID;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, Hobbies;
    private StorageReference UserProfileImageRef;
    private OutputStream outputStream;
    private Button next, back;

    private ImageView pakistan, palau, palestine, panama, papua_new_guinea, paraguay, peru, phillippines,
            poland, portugal, qatar, romania, russia, rwanda, saint_kitts_and_nevis, saint_lucia, samoa, san_marino, sao_tome_and_principe;

    private ImageView saudi_arabia, serbia, seychelles, sierra_leone, singapore, slovakia, slovenia, solomon_islands, somalia, south_africa, south_korea, south_sudan, spain;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_grid5, null);

        builder.setView(view);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserID);
        Hobbies = FirebaseDatabase.getInstance().getReference("Countries");
        UserProfileImageRef = FirebaseStorage.getInstance().getReference().child("hobby");

        pakistan = view.findViewById(R.id.SriLanka);
        palau = view.findViewById(R.id.Palau);
        palestine = view.findViewById(R.id.Palestine);
        panama = view.findViewById(R.id.Panama);
        papua_new_guinea = view.findViewById(R.id.PapuaNewGuinea);
        paraguay = view.findViewById(R.id.Paraguay);
        peru = view.findViewById(R.id.Peru);
        phillippines = view.findViewById(R.id.Phillippines);
        poland = view.findViewById(R.id.Poland);
        portugal = view.findViewById(R.id.Portugal);
        qatar = view.findViewById(R.id.Qatar);
        romania = view.findViewById(R.id.Romania);
        russia = view.findViewById(R.id.Russia);
        rwanda = view.findViewById(R.id.Rwanda);
        saint_kitts_and_nevis = view.findViewById(R.id.SaintKitssAndNevis);
        saint_lucia = view.findViewById(R.id.SaintLucia);
        samoa = view.findViewById(R.id.Samoa);
        san_marino = view.findViewById(R.id.SanMarino);
        sao_tome_and_principe = view.findViewById(R.id.SaoTomeAndPrincipe);
        saudi_arabia = view.findViewById(R.id.SaudiArabia);
        serbia = view.findViewById(R.id.Serbia);
        seychelles = view.findViewById(R.id.Seychelles);
        sierra_leone = view.findViewById(R.id.SierraLeone);
        singapore = view.findViewById(R.id.Singapore);
        slovakia = view.findViewById(R.id.Slovakia);
        slovenia = view.findViewById(R.id.Slovenia);
        solomon_islands = view.findViewById(R.id.SolomonIslands);
        somalia = view.findViewById(R.id.Somalia);
        south_africa = view.findViewById(R.id.SouthAfrica);
        south_korea = view.findViewById(R.id.SouthKorea);
        south_sudan = view.findViewById(R.id.SouthSudan);
        spain = view.findViewById(R.id.Spain);


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
                GridActivity6 gridActivity = new GridActivity6();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                back.setVisibility(View.INVISIBLE);
                next.setVisibility(View.INVISIBLE);
                GridActivity4 gridActivity = new GridActivity4();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        Hobbies.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Sri Lanka")) {
                        String hobby = snapshot.child("Sri Lanka").getValue().toString();
                        pakistan.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Palau")) {
                        String hobby = snapshot.child("Palau").getValue().toString();
                        palau.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Palestine")) {
                        String hobby = snapshot.child("Palestine").getValue().toString();
                        palestine.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }if(snapshot.hasChild("Panama")) {
                    String hobby = snapshot.child("Panama").getValue().toString();
                    panama.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Papua New Guinea")) {
                    String hobby = snapshot.child("Papua New Guinea").getValue().toString();
                    papua_new_guinea.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Paraguay")) {
                    String hobby = snapshot.child("Paraguay").getValue().toString();
                    paraguay.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Peru")) {
                    String hobby = snapshot.child("Peru").getValue().toString();
                    peru.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Philippines")) {
                    String hobby = snapshot.child("Philippines").getValue().toString();
                    phillippines.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Poland")) {
                    String hobby = snapshot.child("Poland").getValue().toString();
                    poland.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Portugal")) {
                    String hobby = snapshot.child("Portugal").getValue().toString();
                    portugal.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Qatar")) {
                    String hobby = snapshot.child("Qatar").getValue().toString();
                    qatar.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Romania")) {
                    String hobby = snapshot.child("Romania").getValue().toString();
                    romania.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Russia")) {
                    String hobby = snapshot.child("Russia").getValue().toString();
                    russia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Rwanda")) {
                    String hobby = snapshot.child("Rwanda").getValue().toString();
                    rwanda.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Saint Kitts and Nevis")) {
                    String hobby = snapshot.child("Saint Kitts and Nevis").getValue().toString();
                    saint_kitts_and_nevis.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Saint Lucia")) {
                    String hobby = snapshot.child("Saint Lucia").getValue().toString();
                    saint_lucia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Samoa")) {
                    String hobby = snapshot.child("Samoa").getValue().toString();
                    samoa.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("San Marino")) {
                    String hobby = snapshot.child("San Marino").getValue().toString();
                    san_marino.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Sao Tome and Principe")) {
                    String hobby = snapshot.child("Sao Tome and Principe").getValue().toString();
                    sao_tome_and_principe.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Saudi Arabia")) {
                    String hobby = snapshot.child("Saudi Arabia").getValue().toString();
                    saudi_arabia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Serbia")) {
                    String hobby = snapshot.child("Serbia").getValue().toString();
                    serbia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Seychelles")) {
                    String hobby = snapshot.child("Seychelles").getValue().toString();
                    seychelles.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Sierra Leone")) {
                    String hobby = snapshot.child("Sierra Leone").getValue().toString();
                    sierra_leone.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Singapore")) {
                    String hobby = snapshot.child("Singapore").getValue().toString();
                    singapore.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Slovakia")) {
                    String hobby = snapshot.child("Slovakia").getValue().toString();
                    slovakia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Slovenia")) {
                    String hobby = snapshot.child("Slovenia").getValue().toString();
                    slovenia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Solomon Islands")) {
                    String hobby = snapshot.child("Solomon Islands").getValue().toString();
                    solomon_islands.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Somalia")) {
                    String hobby = snapshot.child("Somalia").getValue().toString();
                    somalia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("South Africa")) {
                    String hobby = snapshot.child("South Africa").getValue().toString();
                    south_africa.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("South Korea")) {
                    String hobby = snapshot.child("South Korea").getValue().toString();
                    south_korea.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("South Sudan")) {
                    String hobby = snapshot.child("South Sudan").getValue().toString();
                    south_sudan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Spain")) {
                    String hobby = snapshot.child("Spain").getValue().toString();
                    spain.setOnClickListener(new View.OnClickListener() {
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

