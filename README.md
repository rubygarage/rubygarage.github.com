# Slides for RubyGarage course

## How to start Jekyll in development mode

Execute the command:

```bash
$ jekyll s --config _config.yml,_config_dev.yml --trace --profile --incremental
```

Visit this URL: http://localhost:4000


## How to generate diagrams

### Install graphviz.

For Ubuntu execute this command:

```bash
$ sudo apt-get install graphviz
```

For macOS execute this command:

```bash
$ brew install graphviz --with-freetype --with-librsvg
```

### Generate diagram

Next run following command:

```bash
$ dot -T svg -O filename.dot
```


## Documentation

- [Markwown](https://help.github.com/categories/writing-on-github/)
- [Jekyll](https://jekyllrb.com/docs/home/)
- [Reveal.js](https://github.com/hakimel/reveal.js)
- [Graphviz](http://www.graphviz.org/Documentation.php)


## License

![CC_BY](https://i.creativecommons.org/l/by/4.0/88x31.png "Creative Commons Attribution 4.0 International License")

This project is licensed under a Creative Commons Attribution 4.0 International License.
See a [human-readable summary](http://creativecommons.org/licenses/by/4.0/)
or an [entire document](http://creativecommons.org/licenses/by/4.0/legalcode).
