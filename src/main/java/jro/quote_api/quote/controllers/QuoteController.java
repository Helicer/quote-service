package jro.quote_api.quote.controllers;

import jro.quote_api.quote.models.Quote;
import jro.quote_api.quote.services.QuoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/quotes")
public class QuoteController {

    @Autowired
    private QuoteService quoteService;




    // Add single quote
    @PostMapping()
    public Quote newQuote(@RequestBody Quote quote) {

        return quoteService.add(quote);

    }

    @GetMapping("/{id}")
    public Quote getQuote(@PathVariable("id") Long quoteid) {

        return quoteService.find(quoteid);

    }


}
