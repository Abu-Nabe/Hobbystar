package com.zinging.hobbystar;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatDialogFragment;

import com.zinging.hobbystar.Model.PaypalConfig;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.paypal.android.sdk.payments.PayPalConfiguration;
import com.paypal.android.sdk.payments.PayPalPayment;
import com.paypal.android.sdk.payments.PayPalService;
import com.paypal.android.sdk.payments.PaymentActivity;
import com.paypal.android.sdk.payments.PaymentConfirmation;
import com.squareup.picasso.Picasso;

import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;

import de.hdodenhof.circleimageview.CircleImageView;

public class PaymentInfo extends AppCompatDialogFragment
{
    private TextView Username, Gather, Payment, Date;
    private CircleImageView Profile;
    private Button Pay;
    FirebaseAuth mAuth;
    DatabaseReference UsersRef;

    String userid;
    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState)
    {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());

        LayoutInflater inflater = getActivity().getLayoutInflater();
        View view = inflater.inflate(R.layout.payment_info, null);

        builder.setView(view);

        Intent intent = new Intent(getContext(), PayPalService.class);
        intent.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, config);
        getContext().startService(intent);

        Username = view.findViewById(R.id.PaypalUsername);
        Profile = view.findViewById(R.id.PaypalProfile);
        Gather = view.findViewById(R.id.PaypalGather);
        Payment = view.findViewById(R.id.PaypalPayment);
        Date = view.findViewById(R.id.PaypalDate);

        Pay = view.findViewById(R.id.PaypalPay);

        UsersRef = FirebaseDatabase.getInstance().getReference("Users");

        Bundle mArgs = getArguments();
        String myValue = mArgs.getString("userid");

        UsersRef.child(myValue).addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if(snapshot.exists())
                {
                    if(snapshot.hasChild("profileimage"))
                    {
                        String image = snapshot.child("profileimage").getValue().toString();
                        Picasso.get().load(image).into(Profile);
                    }
                    if(snapshot.hasChild("gathername"))
                    {
                        String gather = snapshot.child("gathername").getValue().toString();
                        Gather.setText(gather);
                    }
                    String username = snapshot.child("username").getValue().toString();
                    Username.setText(username);
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        Pay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                paypalPayment();
            }
        });

        return builder.create();



    }

    private int PAYPAL_REQUEST_CODE = 1;
    private static PayPalConfiguration config = new PayPalConfiguration()
            .environment(PayPalConfiguration.ENVIRONMENT_SANDBOX)
            .clientId(PaypalConfig.PAYPAL_CLIENT_ID);


    private void paypalPayment()
    {
        PayPalPayment payment = new PayPalPayment(new BigDecimal(5), "AUD", "Gather",
                PayPalPayment.PAYMENT_INTENT_SALE);

        Intent intent = new Intent(getContext(), PaymentActivity.class);
        intent.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, config);
        intent.putExtra(PaymentActivity.EXTRA_PAYMENT, payment);
        startActivityForResult(intent, PAYPAL_REQUEST_CODE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == PAYPAL_REQUEST_CODE){
            if(resultCode == Activity.RESULT_OK)
            {
                PaymentConfirmation confirm = data.getParcelableExtra(PaymentActivity.EXTRA_RESULT_CONFIRMATION);
                if(confirm != null)
                {
                    try{
                        JSONObject jsonObj = new JSONObject(confirm.toJSONObject().toString());

                        String paymentResponse = jsonObj.getJSONObject("response").getString("state");

                        if(paymentResponse.equals("approved")){
                            Toast.makeText(getContext(),"Payment Successful", Toast.LENGTH_SHORT).show();
                            //DataOnGather
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                    }
                }
            }else {
                Toast.makeText(getContext(),"Payment Failed", Toast.LENGTH_SHORT).show();
            }
        }
    }

    @Override
    public void onDestroyView() {
        getContext().stopService(new Intent(getContext(), PayPalService.class));
        super.onDestroyView();
    }
}
