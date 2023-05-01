package com.zinging.hobbystar.Model;

public class Message
{
    public String username, image, groupname;

    public Message()
    {

    }

    public Message(String username, String image, String groupname) {
        this.username = username;
        this.image = image;
        this.groupname = groupname;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
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


