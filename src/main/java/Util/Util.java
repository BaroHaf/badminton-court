package Util;

import com.google.gson.*;

import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.regex.Pattern;

public class Util {

    public static String passwordRegex = "^(?=.*[^a-zA-Z0-9]).{8,}$";
    public static String usernameRegex = "^[a-zA-Z]+$";
    public static String emailRegex = "^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,6}$";
    public static String phoneRegex = "^0(3|5|7|8|9)[0-9]{8}$";


    public static class LocalTimeAdapter implements JsonSerializer<LocalTime>, JsonDeserializer<LocalTime> {
        private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");

        @Override
        public JsonElement serialize(LocalTime time, Type typeOfSrc, JsonSerializationContext context) {
            return new JsonPrimitive(time.format(formatter)); // Convert LocalTime to String
        }

        @Override
        public LocalTime deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
                throws JsonParseException {
            return LocalTime.parse(json.getAsString(), formatter); // Convert String back to LocalTime
        }
    }
    private static final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
            .setPrettyPrinting()
            .create();

    public static String toJson(Object o) {
        return gson.toJson(o);
    }
    public static double calculateHourDifference(LocalDateTime start, LocalDateTime end) {
        long minutes = Duration.between(start, end).toMinutes();
        return minutes / 60.0;
    }
    public static String formatTimeStamp(Timestamp timestamp) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(timestamp);
    }
    public static String formatLocalDateTime(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return dateTime.format(formatter);
    }
    public static String removeAccents(String input) {
        if (input == null) return null;
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(normalized).replaceAll("").toLowerCase();
    }
    public static boolean isPasswordValid(String password){
        return password.matches(passwordRegex);
    }
    public static boolean isUsernameValid(String username){
        return username.matches(usernameRegex);
    }
    public static boolean isEmailValid(String email) {
        return email.matches(emailRegex);
    }
    public static boolean isPhoneValid(String phone) {
        return phone.matches(phoneRegex);
    }
}
