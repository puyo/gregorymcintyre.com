$LOAD_PATH << './lib'
require 'custom_redcarpet_html'

Time.zone = 'Sydney'

def config_blog(blog, name)
  blog.day_template = nil
  blog.layout = name + '/_layout'
  blog.month_template = nil
  blog.name = name
  blog.paginate = true
  blog.per_page = 20
  blog.permalink = '{title}.html'
  blog.prefix = name
  blog.sources = ':title/index.html'
  blog.summary_length = 0
  blog.tag_template = nil
  cal = name + '/calendar'
  if Dir['source/' + cal + '*'].any?
    blog.year_link = '{year}.html'
    blog.year_template = cal
  end
end

activate(:blog) { |blog| config_blog(blog, 'poetry') }
activate(:blog) { |blog| config_blog(blog, 'opinion') }
activate(:blog) { |blog| config_blog(blog, 'slides') }

activate(:livereload) { |config| config.host = '0.0.0.0' }

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

# Disable warnings
Haml::TempleEngine.disable_option_validator!

activate :external_pipeline,
  name: :webpack,
  command: build? ?
    "BUILD_PRODUCTION=1 npx webpack --bail" :
    "BUILD_DEVELOPMENT=1 npx webpack --watch --devtool source-map --progress --color",
  source: ".tmp/dist",
  latency: 1
