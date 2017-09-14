module MeetupSerializer

  extend ActiveSupport::Concern

  def serialize_meetups( meetups )
    meetups['results'].map{ |m| serialize_meetup(m) }
  end

  def serialize_meetup( meetup )
    meetup['time'] = time(meetup)
    meetup
  end

  def serialize_meetup_with_group( meetup, group )
    meetup['group'] = group # Meetup is already serialized
    meetup
  end

  private

  def time( meetup )
    t = Time.at(meetup['time'] / 1000)
    t.strftime('%a, %b %d %Y at %l:%M %P')
  end

end
