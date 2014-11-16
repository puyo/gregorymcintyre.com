$LOAD_PATH << './lib'
require 'liquid_prompt'
require 'liquid_poem'
require 'liquid_img'
require 'custom_redcarpet_html'
require 'relative_asset_fix'

Time.zone = 'Sydney'

activate :blog do |blog|
  blog.day_template = nil
  blog.default_extension = '.markdown.liquid'
  blog.layout = 'poetry'
  blog.month_template = nil
  blog.name = 'poetry'
  blog.paginate = true
  blog.per_page = 20
  blog.prefix = 'poetry'
  blog.permalink = '{title}.html'
  blog.sources = 'articles/:title.html'
  blog.summary_length = 0
  blog.tag_template = nil
  blog.year_link = '{year}.html' # middleman-blog has bugs with this
  blog.year_template = 'poetry/calendar.html'
end

activate :blog do |blog|
  blog.day_template = nil
  blog.default_extension = '.markdown'
  blog.layout = 'opinion'
  blog.month_template = nil
  blog.name = 'opinion'
  blog.prefix = 'opinion'
  blog.paginate = true
  blog.per_page = 10
  blog.permalink = '{title}.html'
  blog.sources = 'articles/:title/index.html'
  blog.summary_length = 0
  blog.tag_template = nil
  blog.year_link = '{year}.html'
  blog.year_template = 'opinion/calendar.html'
end

page '/poetry/feed.xml', layout: false
page '/opinion/feed.xml', layout: false

activate :livereload
activate :relative_assets
activate :relative_asset_fix
activate :directory_indexes
activate :syntax, line_numbers: true
set :relative_links, true
set :markdown_engine, :redcarpet
set :markdown, {
  tables: true,
  autolink: true,
  gh_blockcode: true,
  fenced_code_blocks: true,
  renderer: CustomRedcarpetHTML.new,
}
set :strip_index_file, true

configure :build do
  activate :asset_hash
  activate :minify_css
  activate :minify_javascript
  activate :cache_buster
end
