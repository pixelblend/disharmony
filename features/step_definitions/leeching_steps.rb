Then /^it should be downloaded$/ do
  stub_archive('simple-archive.zip')
  Disharmony::Leecher.leech(@shows)
  assert_equal 'downloaded', @shows.first.status
end
