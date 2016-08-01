$LOAD_PATH << './lib'
require 'custom_redcarpet_html'

Time.zone = 'Sydney'

activate :blog do |blog|
  blog.name = 'poetry'

  blog.day_template = nil
  blog.layout = 'poetry'
  blog.month_template = nil
  blog.paginate = true
  blog.per_page = 20
  blog.permalink = '{title}.html'
  blog.prefix = 'poetry'
  blog.sources = 'articles/:title/index.html'
  blog.summary_length = 0
  blog.tag_template = nil
  blog.year_link = '{year}.html'
  blog.year_template = 'poetry/calendar.html'
end

activate :blog do |blog|
  blog.name = 'opinion'

  blog.day_template = nil
  blog.layout = 'opinion'
  blog.month_template = nil
  blog.paginate = true
  blog.per_page = 10
  blog.permalink = '{title}.html'
  blog.prefix = 'opinion'
  blog.sources = 'articles/:title/index.html'
  blog.summary_length = 0
  blog.tag_template = nil
  blog.year_link = '{year}.html'
  blog.year_template = 'opinion/calendar.html'
end

page '/poetry/feed.xml', layout: false
page '/opinion/feed.xml', layout: false

activate :livereload
# activate :relative_assets # too many bugs :-(
activate :directory_indexes
activate :syntax, line_numbers: true
set :relative_links, true
set :markdown_engine, :redcarpet
set :markdown, {
  tables: true,
  autolink: true,
  gh_blockcode: true,
  fenced_code_blocks: true,
  renderer: CustomRedcarpetHTML,
}
set :strip_index_file, true

configure :build do
  activate :asset_hash
  activate :minify_css
  # activate :minify_javascript # can't handle ES6 classes :-(
  activate :cache_buster
end
