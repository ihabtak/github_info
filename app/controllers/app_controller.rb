class AppController < ApplicationController
  def index
  end

  def show
    if !SearchHistory.exists? ["q_username = ?", params[:username]]
      SearchHistory.create(:q_username=>params[:username])
    end
    user_id = Github::User.get_user_id(params[:username])
    @user = Github::User.find(params[:username], user_id.id)
    top_langs = {}
    @user.contributions_collection.commit_contributions_by_repository.each do |repository|
      repository.repository.languages.nodes.each do |lang|
        if top_langs.key?(lang.name)
          top_langs[lang.name] = top_langs[lang.name] + 1
        else
          top_langs[lang.name] = 1
        end
      end
    end
    @top_langages = top_langs.sort_by {|k, v| v}.reverse[0..2]
    if !SearchHistory.exists? ["q_username = ?", params[:username]]
      SearchHistory.create(:q_username=>params[:username], :name=>@user.name)
    end
  end

  def list_history
    @search_history = SearchHistory.last(20)
  end

  skip_before_action :verify_authenticity_token
end
