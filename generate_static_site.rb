require 'json'
require 'erb'

class Metatron
  def initialize
    @pages = Dir['metadata/page/*.json'].map do |file|
      JSON.parse(File.read(
        File.join(
          File.dirname(__FILE__),
          file
        )
      ))
    end
    @html_pages = []
  end

  def html
    @steps = start_page['steps']
    @html_pages << start_page_html

    @steps.each_with_index do |step, index|
      page = @pages.find { |page| page['_id'] == step }

      template = File.read(
        File.join(File.dirname(__FILE__), "views/#{page['url']}.erb")
      )
      renderer = ERB.new(template)

      heading = page['heading']
      unless page['_type'] == 'page.confirmation'
        next_url = @pages.find { |page| page['_id'] == @steps[index + 1] }['url']
      end

      @html_pages << { "#{page['_id']}.html" => renderer.result(binding) }
    end
    @html_pages
  end

  def start_page
    @_start_page ||= @pages.find { |page| page['_type'] == 'page.start' }
  end

  def start_page_html
    index_template = File.read(
      File.join(File.dirname(__FILE__), 'views/index.erb')
    )
    renderer = ERB.new(index_template)
    heading = start_page['heading']
    lede = start_page['lede']
    next_page = @steps.first

    next_url = @pages.find { |page| page['_id'] == next_page }['url']

    { "#{start_page['_id']}.html" => renderer.result(binding) }
  end
end

puts Metatron.new.html
