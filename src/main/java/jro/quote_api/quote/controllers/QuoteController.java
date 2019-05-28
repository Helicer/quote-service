package jro.quote_api.quote.controllers;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.services.QuoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/quotes")
public class QuoteController {

    @Autowired
    private QuoteService quoteService;

/*
    // List all quotes
    @GetMapping("/")
    public List<Quote> allQuotes() {
        return quoteService.getAllQuotes();
    }

    // Add single quote
    @PostMapping("/")
    public Quote newQuote(@RequestBody Quote quote) {
        return quoteService.save(quote);

    }

    // Get a single quote by ID
    @GetMapping("/{id}")
    public Optional<Quote> getQuoteById(@PathVariable(value = "id") Long id) {
        return quoteService.getQuoteById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteById(@PathVariable(value = "id") Long id) {
       quoteService.deleteQuoteById(id);

    }
*/


}
