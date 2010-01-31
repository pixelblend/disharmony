class Disharmony::Show < DataMapper
  def tagged!
    complete!
  end
  
  def complete!
    self[:status] = :complete
  end
end
