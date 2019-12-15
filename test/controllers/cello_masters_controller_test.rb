require 'test_helper'

class CelloMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cello_master = cello_masters(:one)
  end

  test "should get index" do
    get cello_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_cello_master_url
    assert_response :success
  end

  test "should create cello_master" do
    assert_difference('CelloMaster.count') do
      post cello_masters_url, params: { cello_master: { capacity: @cello_master.capacity, category: @cello_master.category, company_name: @cello_master.company_name, divison: @cello_master.divison, drp: @cello_master.drp, mrp: @cello_master.mrp, net_rate: @cello_master.net_rate, product_name: @cello_master.product_name, rate: @cello_master.rate, scheme: @cello_master.scheme, trade_discount: @cello_master.trade_discount, volume: @cello_master.volume } }
    end

    assert_redirected_to cello_master_url(CelloMaster.last)
  end

  test "should show cello_master" do
    get cello_master_url(@cello_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_cello_master_url(@cello_master)
    assert_response :success
  end

  test "should update cello_master" do
    patch cello_master_url(@cello_master), params: { cello_master: { capacity: @cello_master.capacity, category: @cello_master.category, company_name: @cello_master.company_name, divison: @cello_master.divison, drp: @cello_master.drp, mrp: @cello_master.mrp, net_rate: @cello_master.net_rate, product_name: @cello_master.product_name, rate: @cello_master.rate, scheme: @cello_master.scheme, trade_discount: @cello_master.trade_discount, volume: @cello_master.volume } }
    assert_redirected_to cello_master_url(@cello_master)
  end

  test "should destroy cello_master" do
    assert_difference('CelloMaster.count', -1) do
      delete cello_master_url(@cello_master)
    end

    assert_redirected_to cello_masters_url
  end
end
