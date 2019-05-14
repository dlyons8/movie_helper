class MovieHelper::Movie
  attr_accessor :title, :year, :watch_with, :watch_when, :genre, :review, :stars, :rating, :language, :url

  @@best_films = []
  @@latest = []

  def self.scrape_movie(link)
    doc = Nokogiri::HTML(open(link))

    movie = self.new

    movie.title = doc.css("h1").children.first.text.strip
    # movie.year = doc.css("h1 span.movieyear").first.text
    movie.watch_with = doc.css("span[title='More movies to watch with']").children.text.strip
    movie.watch_when = doc.css("span[title='More movies to watch when']").children.text.strip
    movie.genre = doc.css("span[itemprop='genre']").children.text.strip
    movie.review = doc.css(".review-block span p").text
    movie.stars = doc.css("#agmtw-opened li.meta-item div.infom span").first.children.text
    #e.g. for individual actor/actress: doc.css("#agmtw-opened li.meta-item div.infom span").first.children.first.attributes.first.last.value
    movie.rating = doc.css("span[itemprop='contentRating']").children.text.strip
    movie.language = doc.css("span[title='More from the language']").children.text.strip
    movie.url = link
    movie
  end

  def self.random
    scrape_movie("https://agoodmovietowatch.com/random/")
  end

  def self.scrape_best_films
    doc = Nokogiri::HTML(open("https://agoodmovietowatch.com/best/"))
    links = doc.css("h3").map {|movie| movie.elements.first.first.last}
    @@best_films = links.map {|movie_link| self.scrape_movie(movie_link)}
  end

  def self.best_films
    @@best_films
  end

  def self.scrape_latest
    doc = Nokogiri::HTML(open("https://agoodmovietowatch.com/all/new/"))
    links = doc.css(".entry-title").map {|movie| movie.elements.first.first.last}
    @@latest = links.map {|movie_link| self.scrape_movie(movie_link)}
  end

  def self.latest
    @@latest
  end

  def display
    puts "Title: #{self.title} (#{self.year})"
    puts "Watch with #{self.watch_with}"
    puts "Watch when #{self.watch_when}"
    puts "Genre: #{self.genre}"
    puts "Selected review: #{self.review}"
    puts "Movie stars: #{self.stars}"
    puts "Movie rating: #{self.rating}"
    puts "Language: #{self.language}"
  end

end
