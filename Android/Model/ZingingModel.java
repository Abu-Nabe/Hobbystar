package com.zinging.hobbystar.Model;

public class ZingingModel
{
    private String VideoName, VideoUrl, VideoPublisher, VideoID, VideoHobby, Timestring;
    private long Timestamp;

    private ZingingModel()
    {

    }

    public ZingingModel(String name, String videoUrl, String videoPublisher, String videoID, String videohobby, String timestring,long timestamp)
    {
        if(name.trim().equals(""))
        {
            name = "";
        }
        VideoName = name;
        VideoUrl = videoUrl;
        VideoHobby = videohobby;
        VideoPublisher = videoPublisher;
        VideoID = videoID;
        Timestamp = timestamp;
        Timestring = timestring;
    }

    public String getTimestring() {
        return Timestring;
    }

    public void setTimestring(String timestring) {
        Timestring = timestring;
    }

    public long getTimestamp() {
        return Timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.Timestamp = timestamp;
    }

    public String getVideoHobby() {
        return VideoHobby;
    }

    public void setVideoHobby(String videoHobby) {
        VideoHobby = videoHobby;
    }

    public String getVideoPublisher() {
        return VideoPublisher;
    }

    public void setVideoPublisher(String videoPublisher) {
        VideoPublisher = videoPublisher;
    }

    public String getVideoID() {
        return VideoID;
    }

    public void setVideoID(String videoID) {
        VideoID = videoID;
    }

    public String getVideoName() {
        return VideoName;
    }

    public void setVideoName(String videoName) {
        VideoName = videoName;
    }

    public String getVideoUrl() {
        return VideoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        VideoUrl = videoUrl;
    }
}
