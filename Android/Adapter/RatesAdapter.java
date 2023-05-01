package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.zinging.hobbystar.Model.Ratelikes;
import com.zinging.hobbystar.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.squareup.picasso.Picasso;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

import de.hdodenhof.circleimageview.CircleImageView;

public class RatesAdapter extends RecyclerView.Adapter<RatesAdapter.RatesViewHolder>
{
    private Context context;
    private ArrayList<Ratelikes> ratelist;

    public RatesAdapter(Context context, ArrayList<Ratelikes> ratelist)
    {
        this.context = context;
        this.ratelist = ratelist;
    }

    @NonNull
    @Override
    public RatesViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int viewType)
    {
        View view = LayoutInflater.from(context).inflate(R.layout.testing, viewGroup, false);
        return new RatesViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RatesViewHolder holder, int position)
    {
        Ratelikes ratelikes = ratelist.get(position);

        holder.username.setText(ratelikes.getUsername());

        String userid = FirebaseAuth.getInstance().getUid();

        getuserinfo(holder.image, holder.username, userid);

    }

    private void getuserinfo(CircleImageView imageview, TextView username, String publisherid)
    {
        DatabaseReference reference = FirebaseDatabase.getInstance().getReference("Users").child(publisherid);
        reference.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot)
            {
                Ratelikes user = snapshot.getValue(Ratelikes.class);
                if(snapshot.hasChild("profileimage")) {
                    String image = snapshot.child("profileimage").getValue().toString();
                    Picasso.get().load(image).into(imageview);
                }
                username.setText(user.getUsername());
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });
    }

    @Override
    public int getItemCount() {
        return 0;
    }

    class RatesViewHolder extends RecyclerView.ViewHolder {

        TextView username, Date;
        CircleImageView image;
        public RatesViewHolder(View itemView)
        {
            super(itemView);

            username = itemView.findViewById(R.id.SearchUsername);
            image = itemView.findViewById(R.id.SearchUsers);
            Date = itemView.findViewById(R.id.SearchName);
        }
    }
}

