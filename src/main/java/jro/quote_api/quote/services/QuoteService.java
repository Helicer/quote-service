package jro.quote_api.quote.services;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.repositories.QuoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class QuoteService  {

    private QuoteRepository quoteRepository;

    @Autowired
    public QuoteService(QuoteRepository quoteRepository) {
        this.quoteRepository = quoteRepository;
    }

    public Long add(Quote quote) {
        return quoteRepository.save(quote).getId();
    }

    public Quote find(Long quoteId) {
        return quoteRepository.findById(quoteId).get();

    }
}
