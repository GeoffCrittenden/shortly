Shur.ly (Shortly)
=======

A URL shortening application

I decided to take another shot at creating the ubiquituous URL shortener.  I honestly have no idea how sites like bit.ly, twitter and google go about shortening URLs, so this is a total blind stab at it.

My first thought was to use base-36, since that seemed easiest.  That quickly broke down when I started to write methods to break urls into separate sections divided by periods and forward-slashes.  There was no way of creating a totally unique object for each url entered.

That's when I discovered base-64 encoding.  Or rather, re-discovered it.  I had used base-64 in the past for solving simple puzzles, but never for any practical application.  I had never known that it could handle pretty much any character thrown at it, as opposed to base-36, which only accepts alphanumerics.

It also turns out that Ruby has a Base64 library already built into it.  All you have to do is `require 'base64'`.

My next challenge was to figure out how to actually shorten URLs in a useful way, since `Base64.encode64("https://www.google.com/search?q=google")` translates into `aHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS9zZWFyY2g/cT1nb29nbGU=\n`.  Not exactly efficient.

At first I thought that I could just use the first so many characters of the base-64 encoding, but then I found out that `http://www.` is the same, every time yielding `"aHR0cDov"`, regardless of what comes after it.  So if I truncate everything after the first six characters, then there would be no unique shortened URLs.

My solution to this is simple.  First, we determine the unique object id using `.maximum(:id).next`.  We then call `.to_s` on that, throw out the `http://` or `https://` if there is one, and run a `Base64` encoding on the result of combining the id and the URL body.

Example:
If the URL to be shortened is: `https://www.google.com/search?q=shurly`, we ask for the next id number in the table.

  `id = Shortly.maximum(:id).next.to_s` => 1
  
Then, the url gets run through some quick regex to scrub the `http://`.

  `lead = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])[1]` => https://
  `body = /(\Ahttps?:\/\/www\.|\Ahttps?:\/\/)(.+)/.match(params[:url])[2]` => www.google.com/search?q=shurly

Next, we then combine `id` and `body` and run a `Base64` encoding on that string.

  `shortly = Base64.encode64(id + body)[0..5]` => "MXd3dy"
  
Of course, we also run a full encoding, so that the original URL can be reconstructed.

  `longly = Base64.encode64(id + body)` => "MXd3dy5nb29nbGUuY29tL3NlYXJjaD9xPXNodXJseQ==\n"
  
Using the shortly as the params, or splat, we can then search the database via a GET request.

  Example: `http://shur.ly/MXd3dy` yields a PostgreSQL query that yields the URL  `https://www.google.com/search?q=shurly` and redirects to it.
  
###Issues:

Right now, there is no security built in with Shur.ly.  A malicious user could redirect someone to a bad website using this service.

There is also an issue with Heroku not always recognizing the naked domain of Shur.ly when a GET request is made.  So sometimes `http://shur.ly/MXd3dy` results in an Internal Servor Error while `http://www.shur.ly/MXd3dy` will always result in a successful redirect.
  
