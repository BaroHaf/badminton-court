package Util;

import com.google.gson.*;

import java.lang.reflect.Type;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Json {
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

    // Convert an object to JSON string
    public static String toJson(Object o) {
        return gson.toJson(o);
    }
}
