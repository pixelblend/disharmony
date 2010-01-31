require 'id3lib'

class Disharmony::Tagger
  def self.tag!(show)
    tag = ID3Lib::Tag.new(show.mp3, ID3Lib::V2)
    tag.artist = Disharmony::Options[:show_info][:title]
    tag.album  = Disharmony::Options[:show_info][:title]
    tag.band   = Disharmony::Options[:show_info][:artist]
    tag.track  = '1'
    tag.content_type = 'Podcast'
    tag.lyrics = show.track_list
    tag.title  = show.title
    tag.set_frame_text :PCST, '1'
    tag.set_frame_text :TDES, tag.lyrics
    # add album art
    cover = {
      :id          => :APIC,
      :mimetype    => 'image/jpeg',
      :picturetype => 3,
      :description => 'Cover Art',
      :textenc     => 0,
      :data        => File.read('himh.jpg')
    }
    tag << cover

    tag.update!
    
    show.tagged!
    show
  end
end
