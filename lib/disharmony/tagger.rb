require 'id3lib'

class Disharmony::Tagger
  def self.tag!(show)
    Disharmony::Logger.info 'Tagging show'
    
    tag = ID3Lib::Tag.new(show.path, ID3Lib::V2)
    tag.artist = Disharmony::Config['show_info']['title']
    tag.album  = Disharmony::Config['show_info']['title']
    tag.band   = Disharmony::Config['show_info']['artist']
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
      :data        => File.read(Disharmony::Config['show_info']['cover_path'])
    }
    tag << cover

    tag.update!
    Disharmony::Logger.info 'Tagging complete'
    
    show.tagged!
    show
  end
end
