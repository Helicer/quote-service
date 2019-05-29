package jro.quote_api.quote.services;

import jro.quote_api.Application;
import jro.quote_api.quote.models.Quote;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;


@RunWith(SpringRunner.class)
@ContextConfiguration(classes = Application.class)
@DataJpaTest
public class QuoteServiceTest {

    @Autowired
    QuoteService quoteService;

    @Test
    public void createAndFetchAQuote() {
        Quote savedQuote = quoteService.add(
                new Quote(
                        "A smooth sea never built a skillful sailor",
                        "JRO"
                )
        );

        Quote quote = quoteService.find(savedQuote.getId());


        assertThat(quote.getContent()).isEqualTo("A smooth sea never built a skillful sailor");
        assertThat(quote.getAuthor()).isEqualTo("JRO");

    }

    @Test
    public void createSeveralQuotesAndFetchThemAll() {


        Quote quote1 = quoteService.add(
                new Quote(
                        "A smooth sea never built a skillful sailor",
                        "JRO"
                )
        );
        Quote quote2 = quoteService.add(
                new Quote(
                        "This was probably a bad idea.",
                        "David"
                )
        );


        List<Quote> quotes = quoteService.findAll();


        Quote quoteWithID1 = quotes.stream()
                .filter(quote -> quote.getId().equals(quote1.getId()))
                .findFirst()
                .get();

        assertThat(quoteWithID1.getContent()).isEqualTo("A smooth sea never built a skillful sailor");

        Quote quoteWithID2 = quotes.stream()
                .filter(quote -> quote.getId().equals(quote2.getId()))
                .findFirst()
                .get();

        assertThat(quoteWithID2.getContent()).isEqualTo("This was probably a bad idea.");

    }


}