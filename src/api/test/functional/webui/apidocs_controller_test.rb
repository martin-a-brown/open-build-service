require_relative '../../test_helper'

class Webui::ApidocsControllerTest < Webui::IntegrationTest

  def test_index
    # test relative links
    visit apidocs_path
    page.first('a', :text => 'Example').click
    assert page.source =~ %r{<title>Open Build Service API</title>}
  end

  def test_subpage
    skip("This test is correct but the apidocs tool is broken #952")
    visit apidocs_file_path(filename: 'whatisthis')
    find('#flash-messages').must_have_text "File not found"

    visit apidocs_path
    page.first('a', :href => 'architecture.xml').click
    assert page.html =~ %r{architecture name="x86_64"}
  end

  def test_broken_apidocs_setup
    old_location = CONFIG['apidocs_location']
    CONFIG['apidocs_location'] = '/your/mom'
    visit apidocs_path
    page.wont_have_link 'Example'
  ensure
    CONFIG['apidocs_location'] = old_location
  end
end
