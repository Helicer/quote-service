package jro.quote_api.quote.services;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.repositories.QuoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class QuoteService  {

    @Autowired
    private QuoteRepository quoteRepository;


    // Save
    public Quote save(Quote quote) {
        return quoteRepository.save(quote);
    }


    // Delete by ID
    public void deleteQuoteById(Long id) {
        quoteRepository.deleteById(id);
    }

    // List all
    public List<Quote> getAllQuotes() {
        return quoteRepository.findAll();
    }

    // Get by ID
    public Optional<Quote> getQuoteById(Long id) {
        return quoteRepository.findById(id);
    }


}
