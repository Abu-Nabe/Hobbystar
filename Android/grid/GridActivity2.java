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

public class GridActivity2 extends AppCompatDialogFragment
{


    private String currentUserID;
    private FirebaseAuth mAuth;
    private DatabaseReference UsersRef, Hobbies;
    private StorageReference UserProfileImageRef;
    private OutputStream outputStream;
    private Button next, back;

    private ImageView centralAfrican, chad, chile, china, colombia, comoros, congo, ivorycoast,
            cyprus, czech, democraticcongo, denmark, djibouti, dominica, dominicanrepublic, ecuador, egypt, elsalvador, equatorialguinea;

    private ImageView eritrea, estonia, eswatini, ethiopia, fiji, finland, france, gabon, gambia, georgia, germany, ghana,greece;

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.activity_grid2, null);

        builder.setView(view);

        mAuth = FirebaseAuth.getInstance();
        currentUserID = mAuth.getCurrentUser().getUid();

        UsersRef = FirebaseDatabase.getInstance().getReference().child("Users").child(currentUserID);
        Hobbies = FirebaseDatabase.getInstance().getReference("Countries");
        UserProfileImageRef = FirebaseStorage.getInstance().getReference().child("hobby");

        centralAfrican = view.findViewById(R.id.CentralAfricanRepublic);
        chad = view.findViewById(R.id.Chad);
        chile = view.findViewById(R.id.Chile);
        china = view.findViewById(R.id.China);
        colombia = view.findViewById(R.id.Colombia);
        comoros = view.findViewById(R.id.Comoros);
        congo = view.findViewById(R.id.Congo);
        ivorycoast = view.findViewById(R.id.IvoryCoast);
        cyprus = view.findViewById(R.id.Cyprus);
        czech = view.findViewById(R.id.CzechRepublic);
        democraticcongo = view.findViewById(R.id.Grenada);
        denmark = view.findViewById(R.id.Denmark);
        djibouti = view.findViewById(R.id.Djibouti);
        dominica = view.findViewById(R.id.Dominica);
        dominicanrepublic = view.findViewById(R.id.DominicanRepublic);
        ecuador = view.findViewById(R.id.Ecuador);
        egypt = view.findViewById(R.id.Egypt);
        elsalvador = view.findViewById(R.id.ElSalvador);
        equatorialguinea = view.findViewById(R.id.EquatorialGuinea);
        eritrea = view.findViewById(R.id.Eritrea);
        estonia = view.findViewById(R.id.Estonia);
        eswatini = view.findViewById(R.id.Eswatini);
        ethiopia = view.findViewById(R.id.Ethiopia);
        fiji = view.findViewById(R.id.Fiji);
        finland = view.findViewById(R.id.Finland);
        france = view.findViewById(R.id.France);
        gabon = view.findViewById(R.id.Gabon);
        gambia = view.findViewById(R.id.Gambia);
        georgia = view.findViewById(R.id.Georgia);
        germany = view.findViewById(R.id.Germany);
        ghana = view.findViewById(R.id.Ghana);
        greece = view.findViewById(R.id.Greece);

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
                GridActivity3 gridActivity = new GridActivity3();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                back.setVisibility(View.INVISIBLE);
                next.setVisibility(View.INVISIBLE);
                GridActivity gridActivity = new GridActivity();
                gridActivity.show(getParentFragmentManager(), "fuck");
            }
        });

        Hobbies.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("Central African Republic")) {
                        String hobby = snapshot.child("Central African Republic").getValue().toString();
                        centralAfrican.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Chad")) {
                        String hobby = snapshot.child("Chad").getValue().toString();
                        chad.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }
                    if(snapshot.hasChild("Chile")) {
                        String hobby = snapshot.child("Chile").getValue().toString();
                        chile.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                SaveToProfile(hobby);
                            }
                        });
                    }if(snapshot.hasChild("China")) {
                    String hobby = snapshot.child("China").getValue().toString();
                    china.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Colombia")) {
                    String hobby = snapshot.child("Colombia").getValue().toString();
                    colombia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Comoros")) {
                    String hobby = snapshot.child("Comoros").getValue().toString();
                    comoros.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Congo")) {
                    String hobby = snapshot.child("Congo").getValue().toString();
                    congo.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Cote D'Ivoire")) {
                    String hobby = snapshot.child("Cote D'Ivoire").getValue().toString();
                    ivorycoast.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Cyprus")) {
                    String hobby = snapshot.child("Cyprus").getValue().toString();
                    cyprus.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("CzechRepublic")) {
                    String hobby = snapshot.child("CzechRepublic").getValue().toString();
                    czech.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Grenada")) {
                    String hobby = snapshot.child("Grenada").getValue().toString();
                    democraticcongo.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Denmark")) {
                    String hobby = snapshot.child("Denmark").getValue().toString();
                    denmark.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Djibouti")) {
                    String hobby = snapshot.child("Djibouti").getValue().toString();
                    djibouti.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Dominica")) {
                    String hobby = snapshot.child("Dominica").getValue().toString();
                    dominica.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Dominican Republic")) {
                    String hobby = snapshot.child("Dominican Republic").getValue().toString();
                    dominicanrepublic.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Ecuador")) {
                    String hobby = snapshot.child("Ecuador").getValue().toString();
                    ecuador.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Egypt")) {
                    String hobby = snapshot.child("Egypt").getValue().toString();
                    egypt.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("El Salvador")) {
                    String hobby = snapshot.child("El Salvador").getValue().toString();
                    elsalvador.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Equatorial Guinea")) {
                    String hobby = snapshot.child("Equatorial Guinea").getValue().toString();
                    equatorialguinea.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Eritrea")) {
                    String hobby = snapshot.child("Eritrea").getValue().toString();
                    eritrea.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Eswatini")) {
                    String hobby = snapshot.child("Eswatini").getValue().toString();
                    eswatini.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Estonia")) {
                    String hobby = snapshot.child("Estonia").getValue().toString();
                    estonia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Ethiopia")) {
                    String hobby = snapshot.child("Ethiopia").getValue().toString();
                    ethiopia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Fiji")) {
                    String hobby = snapshot.child("Fiji").getValue().toString();
                    fiji.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Finland")) {
                    String hobby = snapshot.child("Finland").getValue().toString();
                    finland.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("France")) {
                    String hobby = snapshot.child("France").getValue().toString();
                    france.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Gabon")) {
                    String hobby = snapshot.child("Gabon").getValue().toString();
                    gabon.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Gambia")) {
                    String hobby = snapshot.child("Gambia").getValue().toString();
                    gambia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Georgia")) {
                    String hobby = snapshot.child("Georgia").getValue().toString();
                    georgia.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Germany")) {
                    String hobby = snapshot.child("Germany").getValue().toString();
                    germany.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Ghana")) {
                    String hobby = snapshot.child("Ghana").getValue().toString();
                    ghana.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            SaveToProfile(hobby);
                        }
                    });
                }if(snapshot.hasChild("Greece")) {
                    String hobby = snapshot.child("Greece").getValue().toString();
                    greece.setOnClickListener(new View.OnClickListener() {
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

