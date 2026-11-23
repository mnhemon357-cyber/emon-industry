import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
public class Health {
  public static void main(String[] a) throws Exception {
    HttpServer s = HttpServer.create(new InetSocketAddress(8080), 0);
    s.createContext("/health", x -> { byte[] b = "{\"status\":\"ok\"}".getBytes(); x.getResponseHeaders().add("Content-Type","application/json"); x.sendResponseHeaders(200,b.length); x.getResponseBody().write(b); x.close(); });
    s.start(); System.out.println("Efirm service on :8080/health");
  }
}
