#xml.instruct!
#xml.thumbnails do
#  @category.projects.include([:translations, :photos]).each do |project|
#    project.photos.each do |photo|
#      xml.thumbnail(
#        'title' => project.translation(I18n.locale).name,
#        'filename' => image_path(photo.data.url(:slide)),
#        'url' => project_path(I18n.locale, project)
#      )
#    end
#  end
#end
#
xml.instruct!
xml.images do
  @category.projects.include([:translations, :photos]).each do |project|
    project.photos.each_with_index do |photo, index|
      xml.image do
        xml.pic image_path(photo.data.url(:slide))
        xml.caption "#{project.translation(I18n.locale).name} ##{index+1}"
        xml.url project_path(I18n.locale, project)
      end
    end
  end
end
