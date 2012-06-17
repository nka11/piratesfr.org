# encoding: UTF-8
require "albino"
require "redcarpet"
require "digest/sha1"

# PiratesFr Flavored Markdown
#
# PiratesFr used markdown as its wiki syntax, but with some differences with the
# standard markdown:
#  * the heading levels for titles range from `<h2>` to `<h5>`
#  * `[[Foobar]]` is transformed to a link to wikipedia (http://fr.wikipedia.org/wiki/Foobar)
#  * URL are automatically transformed in links
#  * words with several underscores are left unchanged (no italics)
#  * PHP Markdown Extra-style tables are supported
#  * and some other extensions
#
class LFMarkdown < Redcarpet::Render::HTML
  PARSER_OPTIONS = {
    :no_intra_emphasis  => true,
    :tables             => true,
    :fenced_code_blocks => true,
    :autolink           => true,
    :strikethrough      => true,
    :superscript        => true
  }

  HTML_OPTIONS = {
    :filter_html        => true,
    :no_styles          => true,
    :hard_wrap          => true,
    :xhtml              => true
  }

  def self.render(text)
    text ||= ""
    html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
    toc = text.length > 5000 ? html_toc.render(text) : ""
    toc = "<h2 id=\"sommaire\">Sommaire</h2>\n#{toc}" unless toc.blank?
    markdown = Redcarpet::Markdown.new(self, PARSER_OPTIONS)
    html = markdown.render(text)
    toc + html
  end

  def initialize(extensions={})
    super extensions.merge(HTML_OPTIONS)
  end

  def preprocess(full_document)
    process_internal_wiki_links(full_document)
    process_wikipedia_links(full_document)
    full_document
  end

  def block_code(code, lang)
    colorized = Albino.new(code, lang || "text").colorize(:P => "nowrap")
    "<pre><code class=\"#{lang}\">#{colorized}</code></pre>"
  end

  def header(text, header_level)
    @toc_count ||= -1
    @toc_count  += 1
    l = header_level + 1
    "<h#{l} id=\"toc_#{@toc_count}\">#{text}</h#{l}>\n"
  end

  def strikethrough(text)
    "<s>#{text}</s>"
  end

  def link(link, title, content)
    link ||= "#"
    link.sub!("https://#{MY_DOMAIN}/", "http://#{MY_DOMAIN}/")
    t = " title=\"#{title}\"" unless title.blank?
    "<a href=\"#{CGI.escapeHTML link}\"#{t}>#{content}</a>"
  end

  def normal_text(text)
    text.gsub('« ', '«&nbsp;').
         gsub(/ ([:;»!?])/, '&nbsp;\1').
         gsub(' -- ', '—').
         gsub('...', '…')
  end

protected

  LF_LINK_REGEXP = /\[\[\[([ '\.:\-\p{Word}]+)\]\]\]/
  WP_LINK_REGEXP = /\[\[([ '\.+:!\-\(\)\p{Word}]+)\]\]/

  def process_internal_wiki_links(text)
    text.gsub!(LF_LINK_REGEXP, '[\1](/wiki/\1 "Lien du wiki interne PiratesFr.org")')
  end

  def process_wikipedia_links(text)
    text.gsub!(WP_LINK_REGEXP) do
      word = $1
      escaped = word.gsub(/\(|\)|'/) {|x| "\\#{x}" }
      parts = word.split(":")
      parts.shift if %w(en es eo de wikt).include?(parts.first)
      "[#{parts.join ':'}](http://fr.wikipedia.org/wiki/#{escaped} \"Définition Wikipédia\")"
    end
  end

end
