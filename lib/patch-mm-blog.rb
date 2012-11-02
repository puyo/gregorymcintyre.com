require 'middleman-blog/paginator'

module Middleman
  module Blog
    class Paginator
      def page_sub(res, page_num, page_link)
        if page_num == 1
          # First page has an unmodified URL.
          res.path
        else
          page_url = apply_uri_template page_link, num: page_num
          ext_re = %r{(^|/)([^/]*)\.([^/]*)$}
          if res.path =~ ext_re # no directory_indexes, e.g. res.path == '/poetry/2014.html'
            res.path.sub(ext_re, "\\1\\2/#{page_url}.\\3")
          else # directory_indexes, e.g. res.path == '/poetry/2014' or '' or '/'
            "#{res.path.gsub(/\/$/, '')}/#{page_url}"
          end
        end
      end
    end
  end
end
