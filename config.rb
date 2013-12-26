activate :livereload

I18n.enforce_available_locales = false

configure :build do
  activate :asset_hash
  activate :minify_css
  activate :minify_javascript
  activate :cache_buster
  activate :relative_assets
  set :relative_links, true
end
