package com.zinging.hobbystar.Model;

public class Requests
{
    public String username, image;

    public Requests()
    {

    }

    public Requests(String username, String image) {
        this.username = username;
        this.image = image;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}


