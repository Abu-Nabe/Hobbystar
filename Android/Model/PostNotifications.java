package com.zinging.hobbystar.Model;

public class PostNotifications
{
    private String post;
    private String publisher;
    private String timestring;
    private long timestamp;
    private String description;
    private String posttype;

    public PostNotifications(String post, String publisher, String timestring, long timestamp, String description, String posttype) {
        this.post = post;
        this.publisher = publisher;
        this.timestring = timestring;
        this.timestamp = timestamp;
        this.description = description;
        this.posttype = posttype;
    }

    public PostNotifications()
    {

    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPosttype() {
        return posttype;
    }

    public void setPosttype(String posttype) {
        this.posttype = posttype;
    }
}
