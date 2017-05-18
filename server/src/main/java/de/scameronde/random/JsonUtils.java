package de.scameronde.random;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Optional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import javaslang.control.Either;

public class JsonUtils {
  public static <T> Either<Exception, Optional<String>> dataToJson(Optional<T> data) {
    if (data.isPresent()) {
      return internalDataToJson(data.get()).map(json -> Optional.of(json));
    }
    else {
      return Either.right(Optional.empty());
    }
  }

  public static <T> Either<Exception, String> dataToJson(T data) {
    return internalDataToJson(data);
  }

  private static <T> Either<Exception, String> internalDataToJson(T data) {
    try {
      ObjectMapper mapper = new ObjectMapper();
      mapper.enable(SerializationFeature.INDENT_OUTPUT);
      StringWriter sw = new StringWriter();
      mapper.writeValue(sw, data);
      sw.close();
      return Either.right(sw.toString());
    }
    catch (IOException e) {
      e.printStackTrace();
      return Either.left(e);
    }
  }

  public static <T> Either<Exception, T> jsonToData(String json, Class<T> clazz) {
    try {
      ObjectMapper mapper = new ObjectMapper();
      T creation = mapper.readValue(json, clazz);
      return Either.right(creation);
    }
    catch (IOException e) {
      e.printStackTrace();
      return Either.left(e);
    }
  }
}
