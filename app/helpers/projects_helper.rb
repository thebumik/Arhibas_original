module ProjectsHelper
  def rating_output(project)
    if project.rating_total.blank?
      t('project.details.rating.notrated')
    else
      "%2.1f (#{t("project.details.rating.vote", :count => project.rating_total.to_i)})" % [project.rating_avg.to_f, project.rating_total.to_i]
    end
  end

  def one_comment(comment)
    result =  %{<li>}
    result += %{<p class="author">}
    result += %{<strong>#{h(comment.author)}</strong> #{t(:'project.details.comments.said')} #{l(comment.created_at, :format => :long)}}
    result += %{</p>}
    result += %{<p class="message">}
    result += h(comment.body).gsub(/\n+/, '<br />')
    result += %{</p>}
    result += %{<p class="awaiting_for_moderation">#{t(:'project.details.comments.moderation_await')}</p>} unless comment.active?
    result += %{</li>}
  end
end
