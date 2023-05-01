package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.AddProfileActivity;
import com.zinging.hobbystar.Model.Gather;
import com.zinging.hobbystar.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.squareup.picasso.Picasso;


import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class GatherAdapter extends RecyclerView.Adapter<GatherAdapter.ViewHolder>
{

    public Context context;
    public List<Gather> mGather;

    public static final int MSG_TYPE_LEFT = 0;
    public static final int MSG_TYPE_RIGHT = 1;


    FirebaseUser fuser;

    public GatherAdapter(Context context, List<Gather> mGather) {
        this.context = context;
        this.mGather = mGather;
    }

    @NonNull
    @Override
    public GatherAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
    {
        if(i == MSG_TYPE_RIGHT) {
            View view = LayoutInflater.from(context).inflate(R.layout.gather_item_right, viewGroup, false);

            return new ViewHolder(view);
        }else
        {
            View view = LayoutInflater.from(context).inflate(R.layout.gather_item_left, viewGroup, false);

            return new ViewHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(@NonNull GatherAdapter.ViewHolder holder, int position)
    {
        Gather text = mGather.get(position);

        holder.Show_msg.setText(text.getMessage());

        if(text.getImage() != null)
        {
            Picasso.get().load(text.getImage()).into(holder.add_img);
            holder.add_img.setMaxHeight(200);
            holder.Show_msg.setVisibility(View.GONE);
        }

        holder.username.setText(text.getUsername());


        if(position == mGather.size()-1)
        {
            if(text.isSeen())
            {
                holder.txt_seen.setText("Seen");
            }else{
                holder.txt_seen.setText("Delivered");
            }
        }else{
            holder.txt_seen.setVisibility(View.GONE);
        }

        holder.username.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, AddProfileActivity.class);
                intent.putExtra("visit_user_id", text.getSender());
                context.startActivity(intent);
            }
        });

    }

    @Override
    public int getItemCount() {
        return mGather.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder
    {
        public TextView Show_msg, txt_seen, username;
        public CircleImageView Show_img;
        public ImageView add_img;

        public ViewHolder(@NonNull View itemView)
        {
            super(itemView);

            Show_msg = itemView.findViewById(R.id.gather_show_message);
            Show_img = itemView.findViewById(R.id.gather_text_image);
            txt_seen = itemView.findViewById(R.id.gather_text_seen);
            add_img = itemView.findViewById(R.id.gather_show_image);
            username = itemView.findViewById(R.id.gather_username);
        }
    }

    @Override
    public int getItemViewType(int position)
    {
        fuser = FirebaseAuth.getInstance().getCurrentUser();
        if(mGather.get(position).getSender().equals(fuser.getUid()))
        {
            return MSG_TYPE_RIGHT;
        }
        else{
            return  MSG_TYPE_LEFT;
        }
    }


}
