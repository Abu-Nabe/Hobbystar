package com.zinging.hobbystar.Model;

public class Comments
{
    private String comment, publisher, timestring;
    private long timestamp;

    public Comments(String comment, String publisher, String timestring,long timestamp) {
        this.comment = comment;
        this.publisher = publisher;
        this.timestamp = timestamp;
        this.timestring = timestring;
    }

    public Comments()
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

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
}
