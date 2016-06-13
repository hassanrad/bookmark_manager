require_relative '../spec_helper'

feature 'View Bookmarks' do

  scenario 'View Bookmarks' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

    visit('/links')

    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end

end
