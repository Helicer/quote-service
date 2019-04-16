package jro.quote_api.quote.models;

import javax.persistence.*;

@Entity
@Table(name = "quote")
public class Quote {

    // Attributes

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "author", nullable = true)
    private String author;


    // Getters

    public String getContent() {
        return content;
    }

    public String getAuthor() {
        return author;
    }

    public Long getId() {
        return id;
    }


    // Setters

    public void setContent(String content) {
        this.content = content;
    }

    public void setAuthor(String author) {
        this.author = author;
    }
}
