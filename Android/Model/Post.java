package com.zinging.hobbystar.Model;

public class Post
{
    private String postid;
    private String postimage;
    private String postdescription;
    private String publisher;
    private String timestring;
    private long timestamp;

    public Post(String postid, String postimage, String postdescription, String publisher, String timestring,long timestamp) {
        this.postid = postid;
        this.postimage = postimage;
        this.postdescription = postdescription;
        this.publisher = publisher;
        this.timestamp = timestamp;
        this.timestring = timestring;
    }

    public Post()
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

    public String getPostid() {
        return postid;
    }

    public void setPostid(String postid) {
        this.postid = postid;
    }

    public String getPostimage() {
        return postimage;
    }

    public void setPostimage(String postimage) {
        this.postimage = postimage;
    }

    public String getPostdescription() {
        return postdescription;
    }

    public void setPostdescription(String postdescription) {
        this.postdescription = postdescription;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
}
