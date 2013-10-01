# Slides for RubyGarage course

## Development

1. Add presentations to `./views` and amend `./app.rb` (`./views/awesome`, for example)
2. Run `rackup` and open browser to preview `open http://127.0.0.1:9292/awesome`
3. Add all the slides. Put images to `./assets/images/awesome` dir
4. Generate static files for it `rake static:generate path='/awesome'`
5. Run server to see if everything compiled `rackup` and preview `open http://127.0.0.1:9292/public/awesome/index.html`
