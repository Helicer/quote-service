package jro.quote_api;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.services.QuoteService;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;


@RunWith(SpringRunner.class)
@ContextConfiguration(classes = Application.class)
public class QuoteServiceTests {

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

        Optional<Quote> quote = quoteService.find(savedQuote.getId());

        assertThat(quote.get().getContent()).isEqualTo("A smooth sea never built a skillful sailor");
        assertThat(quote.get().getAuthor()).isEqualTo("JRO");

    }


    @Ignore("Not working yet!")
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


        // Check number of quotes
        // TODO: Why is this appearing as 3 instead of 2?
        assertThat(quotes.size()).isEqualTo(2);


        // Loop through quotes, filter by ID, check content matches
        Quote quoteWithID1 = quotes.stream()
                .filter(quote -> quote.getId().equals(quote1.getId()))
                .findFirst()
                .get();

        assertThat(quoteWithID1.getContent()).isEqualTo("A smooth sea never built a skillful sailor");

        // Loop through quotes, filter by ID, check content matches
        Quote quoteWithID2 = quotes.stream()
                .filter(quote -> quote.getId().equals(quote2.getId()))
                .findFirst()
                .get();

        assertThat(quoteWithID2.getContent()).isEqualTo("This was probably a bad idea.");

    }

    @Test
    public void createAQuoteThenDeleteIt() {

        // Create quote
        Quote savedQuote = quoteService.add(
                new Quote(
                        "Whoever has the gold, rules.",
                        "JRO"
                )
        );

        Long quoteID = savedQuote.getId();


        // Verify quote exists

        Optional<Quote> quote = quoteService.find(quoteID);
        assertThat(quote.get().getContent()).isEqualTo("Whoever has the gold, rules.");

        // Delete it
        quoteService.delete(quoteID);

        // Verify it's gone
        assertThat(quoteService.find(quoteID)).isEmpty();


    }

    @Test
    public void createAQuoteAndEditIt() {

        // Create quote
        Quote savedQuote = quoteService.add(
                new Quote(
                        "Whoever has the gold, rules.",
                        "JRO"
                )
        );

        Long quoteID = savedQuote.getId();


        // Verify quote exists
        Optional<Quote> quote = quoteService.find(quoteID);
        assertThat(quote.get().getContent()).isEqualTo("Whoever has the gold, rules.");

        // Change quote
        quote.get().setContent("How much could a banana cost?");
        quote.get().setAuthor("Lucile Bluth");

        // Verify new content
        assertThat(quote.get().getContent()).isEqualTo("How much could a banana cost?");
        assertThat(quote.get().getAuthor()).isEqualTo("Lucile Bluth");

    }


}