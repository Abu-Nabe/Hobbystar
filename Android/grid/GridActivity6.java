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

public class GridActivity6 extends AppCompatDialogFragment
{


    private String currentUserID;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, Hobbies;
    private StorageReference UserProfileImageRef;
    private OutputStream outputStream;
    private Button back;

    private ImageView sri_lanka, st_vincent_grenadines, sudan, suriname, sweden, switzerland, syria, taiwan,
            tajikistan, tanzania, thailand, timor_leste, trinidad_and_tobago ,togo, tonga, tunisia, turkey, turkmenistan, tuvalu, uganda;

    private ImageView ukraine, united_arab_emirates, united_kingdom, united_states, uruguay, uzbekistan, vanuatu, vatican_city, venezuela, vietnam, yemen, zambia, zimbabwe;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_grid6, null);

        builder.setView(view);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserID);
        Hobbies = FirebaseDatabase.getInstance().getReference("Countries");
        UserProfileImageRef = FirebaseStorage.getInstance().getReference().child("hobby");

        sri_lanka = view.findViewById(R.id.SriLanka);
        st_vincent_grenadines = view.findViewById(R.id.StVincentGrenadines);
        sudan = view.findViewById(R.id.Sudan);
        suriname = view.findViewById(R.id.Suriname);
        sweden = view.findViewById(R.id.Sweden);
        switzerland = view.findViewById(R.id.Switzerland);
        syria = view.findViewById(R.id.Syria);
        taiwan = view.findViewById(R.id.Taiwan);
        tajikistan = view.findViewById(R.id.Tajikistan);
        tanzania = view.findViewById(R.id.Tanzania);
        thailand = view.findViewById(R.id.Thailand);
        timor_leste = view.findViewById(R.id.TimorLeste);
        trinidad_and_tobago = view.findViewById(R.id.TrinidadAndTobago);
        togo = view.findViewById(R.id.Togo);
        tonga = view.findViewById(R.id.Tonga);
        tunisia = view.findViewById(R.id.Tunisia);
        turkey = view.findViewById(R.id.Turkey);
        turkmenistan = view.findViewById(R.id.Turkmenistan);
        tuvalu = view.findViewById(R.id.Tuvalu);
        uganda = view.findViewById(R.id.Uganda);
        ukraine = view.findViewById(R.id.Ukraine);
        united_arab_emirates = view.findViewById(R.id.UnitedArabEmirates);
        united_kingdom = view.findViewById(R.id.UnitedKingdom);
        united_states = view.findViewById(R.id.UnitedStates);
        uruguay = view.findViewById(R.id.Uruguay);
        uzbekistan = view.findViewById(R.id.Uzbekistan);
        vanuatu = view.findViewById(R.id.Vanuatu);
        vatican_city = view.findViewById(R.id.VaticanCity);
        venezuela = view.findViewById(R.id.Venezuela);
        vietnam = view.findViewById(R.id.Vietnam);
        yemen = view.findViewById(R.id.Yemen);
        zambia = view.findViewById(R.id.Zambia);
        zimbabwe = view.findViewById(R.id.Zimbabwe);


        back = view.findViewById(R.id.back_grid);

        return builder.create();
    }

    @Override
    public void onStart() {
        super.onStart();

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                back.setVisibility(View.INVISIBLE);
                GridActivity5 gridActivity = new GridActivity5();
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
                        sri_lanka.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("St Vincent Grenadines")) {
                        String hobby = snapshot.child("St Vincent Grenadines").getValue().toString();
                        st_vincent_grenadines.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Sudan")) {
                        String hobby = snapshot.child("Sudan").getValue().toString();
                        sudan.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }if(snapshot.hasChild("Suriname")) {
                    String hobby = snapshot.child("Suriname").getValue().toString();
                    suriname.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Sweden")) {
                    String hobby = snapshot.child("Sweden").getValue().toString();
                    sweden.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Switzerland")) {
                    String hobby = snapshot.child("Switzerland").getValue().toString();
                    switzerland.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Syria")) {
                    String hobby = snapshot.child("Syria").getValue().toString();
                    syria.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Taiwan")) {
                    String hobby = snapshot.child("Taiwan").getValue().toString();
                    taiwan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Tajikistan")) {
                    String hobby = snapshot.child("Tajikistan").getValue().toString();
                    tajikistan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Tanzania")) {
                    String hobby = snapshot.child("Tanzania").getValue().toString();
                    tanzania.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Thailand")) {
                    String hobby = snapshot.child("Thailand").getValue().toString();
                    thailand.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Timor Leste")) {
                    String hobby = snapshot.child("Timor Leste").getValue().toString();
                    timor_leste.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Togo")) {
                    String hobby = snapshot.child("Togo").getValue().toString();
                    togo.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Tonga")) {
                    String hobby = snapshot.child("Tonga").getValue().toString();
                    tonga.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Trinidad and Tobago")) {
                    String hobby = snapshot.child("Trinidad and Tobago").getValue().toString();
                    trinidad_and_tobago.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Tunisia")) {
                    String hobby = snapshot.child("Tunisia").getValue().toString();
                    tunisia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Turkey")) {
                    String hobby = snapshot.child("Turkey").getValue().toString();
                    turkey.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Turkmenistan")) {
                    String hobby = snapshot.child("Turkmenistan").getValue().toString();
                    turkmenistan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Tuvalu")) {
                    String hobby = snapshot.child("Tuvalu").getValue().toString();
                    tuvalu.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Uganda")) {
                    String hobby = snapshot.child("Uganda").getValue().toString();
                    uganda.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Ukraine")) {
                    String hobby = snapshot.child("Ukraine").getValue().toString();
                    ukraine.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("United Arab Emirates")) {
                    String hobby = snapshot.child("United Arab Emirates").getValue().toString();
                    united_arab_emirates.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("United Kingdom")) {
                    String hobby = snapshot.child("United Kingdom").getValue().toString();
                    united_kingdom.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("United States")) {
                    String hobby = snapshot.child("United States").getValue().toString();
                    united_states.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Uruguay")) {
                    String hobby = snapshot.child("Uruguay").getValue().toString();
                    uruguay.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Uzbekistan")) {
                    String hobby = snapshot.child("Uzbekistan").getValue().toString();
                    uzbekistan.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Vanuatu")) {
                    String hobby = snapshot.child("Vanuatu").getValue().toString();
                    vanuatu.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Vatican City")) {
                    String hobby = snapshot.child("Vatican City").getValue().toString();
                    vatican_city.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Venezuela")) {
                    String hobby = snapshot.child("Venezuela").getValue().toString();
                    venezuela.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Vietnam")) {
                    String hobby = snapshot.child("Vietnam").getValue().toString();
                    vietnam.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Yemen")) {
                    String hobby = snapshot.child("Yemen").getValue().toString();
                    yemen.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Zambia")) {
                    String hobby = snapshot.child("Zambia").getValue().toString();
                    zambia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Zimbabwe")) {
                    String hobby = snapshot.child("Zimbabwe").getValue().toString();
                    zimbabwe.setOnClickListener(new View.OnClickListener() {
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
            public void onComplete(@NonNull Task task)
            {
                Intent intent = new Intent(getActivity(), ProfileActivity.class);
                startActivity(intent);
            }
        });
    }
}

