# Welcome to Mercator

The Austrian Guided Selling Solution based on Hobo on Ruby on Rails

Mercator is a guided selling web application written using the Hobo web application framework.

## Dependencies

First of: There are lots of dependencies as we aim to write as little code as possible

* Hobo. Find more about Hobo including a full book on Hobo at http://www.hobocentral.net/
* Ruby on Rails. See http://rubyonrails.org/ for more.
* Ruby. https://www.ruby-lang.org/de/about/
* PostgresQL (The application should run on MySQL as well, but that is not supported in nay way)
*

FIXME! Links, all below me
FIXME! What is guided selling

## Getting Started

For ad development scenario or for testing out the applacation a somewhat slower but still
reasonably fast development instace can be fired up pretty fast

1. Install Ruby. In Linux environments we recommend rvm for doing this. See https://rvm.io/rvm/install for details
2. Install all gems needed by running <tt>bundle install</tt>
3. Create a database mercator_production using <tt>rake db:create</tt>
4. Start up your Server <tt>rails s</tt>

Your Mercator is now running and fully functional!

5. Visit <tt>http://localhost:3000</tt>
6. The first user registered will have administrator priviliges assigned
7. The second user registered will have sales priviliges assigned
8. The third and any further users registered will have customer priviliges assigned

FIXME! Second user should be sales guy