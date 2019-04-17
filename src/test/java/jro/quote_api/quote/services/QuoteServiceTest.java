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


    @Test
    public void addQuote() {


    }

    @Test
    public void getAllQuotes() {
    }

    @Test
    public void getQuoteById() {
    }
}