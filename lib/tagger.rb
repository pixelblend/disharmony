require 'id3lib'

class Disharmony::Tagger
  def tag_show(mp3)
    tag = ID3Lib::Tag.new(mp3, ID3Lib::V2)
    tag.artist = 'Harmony In My Head'
    tag.album = 'Harmony In My Head'
    tag.band = 'Henry Rollins'
    tag.track = '1'
    tag.content_type = 'Podcast'
    tag.lyrics = self.show_info[:track_list]
    tag.title = self.show_info[:title]
    tag.set_frame_text :PCST, '1'
    tag.set_frame_text :TDES, tag.lyrics
    tag.update!
  end
end
