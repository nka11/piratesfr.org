atom_feed(:root_url => wiki_pages_url) do |feed|
  feed.title("PiratesFr.org : les derniers changements dans le wiki")
  feed.updated(@versions.first.created_at)
  feed.icon("/favicon.png")

  @versions.each do |v|
    feed.entry(v, :url => polymorphic_url(v.wiki_page)) do |entry|
      entry.title("#{v.wiki_page.title} (révision #{v.version})")
      entry.content(link_to("Afficher le diff", "/wiki/#{v.wiki_page.to_param}/revisions/#{v.version}"), :type => 'html')
      entry.author do |author|
        author.name(v.user.try :name)
      end
    end
  end
end
