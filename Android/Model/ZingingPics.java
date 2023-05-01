package com.zinging.hobbystar.Model;

public class ZingingPics
{
    private String picid;
    private String picimage;
    private String description;
    private String publisher;
    private String hobby;
    private String timestring;
    private long timestamp;

    public ZingingPics(String picid, String picimage, String description, String publisher, String hobby, String timestring,long timestamp) {
        this.picid = picid;
        this.picimage = picimage;
        this.description = description;
        this.publisher = publisher;
        this.hobby = hobby;
        this.timestamp = timestamp;
        this.timestring = timestring;
    }

    public ZingingPics()
    {

    }

    public String getTimestring() {
        return timestring;
    }

    public void setTimestring(String timestring) {
        this.timestring = timestring;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getHobby() {
        return hobby;
    }

    public void setHobby(String hobby) {
        this.hobby = hobby;
    }

    public String getPicid() {
        return picid;
    }

    public void setPicid(String postid) {
        this.picid = postid;
    }

    public String getPicimage() {
        return picimage;
    }

    public void setPicimage(String picimage) {
        this.picimage = picimage;
    }

    public String getdescription() {
        return description;
    }

    public void setdescription(String description) {
        this.description = description;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
}
