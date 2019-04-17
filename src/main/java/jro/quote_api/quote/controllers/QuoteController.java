package jro.quote_api.quote.controllers;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.services.QuoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/quotes")
public class QuoteController {

    @Autowired
    private QuoteService quoteService;


    // List all quotes
    @GetMapping("/")
    List<Quote> allQuotes() {
        return quoteService.getAllQuotes();
    }

    // Add single quote
    @PostMapping("/")
    Quote newQuote(@RequestBody Quote newQuote) {
        return quoteService.save(newQuote);

    }

}
