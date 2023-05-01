package com.zinging.hobbystar.Notifications;

public class Data
{
    private String users;
    private int icon;
    private String body;
    private String title;
    private String sent;

    public Data(String users, int icon, String body, String title, String sent) {
        this.users = users;
        this.icon = icon;
        this.body = body;
        this.title = title;
        this.sent = sent;
    }

    public Data()
    {

    }

    public String getUsers() {
        return users;
    }

    public void setUsers(String users) {
        this.users = users;
    }

    public int getIcon() {
        return icon;
    }

    public void setIcon(int icon) {
        this.icon = icon;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSent() {
        return sent;
    }

    public void setSent(String sent) {
        this.sent = sent;
    }
}
