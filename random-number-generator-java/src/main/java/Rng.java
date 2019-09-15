import static spark.Spark.*;
import java.util.Random;


public class Rng {
    static Random rand = new Random();

    public static int generate_randomly() {
        return rand.nextInt(1000000 + 1) + 1;
    }

    public static void main(String[] args) {
        port(8080);
        get("/", (req, res) -> generate_randomly() );
    }
}