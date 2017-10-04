import com.temboo.core.*;
import com.temboo.Library.Yahoo.Weather.*;

class Venue {
  protected String name="", ip;
  protected float temperature=0.0, maptemperature=0.0;
  private TembooSession session = new TembooSession("sergiorebelo", "MovingPoster", "C9d7f41t5SNDjmq0HWvNZJDlQzLSI4Mq");
  private GetWeatherByAddressResultSet weather;
  
  /**
  */
  public Venue () {
    this.ip = loadStrings("http://checkip.amazonaws.com")[0];
    this.name = getVenue (this.ip);
    this.weather = runGetWeatherByAddressChoreo(this.name);
    this.getTemperature (4);
    println ("temperature: "+this.temperature);
  }
  
  /*
  */
  protected float getTemperature (int mapLength) {
    this.temperature = parseFloat(this.weather.getTemperature());
    float value = map (temperature, min, max, 0, mapLength);
    return value;
  }

  /**
   * get physical location by place
   * @param ip: machine ip
   * @return: venue
   */
  protected String getVenue (String ip) {
    JSONObject info;
    String [] raw = loadStrings ("http://www.geoplugin.net/json.gp?ip="+ip);
    String jsonObject = join(raw, " ");
    info = parseJSONObject(jsonObject);
    String venue = info.getString("geoplugin_city");
    return venue;
  }

  /**
   */
  private float runGetTemperatureChoreo(String venue) {
    // Create the Choreo object using your Temboo session
    GetTemperature getTemperatureChoreo = new GetTemperature(session);
    // Set inputs
    getTemperatureChoreo.setAddress(venue);
    getTemperatureChoreo.setUnits("c");
    // Run the Choreo and store the results
    GetTemperatureResultSet getTemperatureResults = getTemperatureChoreo.run();
    // return results
    return parseFloat(getTemperatureResults.getTemperature());
  }
  /**
   */
  private GetWeatherByAddressResultSet runGetWeatherByAddressChoreo(String venue) {
    // Create the Choreo object using your Temboo session
    GetWeatherByAddress getWeatherByAddressChoreo = new GetWeatherByAddress(session);
    // Set inputs
    getWeatherByAddressChoreo.setAddress(venue);
    getWeatherByAddressChoreo.setUnits("c");
    // Run the Choreo and store the results
    GetWeatherByAddressResultSet getWeatherByAddressResults = getWeatherByAddressChoreo.run();
    return getWeatherByAddressResults;
  }
}