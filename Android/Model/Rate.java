package com.zinging.hobbystar.Model;

public class Rate
{
    public String username, image;

    public Rate()
    {

    }

    public Rate(String username, String image) {
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


