FROM ruby:2.3.0-onbuild
EXPOSE 9292
CMD ["bundle", "exec", "rackup"]
