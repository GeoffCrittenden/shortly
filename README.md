Shortly (Shurly)
=======

A URL shortening application

I decided to take another shot at creating the ubiquituous URL shortener.  I honestly have no idea how sites like bit.ly, twitter and google go about shortening URLs, so this is a total blind stab at it.

My first thought was to use base-36, since that seemed easiest.  That quickly broke down when I started to write methods to break urls into separate sections divided by periods and forward-slashes.  There was no way of creating a totally unique object for each url entered.

That's when I discovered base-64 encoding.  Or rather, re-discovered it.  I had used base-64 in the past for solving simple puzzles, but never for any practical application.  I had never known that it could handle pretty much any character thrown at it, as opposed to base-36, which only accepts alphanumerics.

It also turns out that Ruby has a Base64 library already built into it.  All you have to do is `require base64`.

My next challenge was to figure out how to actually shorten URLs in a useful way, since `Base64.encode64("https://www.google.com/search?q=google")` translates into `aHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS9zZWFyY2g/cT1nb29nbGU=\n`.  Not exactly efficient.

At first I thought that I could just use the first so many characters of the base-64 encoding, but then I found out that `http://www.` is the same, every time yielding `"aHR0cDov"`, regardless of what comes after it.