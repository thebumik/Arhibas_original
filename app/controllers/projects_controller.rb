class ProjectsController < ApplicationController
  # filters
  before_filter :cookies_init

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id], :include => :translations)
    @project_translation = @project.translation(params[:locale])

    # get real ip address
    ip = real_remote_addr(request.env)

    # get ids from cookies
    ids_from_cookies = ActiveSupport::JSON.decode(cookies[:moderation_msg]).to_a

    # fetch comments
    @comments = @project.comments.scoped :conditions => ["id in (?) OR active = ?", ids_from_cookies, true], :order => "created_at DESC"

    # check is current user allowed to vote or not
    @cannot_vote = @project.votes.first(:conditions => ['updated_at >= ? and ip = ?', Time.zone.today, ip]) unless @project.votes.blank?

    render 'show_soft' if @project.category.id.eql?(97)
  end

  def vote
    ip = real_remote_addr(request.env)
    project = Project.find(params[:id])
    project.rating_last_value = params[:rating]

    # get vote
    if project.votes.blank?
      vote = project.votes.build :ip => ip
    else
      vote = project.votes.find_or_initialize_by_ip(ip)
    end

    # save rating
    project.save_rating! if vote.new_record? || !vote.updated_at.today?

    # get result
    result = {
      :rating => ApplicationController.helpers.rating_output(project),
      :message => t(:'project.details.rating.message')
    }

    # output
    render :json => result.to_json
  end

  def comment
    return if params[:comment].blank? || params[:project_id].blank?

    project = Project.find(params[:project_id])
    comment = project.comments.build :author => params[:comment][:author], :body => params[:comment][:body]

    if comment.save
      # write cookies
      cookies[:moderation_msg] = {
        :value    => ActiveSupport::JSON.decode(cookies[:moderation_msg]).to_a.push(comment.id).to_json,
        :expires  => 30.days.from_now
      }

      result = {
        :comment    => ApplicationController.helpers.one_comment(comment),
        :validation => nil
      }
    else
      result = {
        :comment    => "",
        :validation => comment.errors.map(&:first)
      }
    end

    # now render it
    render :json => result.to_json
  end

  private
    def cookies_init
      cookies[:moderation_msg] ||= [].to_json
    end

    def real_remote_addr(env)
      env['REMOTE_ADDR'].eql?('127.0.0.1') && env['HTTP_X_REAL_IP'] ? env['HTTP_X_REAL_IP'] : env['REMOTE_ADDR']
    end
end
