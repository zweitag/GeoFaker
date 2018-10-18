# Geofaker

## Installation
1. Install rbenv
2. Clone repo and enter it on a terminal
3. `rbenv install`
4. `gem install bundler`
5. `bundle install`

## Running Demo
1. Run `ruby demo/demo.rb`
2. Visit http://localhost:4567/within?q=Germany
3. Replace the Query Parameter with other values or even `within` with other options found in `demo/demo.rb`, hit enter and see what happens...

### Automatic code-reloading during development
1. Install [entr](http://www.entrproject.org/)
2. In the project root run `ls **/*.rb | entr -r ruby demo/demo.rb`
3. You will need to kill and restart this command whenever you add/delete/rename/move a ruby file.