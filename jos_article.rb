require 'jos_models'
@password = Digest::MD5.hexdigest("exotic123456")
@mkp = 0
ActiveRecord::Base.establish_connection(
            :adapter => "mysql",
            :host => "localhost",
            :username => "root",
            :database => "clearsenses_v3"
					)

def article_migrate
	articles = ArticleNew.all
	articles.each do |article|
		jos_article = JosContent.create(:title => article.title,
											:alias => article.title,
											:introtext => article.content,
											:state => 1,
											:sectionid => 5,
											:catid => 34,
											:created => article.date_added,
											:created_by => 62,
											:publish_up => article.date_added,
											:attribs => "show_title=link_titles=show_intro=show_section=link_section=show_category=link_category=show_vote=",
											:hits => article.ticker,
											:metadata => "robots=author="
											)
			reviews = ArticleReview.find_all_by_article_id(article.id)
			reviews.each do |review|
				jos_user = JosUser.create(	:name => review.name,
												:username => "exotic_#{review.id}#{@mkp}",
												:email => "exotic_#{review.id}#{@mkp}@exoticindia.com",
												:password=> @password, 
												:usertype => "Registered" 
											)
				JosWebeeComment.create(:articleId => jos_article.id ,
															 :content => review.comments,
															 :handle => jos_user.id,
															 :isUser => 1,
															 :email => "exotic_#{review.id}#{@mkp}@exoticindia.com"
															)
				@mkp += 1
			end
	end
end
