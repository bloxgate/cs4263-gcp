import org.junit.Test;
import org.junit.Assert;

import java.util.Arrays;

public class RngTest {
    @Test
    public void test_rng()
    {
        for (int i = 0; i < 10; i++)
        {
            int[] list = new int[1000];
            for (int j = 0; j < 1000; j++)
            {
                list[j] = Rng.generate_randomly();
            }
            Assert.assertTrue(Arrays.stream(list).distinct().count() >= 750);
        }
    }
}