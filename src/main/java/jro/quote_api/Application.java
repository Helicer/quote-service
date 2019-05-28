package jro.quote_api;

import jro.quote_api.quote.repositories.QuoteRepository;
import jro.quote_api.quote.services.QuoteService;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}


	// FIXME
	// Added because QuoteService test was not finding QuoteService when annotated with @Component
	@Bean
	public QuoteService quoteService(QuoteRepository quoteRepository) {
		return new QuoteService(quoteRepository);
	}
}
