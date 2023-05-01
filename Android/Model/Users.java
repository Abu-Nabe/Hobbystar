package com.zinging.hobbystar.Model;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.zinging.hobbystar.R;
import com.google.firebase.auth.FirebaseAuth;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

public class Users extends RecyclerView.Adapter<Users.SearchViewHolder>
{

    private RecyclerViewClickListener listener;

    Context context;
    ArrayList<String> Usernamelist;
    ArrayList<String> Profilepiclist;
    ArrayList<String> VisitUID;
    ArrayList<String> Points;

    class SearchViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener
    {
        ImageView searchimage;
        TextView searchUsername;
        TextView searchPoints;
        LinearLayout searchlinear;

        public SearchViewHolder(@NonNull View itemView) {
            super(itemView);

            searchlinear = (LinearLayout) itemView.findViewById(R.id.SearchLinear);
            searchimage = (ImageView) itemView.findViewById(R.id.SearchUsers);
            searchUsername = (TextView) itemView.findViewById(R.id.SearchUsername);
            searchPoints = (TextView) itemView.findViewById(R.id.SearchName);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View view)
        {
            listener.onClick(view, getAdapterPosition());
        }
    }



    public Users(Context context, ArrayList<String> usernamelist,ArrayList<String> profilepiclist, ArrayList<String> visitUID, ArrayList<String> points ,RecyclerViewClickListener listener) {
        this.context = context;
        Usernamelist = usernamelist;
        Profilepiclist = profilepiclist;
        Points = points;
        VisitUID = visitUID;
        this.listener = listener;
    }

    @NonNull
    @Override
    public Users.SearchViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType)
    {
        View view = LayoutInflater.from(context).inflate(R.layout.user_item, parent, false);
        return new Users.SearchViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull SearchViewHolder holder, int position)
    {
        holder.searchPoints.setText(Points.get(position));

        holder.searchUsername.setText(Usernamelist.get(position));

        String uid = FirebaseAuth.getInstance().getUid();
        VisitUID.add(uid);

        Picasso.get().load(Profilepiclist.get(position)).placeholder(R.drawable.profile).into(holder.searchimage);
    }


    @Override
    public int getItemCount() {
        return Usernamelist.size();
    }

    public interface RecyclerViewClickListener
    {
        void onClick(View v, int position);
    }
}
