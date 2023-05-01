package com.zinging.hobbystar;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

public class CategorySpinner extends AppCompatActivity {

    private TextView select;
    private Button confirm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_category_spinner);


        confirm = (Button) findViewById(R.id.confirm_hobby);
        select = findViewById(R.id.selector);

        Spinner spinner = findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> arrayAdapter = ArrayAdapter
                .createFromResource(this, R.array.Hobbies, android.R.layout.simple_spinner_item);
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(arrayAdapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l)
            {
                String text = adapterView.getItemAtPosition(i).toString();

                select.setText(text);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view)
            {
                if(select.equals("Select"))
                {
                    Toast.makeText(CategorySpinner.this, "Select A Hobby", Toast.LENGTH_SHORT).show();
                }else{
                    Intent intent = new Intent(CategorySpinner.this, CategoryPic.class);
                    intent.putExtra("Hobby", select.getText().toString());
                    startActivity(intent);
                }
            }
        });
    }
}