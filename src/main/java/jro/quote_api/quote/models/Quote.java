package jro.quote_api.quote.models;

import javax.persistence.*;

@Entity
@Table(name = "quote")
public class Quote {

    // Attributes

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "author", nullable = true)
    private String author;


    // Constructors

    public Quote() {
    }

    public Quote(String content, String author) {
        this.content = content;
        this.author = author;
    }


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
