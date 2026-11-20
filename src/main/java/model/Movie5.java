package model;

import java.util.Locale;

public class Movie5 {
    private final int id;
    private final String title;
    private final String genre;
    private final int duration;
    private final String description;

    public Movie5(int id, String title, String genre, int duration, String description) {
        this.id = id;
        this.title = title;
        this.genre = genre;
        this.duration = duration;
        this.description = description;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getGenre() { return genre; }
    public int getDuration() { return duration; }
    public String getDescription() { return description; }

    public String getCode() {
        return String.format(Locale.ROOT, "PH%03d", id);
    }
}
