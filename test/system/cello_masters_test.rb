require "application_system_test_case"

class CelloMastersTest < ApplicationSystemTestCase
  setup do
    @cello_master = cello_masters(:one)
  end

  test "visiting the index" do
    visit cello_masters_url
    assert_selector "h1", text: "Cello Masters"
  end

  test "creating a Cello master" do
    visit cello_masters_url
    click_on "New Cello Master"

    fill_in "Capacity", with: @cello_master.capacity
    fill_in "Category", with: @cello_master.category
    fill_in "Company name", with: @cello_master.company_name
    fill_in "Divison", with: @cello_master.divison
    fill_in "Drp", with: @cello_master.drp
    fill_in "Mrp", with: @cello_master.mrp
    fill_in "Net rate", with: @cello_master.net_rate
    fill_in "Product name", with: @cello_master.product_name
    fill_in "Rate", with: @cello_master.rate
    fill_in "Scheme", with: @cello_master.scheme
    fill_in "Trade discount", with: @cello_master.trade_discount
    fill_in "Volume", with: @cello_master.volume
    click_on "Create Cello master"

    assert_text "Cello master was successfully created"
    click_on "Back"
  end

  test "updating a Cello master" do
    visit cello_masters_url
    click_on "Edit", match: :first

    fill_in "Capacity", with: @cello_master.capacity
    fill_in "Category", with: @cello_master.category
    fill_in "Company name", with: @cello_master.company_name
    fill_in "Divison", with: @cello_master.divison
    fill_in "Drp", with: @cello_master.drp
    fill_in "Mrp", with: @cello_master.mrp
    fill_in "Net rate", with: @cello_master.net_rate
    fill_in "Product name", with: @cello_master.product_name
    fill_in "Rate", with: @cello_master.rate
    fill_in "Scheme", with: @cello_master.scheme
    fill_in "Trade discount", with: @cello_master.trade_discount
    fill_in "Volume", with: @cello_master.volume
    click_on "Update Cello master"

    assert_text "Cello master was successfully updated"
    click_on "Back"
  end

  test "destroying a Cello master" do
    visit cello_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cello master was successfully destroyed"
  end
end
