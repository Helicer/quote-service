package jro.quote_api.quote.controllers;

import org.hamcrest.Matchers;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.test.context.junit4.SpringRunner;

import static io.restassured.RestAssured.given;
import static org.assertj.core.api.Assertions.assertThat;


@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class QuoteControllerTest {

    @LocalServerPort
    private int port;

    @Test
    public void addQuotesAndThenFetchThem() {
        Long id = given()
                .contentType("application/json")
                .body("" +
                        "{" +
                        "  \"content\":\"always be kind\"," +
                        "  \"author\":\"Rob Mee\"" +
                        "}"
                )
                .when()
                .post("http://localhost:" + port +  "/quotes")
                .then()
                .statusCode(200)
                .extract()
                .body()
                .jsonPath()
                .getLong("id");

        assertThat(id).isNotNull();

        given()
                .contentType("application/json")
                .when()
                .get("http://localhost:" +  port +  "/quotes/" + id)
                .then()
                .statusCode(200)
                .body("content", Matchers.equalTo("always be kind"))
                .body("author", Matchers.equalTo("Rob Mee"));
    }


}