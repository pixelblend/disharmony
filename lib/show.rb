class Disharmony::Show
  attr_accessor :active_download, :latest, :downloaded, :yml
  
  def initialize
    self.clear_lists
    self.load_downloaded_show_list_yml
  end
  
  def clear_lists
    self.latest, self.downloaded = Array.new, Array.new
  end
  
  protected
  def load_downloaded_show_list_yml
    self.yml = File.join(File.dirname(__FILE__), '..', 'config', 'shows.yml')
    
    yml_file = File.new(self.yml, 'r')
    self.downloaded = YAML::load(yml_file)
  end
end
