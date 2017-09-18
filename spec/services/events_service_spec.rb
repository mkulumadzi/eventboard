require 'rails_helper'

describe EventsService do

  let(:meetup_events) {
    [
      {
        "date" => "06/07/2017",
        "somekey" => "somevalue"
      },
      {
        "date" => "06/08/2017",
        "somekey" => "somevalue"
      },
      {
        "date" => "06/07/2017",
        "somekey" => "somevalue"
      }
    ]
  }

  let(:eventbrite_events) {
    [
      {
        "date" => "06/09/2017",
        "somekey" => "somevalue"
      },
      {
        "date" => "06/09/2017",
        "somekey" => "somevalue"
      },
      {
        "date" => "06/09/2017",
        "somekey" => "somevalue"
      }
    ]
  }

  before do
    expect_any_instance_of(MeetupClient).to receive(:find_events).and_return(meetup_events)
    expect_any_instance_of(EventbriteClient).to receive(:find_events).and_return(eventbrite_events)
  end

  describe 'find_events' do

    let(:query) { { lng: -105.027464, lat: 39.752422 } }
    let(:events) { subject.find_events(query)}

    it 'returns a hash' do
      expect(events).to be_instance_of(Hash)
    end

    it 'groups events with the same date' do
      expect(events['06/07/2017'].count).to eq(2)
      expect(events['06/08/2017'].count).to eq(1)
      expect(events['06/09/2017'].count).to eq(3)
    end

  end

end
