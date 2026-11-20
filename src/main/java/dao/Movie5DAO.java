package dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Movie5;

public class Movie5DAO extends DAO5 {
    public Movie5[] findMoviesByTitle(String title) throws SQLException {
        List<Movie5> movies = new ArrayList<>();
        try (Connection connection = getConnection();
             CallableStatement query = connection.prepareCall("{call findMoviesByTitle(?)}")) {
            query.setString(1, title);
            try (ResultSet rows = query.executeQuery()) {
                while (rows.next()) {
                    movies.add(readMovie(rows));
                }
            }
        }
        return movies.toArray(Movie5[]::new);
    }

    public Movie5 getMovieDetails(int movieId) throws SQLException {
        try (Connection connection = getConnection();
             CallableStatement query = connection.prepareCall("{call getMovieDetails(?)}")) {
            query.setInt(1, movieId);
            try (ResultSet rows = query.executeQuery()) {
                return rows.next() ? readMovie(rows) : null;
            }
        }
    }

    private Movie5 readMovie(ResultSet row) throws SQLException {
        return new Movie5(row.getInt("id"), row.getString("title"), row.getString("genre"),
                row.getInt("duration"), row.getString("description"));
    }
}
