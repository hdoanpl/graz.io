###
# Page options, layouts, aliases and proxies
###

activate :directory_indexes
activate :syntax

set :relative_links, false #should be true
set :images_dir, 'images'
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :disable_indented_code_blocks => true, :smartypants => true, auto_ids: false

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page "/404.html", directory_index: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# activate :external_pipeline,
#   name: :npm,
#   command: "npm run start",
#   source: ".tmp"

activate :blog do | blog |
  blog.name = 'case'
  blog.prefix = 'case'
  blog.layout = 'case-layout'
  blog.permalink = ':title.html'
end

activate :blog do | verbose |
  verbose.name = 'blog'
  verbose.prefix = 'blog'
  verbose.layout = 'blog-layout'
  verbose.permalink = ':title.html'
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  # def nav_active(path)
  #   current_page.path == path ? "active" : ''
  # end
end

helpers do
  def markdown(text)
    Tilt['markdown'].new { text }.render
  end
end

activate :contentful do |f|
  f.access_token = 'e300c3de976fa349df685a08973ded272eb0cbb2dd3423ba2ee48753e1bc4ac5'
  f.space = { site: 'y77stanzu634'}
  f.rebuild_on_webhook = true
  f.content_types = {
    caseStudy: 'caseStudy',
    blog: 'blog'
  }
end


data.site.caseStudy.each do | id, this |
  proxy "/cases/#{this.title.parameterize}/index.html", "/cases/cases-template.html", :locals => { this: this }, :ignore => true
end

data.site.blog.each do | id, this |
  proxy "/blog/#{this.title.parameterize}/index.html", "/blog/blog-template.html", :locals => { this: this }, :ignore => true
end


# Build-specific configuration
configure :build do
  # activate :relative_assets
  # Minify CSS on build
  activate :minify_css
  # Minify Javascript on build
  activate :minify_javascript
end
