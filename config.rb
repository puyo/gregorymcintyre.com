require './lib/liquid-prompt'
require './lib/liquid-poem'
require './lib/liquid-img'
require './lib/ensmarten'

activate :livereload
activate :relative_assets
activate :directory_indexes
set :markdown_engine, :redcarpet
set :markdown, {
  tables: true,
  autolink: true,
  gh_blockcode: true,
  fenced_code_blocks: true,
  renderer: EnsmartenedHTML.new,
}

Time.zone = 'Sydney'

activate :blog do |blog|
  blog.permalink = 'poetry/{title}'
  blog.sources = 'poems/{year}-{month}-{day}-{title}.html'
  blog.year_link = 'poetry/{year}.html' # middleman-blog has bugs with this
  blog.name = 'poetry'
  blog.summary_length = 0
  blog.default_extension = '.markdown.liquid'
  blog.tag_template = nil
  blog.year_template = 'calendar.html'
  blog.paginate = true
  blog.per_page = 10
  blog.month_template = nil
  blog.day_template = nil
  blog.layout = 'poetry'
end

activate :blog do |blog|
  blog.name = 'opinions'
  blog.prefix = 'opinions'
  blog.year_link = '{prefix}/{year}'
  blog.summary_length = 0
  blog.default_extension = '.markdown.liquid'
  blog.tag_template = nil
  blog.year_template = 'calendar.html'
  blog.sources = "opinions/{title}.html"
  blog.permalink = "opinions/{category}/{title}.html"
  blog.paginate = true
  blog.per_page = 10
  blog.month_template = nil
  blog.day_template = nil
end

page '/poetry-feed.xml', layout: false

configure :build do
  activate :asset_hash
  activate :minify_css
  activate :minify_javascript
  activate :cache_buster
  set :relative_links, true
end
