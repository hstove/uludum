namespace 'khan' do

  task scrape: :environment do
    k = Khan.new
    science_econ = k.library[1]
    micro = science_econ['items'][6]
    science_econ['items'].each do |category|
      next if category['items'].nil?
      cat = category['name']
      ap cat
      if category['items'][0]['items'].nil?
        course = Course.create teacher_id: 1, title: cat, category: "Science", description: 'blank'
        ap course.title
        category['items'].each do |s|
          playlist = s['playlist']
          section = Section.create course_id: course.id, title: playlist['title'], description: playlist['description']
          ap "#{course.title} - #{section.title}"
          playlist['videos'].each do |vid|
            body = "<iframe frameborder=\"0\" scrolling=\"no\" width=\"560\" height=\"355\" src=\"http://www.khanacademy.org/embed_video?v=#{vid['youtube_id']}\" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>"
            subsection = Subsection.create section_id: section.id, title: vid['title'], body: body
            ap "subsection: #{vid['title']}"
          end
        end
      end

      # category['items'].each do |c|
        # course = Course.create teacher_id: 1, title: c['name'], category: cat, description: 'blank'
        # ap "course: #{c['name']}"
        # c['items'].each do |s|
        #   section = Section.create course_id: course.id, title: s['name'], description: s['description']
        #   ap "section: #{s['name']}"
        #   s['playlist']['videos'].each do |vid|
        #     body = "<iframe frameborder=\"0\" scrolling=\"no\" width=\"560\" height=\"355\" src=\"http://www.khanacademy.org/embed_video?v=#{vid['youtube_id']}\" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>"
        #     subsection = Subsection.create section_id: section.id, title: vid['title'], body: body
        #     ap "subsection: #{vid['title']}"
        #   end
        # end
      # end
    end
  end

  task descriptions: :environment do
    khan = Khan.new
    Course.all.each do |c|
      description = khan.description_for_course(c)
      unless description.nil?
        ap "#{c.title} - #{description}"
        c.description = description
        c.save
      end
    end
  end
end