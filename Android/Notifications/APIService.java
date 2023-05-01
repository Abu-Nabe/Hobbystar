package com.zinging.hobbystar.Notifications;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Headers;
import retrofit2.http.POST;

public interface APIService {
    @Headers(
            {
                    "Content-Type:application/json",
                    "Authorization:key=AAAAthneo50:APA91bEhw_06joRsBVA8x8sTaab4nPyQySXilkOajj33wI59mSVX62p_X5swDgbA4VfhewfYV84KZHnHRhX1mHCi4degFcnWClkrkTWQxlwe6xSqB3LMvIQns4NA6vcBEstxnocYn3qm"
            }
    )

    @POST("fcm/send")
    Call<MyResponse> sendNotification(@Body Sender body);
}

