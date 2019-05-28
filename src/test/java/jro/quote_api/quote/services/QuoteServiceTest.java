package jro.quote_api.quote.services;

import jro.quote_api.Application;
import jro.quote_api.quote.models.Quote;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.Assert;

import static org.assertj.core.api.Assertions.assertThat;


@RunWith(SpringRunner.class)
@ContextConfiguration(classes = Application.class)
@DataJpaTest
public class QuoteServiceTest {

    @Autowired
    QuoteService quoteService;

    @Test
    public void createAndFetchAQuote() {
        Long quoteId = quoteService.add(
                new Quote(
                        "A smooth sea never built a skillful sailor",
                        "JRO"
                )
        );

        Quote quote = quoteService.find(quoteId);


        assertThat(quote.getContent()).isEqualTo("A smooth sea never built a skillful sailor");
        assertThat(quote.getAuthor()).isEqualTo("JRO");

    }
}