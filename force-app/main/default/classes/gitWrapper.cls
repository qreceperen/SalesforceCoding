public class gitWrapper {
  public String login;
  public Integer id;
  public String description;

  public static List<gitWrapper> parse(String json) {
    return (List<gitWrapper>) System.JSON.deserialize(
      json,
      List<gitWrapper>.class
    );
  }
}
