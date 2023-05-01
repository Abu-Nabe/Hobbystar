package com.zinging.hobbystar.Model;

public class Texting
{
    private String receiver, sender, message, image;

    private boolean seen;

    private Texting()
    {

    }

    public Texting(String receiver, String sender, String message, String image, boolean seen) {
        this.receiver = receiver;
        this.sender = sender;
        this.message = message;
        this.image = image;
        this.seen = seen;
    }

    public boolean isSeen() {
        return seen;
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
