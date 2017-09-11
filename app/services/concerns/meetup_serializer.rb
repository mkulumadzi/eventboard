module MeetupSerializer

  extend ActiveSupport::Concern

  def serialize_meetups( meetups )
    meetups.map{ |m| serialize_meetup(m) }
  end

  private

  def serialize_meetup( meetup )
    meetup['time'] = time(meetup)
    meetup['description'] = description(meetup)
    meetup
  end

  def time( meetup )
    t = Time.at(meetup['time'] / 1000)
    t.strftime('%a, %b %Y at %l:%M %P')
  end

  def description( meetup )
    Sanitize.fragment(meetup['description'])
      .strip
      .gsub(/\s+/," ")
  end

end
