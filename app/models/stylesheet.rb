# encoding: utf-8
# The contrib stylesheets.
#
class Stylesheet < Struct.new(:name, :url, :image)
  BASE_DIR = Rails.root.join("app/assets/stylesheets/contrib")

  def self.include?(css)
    Dir["#{BASE_DIR.sub '/contrib', ''}/#{css}*css"].any?
  end

  def self.all
    Dir["#{BASE_DIR}/*css"].map do |scss|
      css = File.basename scss.sub(/.scss$/, ''), '.css'
      url = "contrib/#{css}"
      png = "/stylesheets/contrib/#{css}.png"
      Stylesheet.new(css, url, png)
    end.shuffle
  end

  def self.temporary(account, url, &blk)
    original = account.stylesheet
    account.stylesheet = url
    account.save
    yield blk
  ensure
    account.stylesheet = original
    account.save
  end

  def self.capture(url, cookies)
    dst = "tmp/snapshot_#{rand 1000}.png"
    key = PiratesfrOrg::Application::COOKIE_STORE_KEY
    val = cookies[key]
    Dir.chdir Rails.root.join("public") do
      timeout 30 do
        `wkhtmltoimage --crop-h 1024 --cookie '#{key}' '#{val}' '#{url}' #{dst}`
        `mogrify -resize 400x400 #{dst} 2>&1`
      end
    end
    dst
  end

end
