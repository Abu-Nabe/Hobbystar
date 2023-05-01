package com.zinging.hobbystar.Model;

public class Gather
{
    private String receiver, sender, message, image, username;

    private boolean seen;

    private Gather()
    {

    }

    public Gather(String receiver, String sender, String message, String image, String username, boolean seen) {
        this.receiver = receiver;
        this.sender = sender;
        this.message = message;
        this.image = image;
        this.username = username;
        this.seen = seen;
    }

    public boolean isSeen() {
        return seen;
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

    public void setSeen(boolean seen) {
        this.seen = seen;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
