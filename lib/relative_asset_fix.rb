# A fix for the relative assets + blog extension combo
class RelativeAssetFix < ::Middleman::Extension
  def initialize(app, *args)
    app.set :current_template_file, nil
    app.before_render do |body, path, locs, template_class|
      app.set :current_template_file, path if File.exist?(path)
      body
    end
    super
  end

  helpers do
    def asset_url(asset_path, prefix='')
      if current_template_file && template_path = sitemap.file_to_path(current_template_file)
        template_directory = Pathname(source_dir).join(template_path).dirname
        relative_asset_file = template_directory.join(asset_path)
        if relative_asset_file.exist?
          '/' + current_resource.store.file_to_path(relative_asset_file.to_s)
        else
          super
        end
      else
        super
      end
    end
  end
end

::Middleman::Extensions.register(:relative_asset_fix, RelativeAssetFix)
