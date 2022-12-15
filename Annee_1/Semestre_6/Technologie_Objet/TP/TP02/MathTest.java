import static org.junit.Assert.*;

import org.junit.Test;

public class MathTest {

	public static final double EPSILON = 1e-6;

	@Test
	public void testSqrt() {
		assertEquals(Math.sqrt(4), 2, EPSILON);
	}

}
