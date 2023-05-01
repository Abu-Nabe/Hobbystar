package com.zinging.hobbystar.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.Model.Texting;
import com.zinging.hobbystar.R;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.squareup.picasso.Picasso;


import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

public class TextAdapter extends RecyclerView.Adapter<TextAdapter.ViewHolder>
{

    public Context context;
    public List<Texting> mText;

    public static final int MSG_TYPE_LEFT = 0;
    public static final int MSG_TYPE_RIGHT = 1;

    FirebaseUser fuser;

    public TextAdapter(Context context, List<Texting> mText) {
        this.context = context;
        this.mText = mText;
    }

    @NonNull
    @Override
    public TextAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i)
    {
        if(i == MSG_TYPE_RIGHT) {
            View view = LayoutInflater.from(context).inflate(R.layout.chat_item_right, viewGroup, false);

            return new ViewHolder(view);
        }else
        {
                View view = LayoutInflater.from(context).inflate(R.layout.chat_item_left, viewGroup, false);

                return new ViewHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(@NonNull TextAdapter.ViewHolder holder, int position)
    {
        Texting text = mText.get(position);

        holder.Show_msg.setText(text.getMessage());

        if(text.getImage() != null)
        {
            Picasso.get().load(text.getImage()).into(holder.add_img);
            holder.add_img.setMaxHeight(200);
            holder.Show_msg.setVisibility(View.GONE);
        }

        if(position == mText.size()-1)
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

    }

    @Override
    public int getItemCount() {
        return mText.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder
    {
        public TextView Show_msg, txt_seen;
        public CircleImageView Show_img;
        public ImageView add_img;

        public ViewHolder(@NonNull View itemView)
        {
            super(itemView);

            Show_msg = itemView.findViewById(R.id.show_message);
            Show_img = itemView.findViewById(R.id.text_image);
            txt_seen = itemView.findViewById(R.id.text_seen);
            add_img = itemView.findViewById(R.id.show_image);
        }
    }

    @Override
    public int getItemViewType(int position)
    {
        fuser = FirebaseAuth.getInstance().getCurrentUser();
        if(mText.get(position).getSender().equals(fuser.getUid()))
        {
            return MSG_TYPE_RIGHT;
        }
        else{
            return  MSG_TYPE_LEFT;
        }
    }


}
