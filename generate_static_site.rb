start_page = JSON.parse(
  File.read(
    File.join(
      File.dirname(__FILE__),
      'metadata/page/page.start.json'
    )
  )
)

steps = start_page['steps']
next_page = steps.first

next_json = JSON.parse(
  File.read(
    File.join(
      File.dirname(__FILE__),
        "metadata/page/#{next_page}.json"
    )
  )
)
next_url = next_json['url']
