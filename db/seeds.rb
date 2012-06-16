# encoding: UTF-8

# The logo
Logo.image = '/images/logos/PiratesFr2_classic.png'

# Langs
Lang['fr'] = 'Français'
Lang['en'] = 'Anglais'
Lang['de'] = 'Allemand'
Lang['it'] = 'Italien'
Lang['es'] = 'Espagnol'
Lang['fi'] = 'Finnois'
Lang['eu'] = 'Basque'
Lang['ja'] = 'Japonais'
Lang['ru'] = 'Russe'
Lang['pt'] = 'Portugais'
Lang['nl'] = 'Néerlandais'
Lang['da'] = 'Danois'
Lang['el'] = 'Grec'
Lang['sv'] = 'Suédois'
Lang['cn'] = 'Chinois'
Lang['pl'] = 'Polonais'
Lang['ct'] = 'Catalan'
Lang['no'] = 'Norvégien'
Lang['ko'] = 'Coréen'
Lang['xx'] = '!? hmmm ?!'

# Category
%w(Autres Administration Commentaires CSS Dépêches Forums Journaux Modération Entretiens Proposition Recherche Sondages Sites\ amis Suivi Toolbar Tribune XMPP).each do |cat|
  Category.create(:title => cat)
end

# Responses
Response.create(:title => "Copie de dépêche externe",    :content => "La dépêche que vous avez proposée n'est qu'une copie d'un article\nprovenant d'un autre site (en partie ou en entier), que de plus vous ne possédez pas.\nNous refusons ce genre d'article, même si la source est citée.")
Response.create(:title => "Dépêche trop courte",         :content => "La dépêche que vous avez proposée a été considérée trop courte pour être\nvalidée sur PiratesFr.org. En effet, nous n'acceptons que des dépêches de\nplusieurs lignes, comme celles qui passent sur le site habituellement.")
Response.create(:title => "Dépêche déjà publiée",        :content => "Le sujet de la dépêche que vous avez proposée a déjà fait l'objet d'une\ndépêche publiée sur PiratesFr.org. Pour cette raison, votre dépêche a été\nrefusée.")
Response.create(:title => "Dépêche déjà proposée",       :content => "Une ou plusieurs autres dépêches sur le même sujet a (ont) déjà été\nproposée(s) par un (ou plusieurs) autre(s) internaute(s). Dès qu'un\nmodérateur pourra s'en occuper, il utilisera celle qui lui semble la\nmieux rédigée.")
Response.create(:title => "Dépêche hors sujet",          :content => "La dépêche que vous avez envoyée est hors-sujet par rapport au site. Si\nPiratesFr.org valide parfois les dépêches hors-sujet, celle-ci n'a pas\nretenu l'attention des modérateurs.")
Response.create(:title => "Redirection forum",           :content => "Une entrée dans un forum serait plus adaptée pour poser cette question.\nNous tenons à vous remercier de l'avoir proposée, et nous\nvous encourageons à la poser dans un des forums du site.\n\nhttp://PiratesFr.org/posts/nouveau")
Response.create(:title => "Redirection journal",         :content => "Votre journal est peut-être plus adapté pour passer cette information.\n\nhttp://PiratesFr.org//journaux/nouveau")
Response.create(:title => "Problèmes de rédaction",      :content => "Cette dépêche pose des problèmes de rédaction, et il nous est difficile\nde la valider telle quelle. Pourriez-vous re-rédiger cette dépêche s'il\nvous plaît ?")
Response.create(:title => "Site (presque) vide",         :content => "PiratesFr.org préfère valider des dépêches de ce type quand le site est\ndéjà bien avancé. Si d'ici quelques temps, c'est le cas, n'hésitez pas\nà re-proposer une dépêche.")
Response.create(:title => "Version mineure du logiciel", :content => "Votre dépêche traite d'une version mineure d'un logiciel, et n'apporte\nrien de fort d'un point de vue information. Pour cette raison elle a été\nrefusée.")

# Friend sites
FriendSite.create(:title => "April", :url => "http://www.april.org/")
FriendSite.create(:title => "Framasoft", :url => "http://www.framasoft.net/")
FriendSite.create(:title => "Veni, Vedi, Libri", :url => "http://www.venividilibri.org/")
FriendSite.create(:title => "InLibroVeritas", :url => "http://www.inlibroveritas.net/PiratesFr.html")


# Pages
dir = File.join(File.dirname(__FILE__), 'pages')
Dir.chdir(dir) do
  Dir["*.html"].each do |file|
    slug  = File.basename(file, '.html')
    body  = File.read(file)
    title = slug.capitalize.tr('_', ' ')
    Page.create(:slug => slug, :title => title, :body => body)
  end
end

# Anonymous account
Account.reset_column_information
anon = Account.new
anon.login = "Anonyme"
anon.role  = "inactive"
anon.email = "anonyme@PiratesFr.org"
anon.encrypted_password = "XXX"
anon.skip_confirmation!
anon.save

# Wiki
wp = WikiPage.new
wp.title = WikiPage::HomePage
wp.wiki_body = <<EOS
Le wiki de PiratesFr.org
======================

Fonctionnement
--------------

Cet espace est un [wiki](http://fr.wikipedia.org/wiki/Wiki), c'est-à-dire un endroit où tous les utilisateurs (du moins, ceux qui sont authentifiés) peuvent écrire.
Pour créer une page, le plus simple est de faire un lien vers cette page en utilisant la syntaxe `[[[`MaPage`]]]` puis de cliquer sur ce lien.
Si la page n'existe pas encore, un formulaire vous sera proposée pour la créer.

Les pages principales
---------------------

C'est à **vous** de jouer et de créer ces pages ;-)
Voici quelques pages qu'il serait intéressant d'avoir :

- [[[FAQ]]] : une foire aux questions pour aider les débutants (et les utilisateurs plus réguliers) à mieux connaître le site
- [[[PierreTramo]]], [[[42]]], [[[Templeet]]] : le bestiaire de PiratesFr.org
- [[[Astuces]]] : des astuces sur Linux et les Logiciels Libres.
EOS
wp.save
wp.reload
wp.node.update_attribute(:user_id, 1)
