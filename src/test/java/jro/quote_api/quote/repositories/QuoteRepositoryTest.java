package jro.quote_api.quote.repositories;

import jro.quote_api.quote.models.Quote;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
public class QuoteRepositoryTest {

    @Autowired
    private QuoteRepository quoteRepository;


    @Test
    public void findAllQuotes() {

        // GIVEN new quote
        String quote_content = "My best quote";
        String quote_author = "John Smith";

        Quote q1 = new Quote();
        q1.setContent(quote_content);
        q1.setAuthor(quote_author);
        quoteRepository.save(q1);

        // WHEN
        List<Quote> quotes = quoteRepository.findAll();

        // THEN
        Assert.assertTrue(quotes.size() == 1);

        Assert.assertTrue(q1.getContent() == quote_content);


    }

    @Test
    public void crud() {

    }


}