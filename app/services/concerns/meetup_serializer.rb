module MeetupSerializer

  extend ActiveSupport::Concern

  def serialize_meetups( meetups )
    meetups['results'].map{ |m| serialize_meetup(m) }
  end

  def serialize_meetup( meetup )
    time, date = time_and_date_strings( meetup )
    meetup['time'] = time
    meetup['date'] = date
    meetup
  end

  def serialize_meetup_with_group( meetup, group )
    meetup['group'] = group # Meetup is already serialized
    meetup
  end

  private

  def time_and_date_strings( meetup )
    t = timevalue(meetup)
    time = t.strftime('%a, %b %d %Y at %l:%M %P')
    date = t.strftime('%a, %b %d')
    [time, date]
  end

  def timevalue( meetup )
    Time.at(meetup['time'] / 1000)
  end

end
