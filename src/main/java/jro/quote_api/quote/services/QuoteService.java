package jro.quote_api.quote.services;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.repositories.QuoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class QuoteService  {

    @Autowired
    private QuoteRepository quoteRepository;


    public QuoteService(QuoteRepository quoteRepository) {
        this.quoteRepository = quoteRepository;
    }

    public Quote add(Quote quote) {
        return quoteRepository.save(quote);
    }

    public Quote find(Long quoteId) {
        return quoteRepository.findById(quoteId).get();

    }

    public List<Quote> findAll() {

        return quoteRepository.findAll();

    }
}
