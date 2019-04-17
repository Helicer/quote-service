package jro.quote_api.quote.repositories;

import jro.quote_api.quote.models.Quote;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuoteRepository extends JpaRepository<Quote, Long> {

}
