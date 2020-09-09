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
  end

  def html
    @pages.map do |page|
      if page['_type'] == 'page.start'
        index_template = File.read(
          File.join(File.dirname(__FILE__), 'views/index.erb')
        )
        renderer = ERB.new(index_template)
        heading = page['heading']
        lede = page['lede']
        steps = page['steps']
        next_page = steps.first

        next_url = @pages.find { |page| page['_id'] == next_page }['url']

        { "#{page['_id']}.html" => renderer.result(binding) }
      end
    end
  end
end

puts Metatron.new.html
