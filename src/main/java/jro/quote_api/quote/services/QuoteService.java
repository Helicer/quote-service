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


    // Add new quote
    public Quote add(Quote quote) {
        return quoteRepository.save(quote);
    }

    // Find quote by ID
    public Optional<Quote> find(Long quoteId) {
        return quoteRepository.findById(quoteId);

    }

    // List all quotes
    public List<Quote> findAll() {
        return quoteRepository.findAll();
    }

    public void delete(Long quoteID) {
        quoteRepository.deleteById(quoteID);
    }

    // TODO: Edit existing quote


}
