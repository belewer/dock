package com.pepe.dock;

import com.pepe.dock.controllers.MainController;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class DockApplicationTests {

	@Test
	void index() {
		MainController controller = new MainController();
		String response = controller.index();
		Assertions.assertNotNull(response);

	}

}
