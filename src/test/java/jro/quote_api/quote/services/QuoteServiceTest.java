package jro.quote_api.quote.services;

import jro.quote_api.quote.models.Quote;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.Assert;


@RunWith(SpringRunner.class)
@DataJpaTest
public class QuoteServiceTest {

    @Autowired
    QuoteService quoteService;

    Quote q1;


    @Before
    public void init() {
        // Setup
        String q1_content = "Welcome to the jungle";
        String q1_author = "JRO";
        Quote q1 = new Quote();
        q1.setContent(q1_content);
        q1.setAuthor(q1_author);
        Long q1_id = q1.getId();
    }



    @Test
    public void addQuote() {


        // Action
        Quote myQuote = quoteService.save(q1);

        // Assert
        Assert.isTrue(myQuote.getContent().equals(q1.getContent()));



    }

    @Test
    public void getAllQuotes() {
    }

    @Test
    public void getQuoteById() {
    }
}