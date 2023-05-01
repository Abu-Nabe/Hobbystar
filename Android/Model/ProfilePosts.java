package com.zinging.hobbystar.Model;

public class ProfilePosts
{
    private String userid, postid;
    private boolean ispost;

    public ProfilePosts(String userid, String postid, boolean ispost) {
        this.userid = userid;
        this.postid = postid;
        this.ispost = ispost;
    }

    public ProfilePosts()
    {

    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getPostid() {
        return postid;
    }

    public void setPostid(String postid) {
        this.postid = postid;
    }

    public boolean isIspost() {
        return ispost;
    }

    public void setIspost(boolean ispost) {
        this.ispost = ispost;
    }
}
